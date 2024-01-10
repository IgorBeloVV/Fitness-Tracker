//
//  StatisticViewController.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 08.09.2023.
//

import UIKit

class StatisticViewController: UIViewController {
    
    private let statisticLabel = UILabel(text: "STATISTICS", font: .robotoMedium24(), textColor: .specialGray)
    private let exercisesLabel = UILabel(text: "Exercises")
    private let statisticsTable = StatisticsTableView()
    private let nameTextField = BrounTextField()
    
    private var differenceArray = [DifferenceWorkout]()
    private var filteredArray = [DifferenceWorkout]()
    
    private var isFiltered = false
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Week", "Month"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .specialGreen
        segment.selectedSegmentTintColor = .specialYellow
        let font = UIFont.robotoMedium16()
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                        .font: font as Any],
                                       for: .normal)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.specialGray,
                                        .font: font as Any],
                                       for: .selected)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        segmentedChange()
        updatingTableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        segmentedChange()
    }
    
    private func setupView() {
        view.backgroundColor = .specialBackground
        statisticLabel.textAlignment = .center
        view.addSubview(statisticLabel)
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        view.addSubview(nameTextField)
        nameTextField.brounDelegate = self
        view.addSubview(exercisesLabel)
        view.addSubview(statisticsTable)
    }
    @objc private func segmentedChange() {
        let dayToday = Date()
        differenceArray = [DifferenceWorkout]()
        if segmentedControl.selectedSegmentIndex == 0 {
            let dateStart = dayToday.ofsetDay(days: 7)
            getDifferenceModels(startDate: dateStart)
        } else {
            let dateStart = dayToday.ofsetMonth(month: 1)
            getDifferenceModels(startDate: dateStart)
        }
        statisticsTable.setDifferenceArray(differenceArray)
        statisticsTable.reloadData()
    }
    
    private func getDifferenceModels(startDate: Date) {
        let endDate = Date()
        let nameArray = RealmManager.shared.getWorkoutsName()
        let allWorkouts = RealmManager.shared.getResultWorkoutModel()
        
        for name in nameArray {
            let predicate = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [startDate, endDate])
            let filteredArray = allWorkouts.filter(predicate).sorted(byKeyPath: "workoutDate").map{ $0 }
            
            var lastReps = 0
            var firstReps = 0
            var lastTimer = 0
            var firstTimer = 0
            
            if filteredArray.last?.workoutTimer == 0 {
                lastReps = filteredArray.last?.workoutReps ?? 0
                firstReps = filteredArray.first?.workoutReps ?? 0
            } else {
                lastTimer = filteredArray.last?.workoutTimer ?? 0
                firstTimer = filteredArray.first?.workoutTimer ?? 0
            }
            let differenceWorkout = DifferenceWorkout(name: name,
                                                      lastReps: lastReps,firstReps: firstReps,
                                                      lastTimer: lastTimer, firstTimer: firstTimer)
            differenceArray.append(differenceWorkout)
        }
    }
    
    private func filteringWorkouts(text: String) {
        for workout in differenceArray {
            if workout.name.lowercased().contains(text.lowercased()) {
                filteredArray.append(workout)
            }
        }
    }
    
    private func updatingTableData() {
        if isFiltered {
            statisticsTable.setDifferenceArray(filteredArray)
        } else {
            statisticsTable.setDifferenceArray(differenceArray)
        }
        statisticsTable.reloadData()
    }
}

//MARK: - BrounTextFieldProtocol

extension StatisticViewController: BrounTextFieldProtocol {
    func typing(range: NSRange, replacementString: String) {
        if let text = nameTextField.text,
           let textRange = Range(range, in: text) {
            let updateText = text.replacingCharacters(in: textRange, with: replacementString)
            
            filteredArray = [DifferenceWorkout]()
            isFiltered = updateText.count > 0
            filteringWorkouts(text: updateText)
        }
        updatingTableData()
    }
    
    func clear() {
        statisticsTable.setDifferenceArray(differenceArray)
        statisticsTable.reloadData()
        
    }
}

//MARK: - Set Constraints

extension StatisticViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            statisticLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            statisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticLabel.heightAnchor.constraint(equalToConstant: 30),
            
            segmentedControl.topAnchor.constraint(equalTo: statisticLabel.bottomAnchor, constant: 30),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            
            nameTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 35),
        
            exercisesLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            statisticsTable.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor),
            statisticsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statisticsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statisticsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
