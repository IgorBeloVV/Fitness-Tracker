//
//  RepsStartWorkoutViewController.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 21.09.2023.
//

import UIKit

class RepsStartWorkoutViewController: UIViewController {
    
    private let startWorkoutLabel = UILabel(text: "START WORKOUT",
                                            font: .robotoMedium24(),
                                            textColor: .specialGray)
    private let closeButton = CloseButton(type: .system)
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sportsman")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let detailsWorkoutLabel = UILabel(text: "Details")
    private let detailsWorkoutView = RepsDetailsWorkoutView()
    
    private lazy var finishButton = GreenButton(text: "FINISH")
    private let customAlert = CustomAlert()
    
    private var workoutModel = WorkoutModel()
    private var numberOfSet = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    private func setupViews() {
        view.backgroundColor = .specialBackground
        startWorkoutLabel.textAlignment = .center
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(imageView)
        view.addSubview(detailsWorkoutLabel)
        detailsWorkoutView.cellNextSetDelegate = self
        detailsWorkoutView.refreshLabels(workoutModel, numberOfSet: numberOfSet)
        view.addSubview(detailsWorkoutView)
        view.addSubview(finishButton)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            RealmManager.shared.updateStatusWorkoutModel(workoutModel)
            dismiss(animated: true)
        } else {
            presentAlertWithAction("Warning", message: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    func setWorkoutModel(_ model: WorkoutModel){
        workoutModel = model
    }
}

extension RepsStartWorkoutViewController: NextSetProtocol {
    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            detailsWorkoutView.refreshLabels(workoutModel, numberOfSet: numberOfSet)
        } else {
            presentSimpleAlert("Error", message: "Finish your workout")
        }
    }
    
    func editingTapped() {
        customAlert.presentCustomAlert(viewController: self, repsOrTimer: "Reps") { [weak self] sets, reps in
            guard let self else { return }
            
            if sets != "" && reps != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfReps = Int(reps) else { return }
                
                RealmManager.shared.updateWorkoutModel(self.workoutModel, sets: numberOfSets, reps: numberOfReps)
                self.detailsWorkoutView.refreshLabels(self.workoutModel, numberOfSet: self.numberOfSet)
            }
        }
    }
}

//MARK: - Set Constraints

extension RepsStartWorkoutViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            imageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 190),
            
            detailsWorkoutLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            detailsWorkoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsWorkoutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            detailsWorkoutView.topAnchor.constraint(equalTo: detailsWorkoutLabel.bottomAnchor),
            detailsWorkoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsWorkoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsWorkoutView.heightAnchor.constraint(equalToConstant: 250),
            
            finishButton.topAnchor.constraint(equalTo: detailsWorkoutView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
