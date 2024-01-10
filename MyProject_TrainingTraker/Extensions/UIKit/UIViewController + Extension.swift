//
//  UIViewController + Extension.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 22.09.2023.
//

import UIKit

extension UIViewController {
    func presentSimpleAlert(_ title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okButton)
        
        present(alertController, animated: true)
    }
    
    func presentAlertWithAction(_ title: String, message: String? = nil, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        let canselButton = UIAlertAction(title: "Cansel", style: .cancel)
        alertController.addAction(okButton)
        alertController.addAction(canselButton)
        
        present(alertController, animated: true)
    }
    
    func alertPhotoOrCamera(completionHandler: @escaping (UIImagePickerController.SourceType) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction (title: "Camera", style: .default) { _ in
            let camera = UIImagePickerController.SourceType.camera
            completionHandler(camera)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
            let photoLibrary = UIImagePickerController.SourceType.photoLibrary
            completionHandler(photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        
        present (alertController, animated: true)
    }
}
