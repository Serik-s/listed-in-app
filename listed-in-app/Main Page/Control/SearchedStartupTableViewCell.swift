//
//  SearchedStartupTableViewCell.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 18.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

class SearchedStartupTableViewCell: UITableViewCell {

    @IBOutlet weak var startupImageView: UIImageView!
    @IBOutlet weak var startupNameLabel: UILabel!
    @IBOutlet weak var startupDescriptionLabel: UILabel!
    
    var info: Startup? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let startup = info else { return }
        
        startupNameLabel.text = "\(startup.name)"
        startupDescriptionLabel.text = "\(startup.description)"
        if let url = startup.photoURL {
            ImageManager.downloadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.startupImageView.image = image
                }
            }
        }
        
    }
}
