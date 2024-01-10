//
//  ProfileViewController.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 05.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileLabel = UILabel(text: "PROFILE", font: .robotoBold24(), textColor: .specialGray)
    
    private let userPhotoImageView: UIImageView = {
        let userImage = UIImageView()
        userImage.backgroundColor = .specialLine
        userImage.image = UIImage(named: "addPhoto")
        userImage.contentMode = .center
        userImage.clipsToBounds = true
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
    
    private let userNameLabel = UILabel(text: "IGOR BELOV", font: .robotoBold24(), textColor: .white)
    private let userHeightLabel = UILabel(text: "Height: 178", font: .robotoBold16(), textColor: .specialGray)
    private let userWeightLabel = UILabel(text: "Weight: 102", font: .robotoBold16(), textColor: .specialGray)
    
    private lazy var userHeightWeightStackView = UIStackView(arrangedSubviews: [userHeightLabel, userWeightLabel],
                                                             axis: .horizontal,
                                                             spacing: 10)

    private let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Editing", for: .normal)
        button.setImage(UIImage(named: "profileEditing"), for: .normal)
        button.tintColor = .specialGreen
        button.titleLabel?.font = .robotoBold16()
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .right
        button.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        button.backgroundColor = .none
        return button
    }()
    
    private let proggresCollectionView = ProgressCollectionView()
    private let targetWorkoutLabel = UILabel(text: "TARGET: 20 workouts", font: .robotoBold16(), textColor: .specialGray)
    private let currentProgressNumberLabel = UILabel(text: "2", font: .robotoBold24(), textColor: .specialGray)
    private let finishProgressNumberLabel = UILabel(text: "20", font: .robotoBold24(), textColor: .specialGray)
    
    private lazy var progressLabelsStackView = UIStackView(arrangedSubviews: [currentProgressNumberLabel, finishProgressNumberLabel],
                                                             axis: .horizontal,
                                                             spacing: 10)
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .specialBrown
        progressView.progressTintColor = .specialGreen
        progressView.layer.cornerRadius = 14
        progressView.clipsToBounds = true
        progressView.setProgress(0, animated: false)
        progressView.layer.sublayers?[1].cornerRadius = 14
        progressView.subviews[1].clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        proggresCollectionView.getResultWorkout()
        setUserParametrs()
    }
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height / 2
    }
    
    private func setupView() {
        view.backgroundColor = .specialBackground
        view.addSubview(profileLabel)
        profileLabel.textAlignment = .center
        profileLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(menuBackgroundView)
        view.addSubview(userPhotoImageView)
        menuBackgroundView.addSubview(userNameLabel)
        userNameLabel.textAlignment = .center
        userNameLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(userHeightWeightStackView)
        userHeightWeightStackView.distribution = .fillProportionally
        view.addSubview(editingButton)
        editingButton.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        view.addSubview(proggresCollectionView)
        proggresCollectionView.progressDelegate = self
        view.addSubview(targetWorkoutLabel)
        progressLabelsStackView.distribution = .equalSpacing
        view.addSubview(progressLabelsStackView)
        view.addSubview(progressView)
    }
    
    @objc private func editingButtonTapped() {
        let editingVC = EditingProfileViewController()
        editingVC.modalPresentationStyle = .fullScreen
        present(editingVC, animated: true)
    }
    
    private func setUserParametrs() {
        let usersArray = RealmManager.shared.getResultUserModel()
        if !usersArray.isEmpty {
            userNameLabel.text = usersArray[0].userFirstName + " " + usersArray[0].userSecondName
            userHeightLabel.text = "Height: \(usersArray[0].userHeight)"
            userWeightLabel.text = "Weight: \(usersArray[0].userWeight)"
            targetWorkoutLabel.text = "TARGET: \(usersArray[0].userTarget) workouts"
            finishProgressNumberLabel.text = "\(usersArray[0].userTarget)"
            
            guard let data = usersArray[0].userImage,
                  let image = UIImage(data: data) else { return }
            userPhotoImageView.image = image
            userPhotoImageView.contentMode = .scaleAspectFill
        }
    }
}

//MARK: - ProgressCollectionViewProtocol

extension ProfileViewController: ProgressCollectionViewProtocol {
    func tappedCell() {
        progressView.setProgress(0.5, animated: true)
    }
}

//MARK: - Set Constraints

extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            profileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            menuBackgroundView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 65),
            menuBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            menuBackgroundView.heightAnchor.constraint(equalToConstant: 110),
            
            userPhotoImageView.centerYAnchor.constraint(equalTo: menuBackgroundView.topAnchor),
            userPhotoImageView.centerXAnchor.constraint(equalTo: menuBackgroundView.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.bottomAnchor.constraint(equalTo: menuBackgroundView.bottomAnchor, constant: -15),
            userNameLabel.leadingAnchor.constraint(equalTo: menuBackgroundView.leadingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: menuBackgroundView.trailingAnchor, constant: -10),
            
            userHeightWeightStackView.centerYAnchor.constraint(equalTo: editingButton.centerYAnchor),
            userHeightWeightStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userHeightWeightStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            userHeightWeightStackView.heightAnchor.constraint(equalToConstant: 20),
            
            editingButton.topAnchor.constraint(equalTo: menuBackgroundView.bottomAnchor, constant: 10),
            editingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editingButton.heightAnchor.constraint(equalToConstant: 30),
            editingButton.widthAnchor.constraint(equalToConstant: 150),
            
            proggresCollectionView.topAnchor.constraint(equalTo: userHeightWeightStackView.bottomAnchor, constant: 25),
            proggresCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            proggresCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            proggresCollectionView.heightAnchor.constraint(equalToConstant: 240),
            
            targetWorkoutLabel.topAnchor.constraint(equalTo: proggresCollectionView.bottomAnchor, constant: 20),
            targetWorkoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            targetWorkoutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressLabelsStackView.topAnchor.constraint(equalTo: targetWorkoutLabel.bottomAnchor, constant: 15),
            progressLabelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            progressLabelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            progressView.topAnchor.constraint(equalTo: progressLabelsStackView.bottomAnchor, constant: 5),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
