//
//  CustomAlert.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 29.09.2023.
//

import UIKit

class CustomAlert {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private var mainView: UIView? = nil
    private var setTextField = BrounTextField()
    private var repsTextField = BrounTextField()
    
    private var buttonAction: ((String, String) -> Void)?
    
    func presentCustomAlert(viewController: UIViewController,
                            repsOrTimer: String,
                            completion: @escaping (String,String) -> Void) {
        
        registerForKeybardNotification()
        
        guard let parentView = viewController.view else { return }
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40, y: -420,
                                 width: parentView.frame.width - 80,
                                 height: 420)
        scrollView.addSubview(alertView)
        
        let sportsmanView = UIImageView(frame: CGRect(x: (alertView.frame.width - alertView.frame.height * 0.4) / 2,
                                                      y: 30,
                                                      width: alertView.frame.height * 0.4,
                                                      height: alertView.frame.height * 0.4))
        sportsmanView.image = UIImage(named: "sportsmanAlert")
        sportsmanView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmanView)
        
        let editingLabel = UILabel(text: "Editing", font: .robotoMedium22(), textColor: .specialBlack)
        editingLabel.frame = CGRect(x: 20, y: sportsmanView.frame.maxY + 30,
                                    width: alertView.frame.width - 40,
                                    height: 24)
        editingLabel.textAlignment = .center
        editingLabel.translatesAutoresizingMaskIntoConstraints = true
        alertView.addSubview(editingLabel)
        
        let setsLabel = UILabel(text: "Sets")
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect(x: 30,
                                 y: editingLabel.frame.maxY + 5,
                                 width: 100,
                                 height: 15)
        alertView.addSubview(setsLabel)
        
        setTextField.frame = CGRect(x: 20,
                                    y: setsLabel.frame.maxY,
                                    width: alertView.frame.width - 40,
                                    height: 30)
        setTextField.translatesAutoresizingMaskIntoConstraints = true
        setTextField.keyboardType = .numberPad
        alertView.addSubview(setTextField)
        
        let repsOrTimerLabel = UILabel(text: repsOrTimer)
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect(x: 30,
                                 y: setTextField.frame.maxY + 5,
                                 width: 100,
                                 height: 15)
        alertView.addSubview(repsOrTimerLabel)
        
        repsTextField.frame = CGRect(x: 20,
                                    y: repsOrTimerLabel.frame.maxY,
                                    width: alertView.frame.width - 40,
                                    height: 30)
        repsTextField.translatesAutoresizingMaskIntoConstraints = true
        repsTextField.keyboardType = .numberPad
        alertView.addSubview(repsTextField)
        
        let okButton = GreenButton(text: "OK")
        okButton.frame = CGRect(x: 50,
                                y: repsTextField.frame.maxY + 15,
                                width: alertView.frame.width - 100,
                                height: 35)
        okButton.translatesAutoresizingMaskIntoConstraints = true
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = completion
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }

    }
    @objc private func okButtonTapped() {
        guard let setNumber = setTextField.text,
              let repsNumber = repsTextField.text else { return }
        buttonAction?(setNumber, repsNumber)
        
        guard let targetView = mainView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.height,
                                          width: targetView.frame.width - 80,
                                          height: 420)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0.0
            } completion: { done in
                if done {
                    self.scrollView.removeFromSuperview()
                    self.setTextField.text = ""
                    self.repsTextField.text = ""
                    self.removeForKeybardNotification()
                }
            }
        }
    }
    
    private func registerForKeybardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeForKeybardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc private func kbWillShow() {
        self.scrollView.contentOffset = CGPoint(x: 0, y: 100)
    }
    
    @objc private func kbWillHide() {
        self.scrollView.contentOffset = .zero
    }
}
