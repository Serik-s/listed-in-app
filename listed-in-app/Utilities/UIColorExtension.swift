//
//  UIColorExtension.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit


extension UIColor {
    
    // MARK: - конструкторы
    // принимает rgb(int'овые значения и возвращает цвет)
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: 1)
    }
    
    // принимает hex code и возвращает цвет
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF,
                  green: (hex >> 8) & 0xFF,
                  blue: hex & 0xFF)
    }
    
}


