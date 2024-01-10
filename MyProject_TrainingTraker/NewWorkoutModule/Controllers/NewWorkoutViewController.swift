//
//  NewWorkoutViewController.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 12.09.2023.
//

import UIKit

class NewWorkoutViewController: UIViewController {
    
    private let newWorkout = UILabel(text: "NEW WORKOUT",
                                     font: .robotoBold24(),
                                     textColor: .specialGray)
    private lazy var closeButton = CloseButton(type: .system)
    private let nameView = NameView()
    private let dateAndRepeatView = DateAndRepeat()
    private let repsOrTimerView = RepsOrTimerView()
    private let imageLabel = UILabel(text: "Icon workout")
    var iconName: String?
    private let imageCollectionView = ImageCollectionView()
    private let saveButton = GreenButton(text: "SAVE")
    
    private var workoutModel = WorkoutModel()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [nameView,
                                                               dateAndRepeatView,
                                                               repsOrTimerView],
                                             axis: .vertical,
                                             spacing: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegate()
        addGesture()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        newWorkout.textAlignment = .center
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(newWorkout)
        view.addSubview(closeButton)
        view.addSubview(stackView)
        view.addSubview(imageLabel)
        view.addSubview(imageCollectionView)
        imageCollectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .top)
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTatted), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTatted() {
        setModel()
        saveModel()
    }
    
    private func setModel() {
        workoutModel.workoutName = nameView.getNameTextFieldText()
        
        let dateWorkout = dateAndRepeatView.getDateAndRepeat().date.localDate()
        workoutModel.workoutDate = dateWorkout
        workoutModel.workoutRepeat = dateAndRepeatView.getDateAndRepeat().isRepeat
        workoutModel.workoutNumberOfDay = dateWorkout.getWeekDayNumber()
        
        workoutModel.workoutSets = repsOrTimerView.sets
        workoutModel.workoutReps = repsOrTimerView.reps
        workoutModel.workoutTimer = repsOrTimerView.timer
        
        workoutModel.workoutImageName = iconName
    }
    
    private func saveModel() {
        let text = nameView.getNameTextFieldText()
        let count = text.filter { $0.isNumber || $0.isLetter }.count
        
        if count != 0 &&
            workoutModel.workoutSets != 0 &&
            (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) {
            RealmManager.shared.saveWorkoutModel(workoutModel)
            createNotification()
            workoutModel = WorkoutModel()
            presentSimpleAlert("Success")
            resetValues()
        } else {
            presentSimpleAlert("Error", message: "Enter all parameters")
        }
    }
    
    private func resetValues() {
        nameView.resetTextTextField()
        dateAndRepeatView.resetDateAndRepeat()
        repsOrTimerView.resetSliderViewValues()
        imageCollectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .top)
    }
    
    private func setDelegate() {
        imageCollectionView.iconNameDelegate = self
    }
    
    private func addGesture() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeScreen)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func createNotification() {
        let notification = Notifications ()
        let stringId = workoutModel.workoutDate.getDateId()
        notification.scheduleDateNotification(date: workoutModel.workoutDate, id: "workout \(stringId)")
    }
}

//MARK: - IconeNamePropocol

extension NewWorkoutViewController: IconNamePropocol {
    func getIconName(iconName: String) {
        self.iconName = iconName
    }
}

//MARK: - Set Constraints

extension NewWorkoutViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            newWorkout.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newWorkout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: newWorkout.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            nameView.heightAnchor.constraint(equalToConstant: 60),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 115),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 300),
        
            stackView.topAnchor.constraint(equalTo: newWorkout.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            imageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageCollectionView.topAnchor.constraint(equalTo: imageLabel.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            saveButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
