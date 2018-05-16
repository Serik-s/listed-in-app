//
//  AttributedView.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 12.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit

@IBDesignable class AttributedView: UIView {

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
    
    @IBInspectable var shadowColor: UIColor? {
        didSet { layoutSubviews() }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet { layoutSubviews() }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet { layoutSubviews() }
    }
    
    @IBInspectable var masksToBounds: Bool = false {
        didSet { layoutSubviews() }
    }
    
    @IBInspectable var shadowMargin: UIEdgeInsets = .zero {
        didSet { layoutSubviews() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bounds.origin.x += shadowMargin.left
        bounds.origin.y += shadowMargin.top
        bounds.size.width -= shadowMargin.left + shadowMargin.right
        bounds.size.height -= shadowMargin.top + shadowMargin.bottom
        
        layer.masksToBounds = masksToBounds
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        
        setNeedsDisplay()
    }

}
