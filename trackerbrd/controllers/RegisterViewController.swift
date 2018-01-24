//
//  RegisterViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/17/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var uploadImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func uploadImagePressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Upload image", message: "From where you want to upload?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.chooseImagePicker(source: .camera)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cansel = UIAlertAction(title: "Cansel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cansel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func chooseImagePicker(source: UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.allowsEditing = true
            imgPicker.sourceType = source
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let img = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        uploadImage.setImage(img, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}













