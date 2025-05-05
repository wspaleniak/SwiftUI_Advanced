//
//  CloudKitExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 01/02/2025.
//



// MARK: - NOTES

// MARK: 25 - Creating a reusable utility class for CloudKit code
///
/// - ONLY CODE



// MARK: - CODE

import CloudKit
import Combine
import Foundation

// MARK: - MODEL

protocol CloudKitModelProtocol {
    var record: CKRecord { get }
    init?(from model: CKRecord)
    func update(_ newName: String) -> Self?
}

struct CloudKitModel: CloudKitModelProtocol, Hashable {
    let name: String
    let record: CKRecord
    let imageURL: URL?
    
    init?(name: String, imageURL: URL?) {
        let record = CKRecord(recordType: "Fruits")
        record["name"] = name
        if let imageURL {
            let asset = CKAsset(fileURL: imageURL)
            record["image"] = asset
        }
        self.init(from: record)
    }
    
    init?(from model: CKRecord) {
        guard let name = model["name"] as? String else {
            return nil
        }
        let imageAsset = model["image"] as? CKAsset
        self.name = name
        self.record = model
        self.imageURL = imageAsset?.fileURL
    }
    
    func update(_ newName: String) -> Self? {
        record["name"] = newName
        return .init(from: record)
    }
}

// MARK: - MANAGER

struct CloudKitManager {
    
    // MARK: - Enums
    
    enum ErrorType: String, LocalizedError {
        case noAccount
        case couldNotDetermine
        case restricted
        case temporarilyUnavailable
        case permissionNotGranted
        case userRecordIdNotAvailable
        case userIdentityNotAvailable
        case unknown
    }
}

// MARK: - USER METHODS

extension CloudKitManager {
    
    // MARK: - Status
    
    static func getStatus() -> Future<Bool, Error> {
        Future { promise in
            getStatus { promise($0) }
        }
    }
    
    static private func getStatus(completion: @escaping (Result<Bool, Error>) -> Void) {
        CKContainer.default().accountStatus { status, _ in
            switch status {
            case .available: completion(.success(true))
            case .noAccount: completion(.failure(ErrorType.noAccount))
            case .couldNotDetermine: completion(.failure(ErrorType.couldNotDetermine))
            case .restricted: completion(.failure(ErrorType.restricted))
            case .temporarilyUnavailable: completion(.failure(ErrorType.temporarilyUnavailable))
            @unknown default: completion(.failure(ErrorType.unknown))
            }
        }
    }
    
    // MARK: - Request permission
    
    static func requestPermission() -> Future<Bool, Error> {
        Future { promise in
            requestPermission { promise($0) }
        }
    }
    
    static private func requestPermission(completion: @escaping (Result<Bool, Error>) -> Void) {
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { status, error in
            switch status {
            case .granted: completion(.success(true))
            default: completion(.failure(ErrorType.permissionNotGranted))
            }
        }
    }
    
    // MARK: - User identity
    
    static func discoverUserIdentity() -> Future<String, Error> {
        Future { promise in
            discoverUserIdentity { promise($0) }
        }
    }
    
    static private func discoverUserIdentity(completion: @escaping (Result<String, Error>) -> Void) {
        fetchUserRecordID { result in
            switch result {
            case .success(let recordID):
                discoverUserIdentity(recordID, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static private func discoverUserIdentity(_ recordID: CKRecord.ID, completion: @escaping (Result<String, Error>) -> Void) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: recordID) { identity, error in
            guard let name = identity?.nameComponents?.givenName else {
                completion(.failure(ErrorType.userIdentityNotAvailable))
                return
            }
            completion(.success(name))
        }
    }
    
    static private func fetchUserRecordID(completion: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID else {
                completion(.failure(ErrorType.userRecordIdNotAvailable))
                return
            }
            completion(.success(recordID))
        }
    }
}

// MARK: - CRUD METHODS

extension CloudKitManager {
    
    // MARK: - Fetch items
    
    static func fetch<T: CloudKitModelProtocol>(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil
    ) -> Future<[T], Never> {
        Future { promise in
            fetch(
                predicate: predicate,
                recordType: recordType,
                sortDescriptors: sortDescriptors,
                resultsLimit: resultsLimit
            ) { items in
                promise(.success(items))
            }
        }
    }
    
    static private func fetch<T: CloudKitModelProtocol>(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil,
        completion: @escaping ([T]) -> Void
    ) {
        var fetchedItems: [T] = []
        let operation = getOperation(
            predicate: predicate,
            recordType: recordType,
            sortDescriptors: sortDescriptors,
            resultsLimit: resultsLimit
        )
        addRecordMatched(operation: operation) { item in
            fetchedItems.append(item)
        }
        addQueryResult(operation: operation) { finished in
            completion(fetchedItems)
        }
        add(operation: operation)
    }
    
    static private func getOperation(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptors: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil
    ) -> CKQueryOperation {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = resultsLimit ?? CKQueryOperation.maximumResults
        return queryOperation
    }
    
    static private func addRecordMatched<T: CloudKitModelProtocol>(
        operation: CKQueryOperation,
        completion: @escaping (T) -> Void
    ) {
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                guard let item = T(from: record) else {
                    return
                }
                completion(item)
            case .failure:
                break
            }
        }
    }
    
    static private func addQueryResult(
        operation: CKQueryOperation,
        completion: @escaping (Bool) -> Void
    ) {
        operation.queryResultBlock = { result in
            completion(true)
        }
    }
    
    static private func add(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // MARK: - Save (Add, Update) item
    
    static func save<T: CloudKitModelProtocol>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        CKContainer.default().publicCloudDatabase.save(item.record) { record, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // MARK: - Delete item
    
    static func delete<T: CloudKitModelProtocol>(item: T) -> Future<Bool, Error> {
        Future { promise in
            delete(item: item, completion: promise)
        }
    }
    
    static private func delete<T: CloudKitModelProtocol>(
        item: T,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: item.record.recordID) { recordID, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
