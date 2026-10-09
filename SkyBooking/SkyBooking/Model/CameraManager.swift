//
//  CameraManager.swift
//  SkyBooking
//
//

import UIKit
import SwiftUI

struct CameraManager: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    var selectedSource : UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let myPicker = UIImagePickerController()
        myPicker.sourceType = selectedSource
        myPicker.delegate = context.coordinator
        return myPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: CameraManager
        
        
        init(parent: CameraManager) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let anImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = anImage
                parent.dismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
        
    }
    
}


