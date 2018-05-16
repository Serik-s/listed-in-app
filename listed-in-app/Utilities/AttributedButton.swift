//
//  AttributedButton.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

@IBDesignable class AttributedButton: UIButton {
    
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
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0)
            setNeedsDisplay()
        }
    }
    
}
