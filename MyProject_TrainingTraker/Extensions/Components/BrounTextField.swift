//
//  BrounTextField.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 13.09.2023.
//

import UIKit

protocol BrounTextFieldProtocol: AnyObject {
    
    func typing(range: NSRange, replacementString: String)
    func clear()
}

class BrounTextField: UITextField {
    
    weak var brounDelegate: BrounTextFieldProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        textColor = .specialGray
        font = .robotoBold20()
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0)) // для сдвигания курсора от края текстфилда
        leftViewMode = .always
        clearButtonMode = .always
        returnKeyType = .done
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension BrounTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        brounDelegate?.typing(range: range, replacementString: string)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        brounDelegate?.clear()
        return true
    }
}
