//
//  UILabel + Extensions.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 08.09.2023.
//

import UIKit

extension UILabel {
    
    convenience init(text: String) {
        self.init()
        self.text = text
        self.font = .robotoMedium14()
        self.textColor = .specialLightBrown
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.8
        translatesAutoresizingMaskIntoConstraints = false
    }
   
    convenience init(text: String, font: UIFont?, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
