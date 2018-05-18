//
//  DetailedStartUpViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

class DetailedStartUpViewController: UIViewController {
    
    
    @IBOutlet weak var startupImageView: AttributedImageView!
    @IBOutlet weak var startupNameLabel: UILabel!
    @IBOutlet weak var startupDescriptionLabel: UILabel!
    
    var startup: Startup?
    
    private func setStartupDetails() {
        startupNameLabel.text = startup?.name
        startupDescriptionLabel.text = startup?.description
        if let url = startup?.photoURL {
            ImageManager.downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.startupImageView.image = image
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStartupDetails()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func likeStartup(_ sender: UIButton) {
        
    }
    

}
