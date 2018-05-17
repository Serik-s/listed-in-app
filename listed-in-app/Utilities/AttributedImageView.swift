//
//  AttributedImageView.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

@IBDesignable class AttributedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            guard let borderColor = borderColor else { return }
            
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    

}
