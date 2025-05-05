//
//  SwiftUIAdvancedApp.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 27/10/2024.
//

import SwiftUI

@main
struct SwiftUIAdvancedApp: App {
    
    // MARK: UI Testing
    // MARK: Arguments Passed On Launch
    let isSignedIn: Bool
    init() { isSignedIn = ProcessInfo.processInfo.arguments.contains("~UITest_startSignedIn") }
    // init() { isSignedIn = CommandLine.arguments.contains("~UITest_startSignedIn") }
    //
    // MARK: Environment Variables
    // let isSignedIn: String
    // init() { isSignedIn = ProcessInfo.processInfo.environment["~UITest_startSignedIn2"] ?? "" }
    
    var body: some Scene {
        WindowGroup {
            // MARK: UI Testing
            // UITestingExampleView(
            //     isSignedIn: isSignedIn
            // )
            
            // MARK: Property Wrappers
            PropertyWrappers2Example()
        }
    }
}
