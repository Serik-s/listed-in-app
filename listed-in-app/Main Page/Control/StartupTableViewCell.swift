//
//  StartupTableViewCell.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

enum CurrencyCellState: Int {
    case selected = 1
    case nonSelected = 0
}


class StartupTableViewCell: UITableViewCell {
    
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
