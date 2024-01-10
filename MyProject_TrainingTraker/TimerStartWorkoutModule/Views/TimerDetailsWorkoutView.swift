//
//  TimerDetailsWorkoutView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 27.09.2023.
//

import UIKit

protocol NextSetTimerProtocol: AnyObject {
    func nextSetTapped()
    func editingTapped()
}

class TimerDetailsWorkoutView: UIView {
    
    weak var cellNextSetDelegate: NextSetTimerProtocol?
    
    private let exerciseNameLabel = UILabel(text: "Squats", font: .robotoMedium24(), textColor: .specialGray)
    private let setLabel = UILabel(text: "Sets", font: .robotoMedium18(), textColor: .specialGray)
    private let setCountLabel = UILabel(text: "1/4", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var setsStackView = UIStackView(arrangedSubviews: [setLabel,
                                                                   setCountLabel],
                                                 axis: .horizontal,
                                                 spacing: 10)
    
    private let firstBarView: UIView = {
        let barView = UIView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = .specialLine
        return barView
    }()
    
    private let timerLabel = UILabel(text: "Time of set", font: .robotoMedium18(), textColor: .specialGray)
    private let timerCountLabel = UILabel(text: "\(123.getTimeFromSeconds())", font: .robotoMedium24(), textColor: .specialGray)
    
    private lazy var repsStackView = UIStackView(arrangedSubviews: [timerLabel,
                                                                    timerCountLabel],
                                                 axis: .horizontal,
                                                 spacing: 10)
    
    private let secondBarView: UIView = {
        let barView = UIView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = .specialLine
        return barView
    }()
    
    private lazy var editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        let coloredImage = UIImage(named: "editing")?.withRenderingMode(.alwaysTemplate)
        button.setImage(coloredImage, for: .normal)
        button.tintColor = .specialGray
        button.setTitle("Editing", for: .normal)
        button.setTitleColor(.specialLightBrown, for: .normal)
        button.titleLabel?.font = .robotoMedium16()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = .specialDarkYellow
        button.tintColor = .specialGray
        button.setTitle("NEXT SET", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        setCountLabel.textAlignment = .right
        timerCountLabel.textAlignment = .right
        addSubview(exerciseNameLabel)
        addSubview(setsStackView)
        addSubview(firstBarView)
        addSubview(repsStackView)
        addSubview(secondBarView)
        addSubview(editingButton)
        editingButton.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        addSubview(nextSetButton)
        nextSetButton.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
    }
    
    @objc private func editingButtonTapped() {
        cellNextSetDelegate?.editingTapped()
    }
    
    @objc private func nextSetButtonTapped() {
        cellNextSetDelegate?.nextSetTapped()
    }
    
    func refreshLabels(_ model: WorkoutModel, numberOfSet: Int) {
        exerciseNameLabel.text = model.workoutName
        setCountLabel.text = "\(numberOfSet)/\(model.workoutSets)"
        timerCountLabel.text = "\(model.workoutTimer.getTimeFromSeconds())"
    }
    
    func buttonIsEnable(_ value: Bool) {
        editingButton.isEnabled = value
        nextSetButton.isEnabled = value
    }
}

//MARK: - Set Constraints

extension TimerDetailsWorkoutView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            exerciseNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            exerciseNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            exerciseNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            setsStackView.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 16),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            setsStackView.heightAnchor.constraint(equalToConstant: 30),
            
            firstBarView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor),
            firstBarView.leadingAnchor.constraint(equalTo: setsStackView.leadingAnchor),
            firstBarView.trailingAnchor.constraint(equalTo: setsStackView.trailingAnchor),
            firstBarView.heightAnchor.constraint(equalToConstant: 1),
            
            repsStackView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 25),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            repsStackView.heightAnchor.constraint(equalToConstant: 30),
            
            secondBarView.topAnchor.constraint(equalTo: repsStackView.bottomAnchor),
            secondBarView.leadingAnchor.constraint(equalTo: repsStackView.leadingAnchor),
            secondBarView.trailingAnchor.constraint(equalTo: repsStackView.trailingAnchor),
            secondBarView.heightAnchor.constraint(equalToConstant: 1),
            
            editingButton.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 12),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            editingButton.heightAnchor.constraint(equalToConstant: 20),

            nextSetButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 12),
            nextSetButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            nextSetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            nextSetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
}
