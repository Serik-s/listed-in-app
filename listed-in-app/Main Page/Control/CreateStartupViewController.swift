//
//  CreateStartupViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class CreateStartupViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var startupImageView: UIImageView!
    
    var photoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func uploadImageClick(_ sender: Any) {
        handleSelectProfileImageView()
        getImageUrl()
    }
    
    
    @IBAction func addNewStartup() {
        let name = nameTextField.text!
        let description = descriptionTextField.text!
        
        let owner = Auth.auth().currentUser?.displayName
        let userID = Auth.auth().currentUser?.uid
        
//        getImageUrl()
       
        
        let startup = Startup(name: name, description: description, photoURL: self.photoURL!, owner: owner)
        let startupJSON = Startup.setStartupInDictionary(startup)
        Startup.addStartup(startupJSON, userID:  userID!)
    }
    
    private func getImageUrl() {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("startup_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.startupImageView.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                
                //                let size = metadata?.size
                storageRef.downloadURL { (url, error) in
                    guard let imageURL = url else {
                        print(error ?? "no error")
                        return
                    }
                    self.photoURL = imageURL
                    
                    
                }
            })
        }
    }
    
   
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            startupImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
