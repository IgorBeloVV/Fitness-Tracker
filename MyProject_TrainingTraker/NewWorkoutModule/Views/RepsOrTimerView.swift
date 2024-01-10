//
//  RepsOrTimerView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 13.09.2023.
//

import UIKit

class RepsOrTimerView: UIView {
    
    private let repsOrTimerLabel = UILabel(text: "Reps or timer")
   
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBrown
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var (sets, reps, timer) = (0, 0, 0)
    
    private let setsSliderView = SliderView(text: "Sets", maxValue: 10, type: .sets)
    private let chooseLabel = UILabel(text: "Choose repeat or timer")
    private let repsSliderView = SliderView(text: "Reps", maxValue: 50, type: .reps)
    private let timerSliderView = SliderView(text: "Timer", maxValue: 600, type: .timer)
    
    private lazy var stackView = UIStackView(arrangedSubviews: [setsSliderView,
                                                                chooseLabel,
                                                                repsSliderView,
                                                                timerSliderView],
                                             axis: .vertical,
                                             spacing: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(repsOrTimerLabel)
        addSubview(backgroundView)
        chooseLabel.textAlignment = .center
        backgroundView.addSubview(stackView)
    }
    
    private func setDelegates() {
        setsSliderView.delegate = self
        repsSliderView.delegate = self
        timerSliderView.delegate = self
    }
    
    func resetSliderViewValues() {
        setsSliderView.resetValues()
        repsSliderView.resetValues()
        timerSliderView.resetValues()
    }
}
//MARK: - SliderViewProtocol

extension RepsOrTimerView: SliderViewProtocol {
    func changeValue(type: SliderType, value: Int) {
        switch type {
            
        case .sets:
            sets = value
        case .reps:
            reps = value
            repsSliderView.isActive = true
            timerSliderView.isActive = false
            timer = 0
        case .timer:
            timer = value
            repsSliderView.isActive = false
            timerSliderView.isActive = true
            reps = 0
        }
    }
}

//MARK: -Set Constraints

extension RepsOrTimerView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            repsOrTimerLabel.topAnchor.constraint(equalTo: topAnchor),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            backgroundView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 3),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
    
            stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10)
        ])
    }
}
