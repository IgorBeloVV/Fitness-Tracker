//
//  EditingProfileViewController.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 05.10.2023.
//

import UIKit
import PhotosUI

class EditingProfileViewController: UIViewController {
    
    private let profileLabel = UILabel(text: "EDITING PROFILE", font: .robotoBold24(), textColor: .specialGray)
    
    private lazy var closeButton = CloseButton(type: .system)
    
    private let userPhotoImageView: UIImageView = {
        let userImage = UIImageView()
        userImage.backgroundColor = .specialLine
        userImage.image = UIImage(named: "addPhoto")
        userImage.clipsToBounds = true
        userImage.contentMode = .center
        userImage.layer.borderWidth = 5
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.translatesAutoresizingMaskIntoConstraints = false
        return userImage
    }()
    
    private let menuBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstNameTextFieldView = ProfileTextFieldView(text: "First name")
    private let secondNameTextFieldView = ProfileTextFieldView(text: "Second name")
    private let heightTextFieldView = ProfileTextFieldView(text: "Height")
    private let weightTextFieldView = ProfileTextFieldView(text: "Weight")
    private let targetTextFieldView = ProfileTextFieldView(text: "Target")
    
    private lazy var fieldsStackView = UIStackView(arrangedSubviews: [firstNameTextFieldView,
                                                                      secondNameTextFieldView,
                                                                      heightTextFieldView,
                                                                      weightTextFieldView,
                                                                      targetTextFieldView],
                                                   axis: .vertical,
                                                   spacing: 15)
    
    private let saveButton = GreenButton(text: "SAVE")
    
    private var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        addTap()
        loadUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    private func setupView() {
        view.backgroundColor = .specialBackground
        profileLabel.textAlignment = .center
        view.addSubview(profileLabel)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(menuBackgroundView)
        view.addSubview(userPhotoImageView)
        view.addSubview(fieldsStackView)
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        setUserModel()
        
        let usersArray = RealmManager.shared.getResultUserModel()
        
        if usersArray.count == 0 {
            RealmManager.shared.saveUserModel(userModel)
        } else {
            RealmManager.shared.updateUserModel(model: userModel)
        }
        userModel = UserModel()
    }
    
    private func addTap() {
        let imageTapped = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        userPhotoImageView.isUserInteractionEnabled = true
        userPhotoImageView.addGestureRecognizer(imageTapped)
    }
    
    @objc private func setUserPhoto() {
        alertPhotoOrCamera { [weak self] source in
            guard let self else { return }
            
            if #available(iOS 14.0, *) {
                self.presentPhPicker()
            } else {
                self.chooseImagePicker(source: source)
            }
        }
    }
    
    private func setUserModel() {
        guard let firstName = firstNameTextFieldView.textField.text,
              let secondName = secondNameTextFieldView.textField.text,
              let height = heightTextFieldView.textField.text,
              let weight = weightTextFieldView.textField.text,
              let target = targetTextFieldView.textField.text,
              let intWeight = Int(weight),
              let intHeight = Int(height),
              let intTarget = Int(target) else {
            return
        }
        userModel.userFirstName = firstName
        userModel.userSecondName = secondName
        userModel.userHeight = intHeight
        userModel.userWeight = intWeight
        userModel.userTarget = intTarget
        
        if userPhotoImageView.image == UIImage(named: "addPhoto") {
            userModel.userImage = nil
        } else {
            guard let image = userPhotoImageView.image else { return }
            let jpegData = image.jpegData(compressionQuality: 1.0)
            userModel.userImage = jpegData
        }
    }
    
    private func loadUserInfo() {
        let usersArray = RealmManager.shared.getResultUserModel()
        if !usersArray.isEmpty {
            firstNameTextFieldView.textField.text = usersArray[0].userFirstName
            secondNameTextFieldView.textField.text = usersArray[0].userSecondName
            heightTextFieldView.textField.text = "\(usersArray[0].userHeight)"
            weightTextFieldView.textField.text = "\(usersArray[0].userWeight)"
            targetTextFieldView.textField.text = "\(usersArray[0].userTarget)"
            
            guard let imageData = usersArray[0].userImage,
                  let image = UIImage(data: imageData) else { return }
            
            userPhotoImageView.image = image
            userPhotoImageView.contentMode = .scaleAspectFill
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension EditingProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func chooseImagePicker(source:UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        userPhotoImageView.image = image
        userPhotoImageView.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
}
@available(iOS 14.0, *)
extension EditingProfileViewController: PHPickerViewControllerDelegate {
 
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self.userPhotoImageView.image = image
                    self.userPhotoImageView.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    private func presentPhPicker() {
        var phPickerConfigure = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfigure.selectionLimit = 1
        phPickerConfigure.filter = PHPickerFilter.any(of: [.images])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfigure)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    
}

//MARK: - Set Constraints

extension EditingProfileViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            profileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            closeButton.centerYAnchor.constraint(equalTo: profileLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            menuBackgroundView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 65),
            menuBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            menuBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            
            userPhotoImageView.centerYAnchor.constraint(equalTo: menuBackgroundView.topAnchor),
            userPhotoImageView.centerXAnchor.constraint(equalTo: menuBackgroundView.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
        
            firstNameTextFieldView.heightAnchor.constraint(equalToConstant: 60),
            secondNameTextFieldView.heightAnchor.constraint(equalToConstant: 60),
            heightTextFieldView.heightAnchor.constraint(equalToConstant: 60),
            weightTextFieldView.heightAnchor.constraint(equalToConstant: 60),
            targetTextFieldView.heightAnchor.constraint(equalToConstant: 60),
            
            fieldsStackView.topAnchor.constraint(equalTo: menuBackgroundView.bottomAnchor, constant: 40),
            fieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
