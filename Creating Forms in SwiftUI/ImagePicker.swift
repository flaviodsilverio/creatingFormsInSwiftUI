//
//  ImagePicker.swift
//  Creating Forms in SwiftUI
//
//  Created by Flávio Silvério on 12/12/2023.
//

import Foundation
import SwiftUI

struct BaseView: View {
    @State var showSelection: Bool = false
    @State var showPicker: Bool = false
    @State var type: UIImagePickerController.SourceType = .photoLibrary

     var body: some View {

           ZStack {
               Button("Text") {
                   showSelection = true
               }
           }
           .confirmationDialog("Select Image Source",
                           isPresented: $showSelection,
                           titleVisibility: .hidden) {
           
           Button("Camera") {
               showPicker = true
               type = .camera
           }
           
           Button("Photos") {
               showPicker = true
               type = .photoLibrary
            
           }
       }
       .fullScreenCover(isPresented: $showPicker) {
           ImagePickerView(sourceType: type) { image in
                // image your image
           }
       }

     }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    private var sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    
    @Environment(\.presentationMode) private var presentationMode
    
    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void
        
        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        public func imagePickerController(_ picker: UIImagePickerController,
                                          didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.onImagePicked(image)
            }
            self.onDismiss()
        }
        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }
    }
}

#Preview {
    BaseView()
}
