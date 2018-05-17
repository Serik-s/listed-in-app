//
//  CreateStartupViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateStartupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func addNewStartup() {
        let name = nameTextField.text!
        let description = descriptionTextField.text!
        let photoURL = URL(string: "https://www.facebook.com/photo.php?fbid=426369177748846&set=a.141999109519189.1073741826.100011273029471&type=3&theater")
        
        let owner = Auth.auth().currentUser?.displayName
        let userID = Auth.auth().currentUser?.uid
        
        let startup = Startup(name: name, description: description, photoURL: photoURL!, owner: owner)
        let startupJSON = Startup.setStartupInDictionary(startup)
        Startup.addStartup(startupJSON, userID:  userID!)
    }
}
