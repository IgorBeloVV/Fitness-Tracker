//
//  ProfileTextFieldView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 05.10.2023.
//

import UIKit

class ProfileTextFieldView: UIView {
    
    private let textLabel = UILabel(text: "")
    let textField = BrounTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text: String) {
        self.init()
        textLabel.text = text
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textLabel)
        addSubview(textField)
    }
}


//MARK: - Set Constraints

extension ProfileTextFieldView {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            textLabel.heightAnchor.constraint(equalToConstant: 20),
            
            textField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
