//
//  GreenButton.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 15.09.2023.
//

import UIKit

class GreenButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init(type: .system)
        self.setTitle(text, for: .normal)
        
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialGreen
        tintColor = .white
        titleLabel?.font = .robotoBold16()
        layer.cornerRadius = 10
    }
}
