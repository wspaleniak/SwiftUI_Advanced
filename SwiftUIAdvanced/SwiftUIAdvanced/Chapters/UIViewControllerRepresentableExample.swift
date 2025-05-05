//
//  UIViewControllerRepresentableExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 19/11/2024.
//



// MARK: - NOTES

// MARK: 14 - Use UIViewControllerRepresentable to convert UIKit controllers to SwiftUI
///
/// - `UIViewControllerRepresentable` pozwala umieszczać cały `UIViewController` wewnątrz kodu w `SwiftUI`
/// - całość działa identycznie jak w przypadku używania `UIViewRepresentable`
/// - różnicą jest to że w tym przypadku rzadko kiedy używa się wymaganej do zaimplementowania metody `updateUIViewController(...)`



// MARK: - CODE

import SwiftUI

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    // MARK: - Classes
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // MARK: - Properties
        
        @Binding
        var image: UIImage?
        
        @Binding
        var show: Bool
        
        // MARK: - Init
        
        init(image: Binding<UIImage?>, show: Binding<Bool>) {
            _image = image
            _show = show
        }
        
        // MARK: - Methods
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            guard let newImage = info[.originalImage] as? UIImage else {
                return
            }
            image = newImage
            show = false
        }
    }
    
    // MARK: - Properties
    
    @Binding
    var image: UIImage?
    
    @Binding
    var show: Bool
    
    // MARK: - Methods
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //...
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, show: $show)
    }
}



struct UIViewControllerRepresentableExample: View {
    
    // MARK: - Properties
    
    @State
    private var image: UIImage? = nil
    
    @State
    private var showImagePicker: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        if let image  {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onTapGesture {
                    showImagePicker.toggle()
                }
        }
        Button("Choose image") {
            showImagePicker.toggle()
        }
        .sheet(
            isPresented: $showImagePicker,
            content: {
                UIImagePickerControllerRepresentable(image: $image, show: $showImagePicker)
            }
        )
    }
}

// MARK: - Preview

#Preview {
    UIViewControllerRepresentableExample()
}
