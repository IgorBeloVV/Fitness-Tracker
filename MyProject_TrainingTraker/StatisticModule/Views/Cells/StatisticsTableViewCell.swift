//
//  StatisticsTableViewCell.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 09.09.2023.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    static let idStaticticsCell = "idStaticticsCell"
    
    private let exercisesNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Biceps"
        label.textColor = .specialBlack
        label.font = .robotoMedium24()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exercisesBeforeLabel: UILabel = {
        let label = UILabel()
        label.text = "Before: 10"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exercisesNowLabel: UILabel = {
        let label = UILabel()
        label.text = "Now: 10"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let exercisesDifferenceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "+999"
        label.textColor = .specialGreen
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var exercisesStackView = UIStackView(arrangedSubviews: [exercisesBeforeLabel,
                                                                         exercisesNowLabel],
                                                      axis: .horizontal,
                                                      spacing: 10)
    private lazy var exercisesInfoStackView = UIStackView(arrangedSubviews: [exercisesNameLabel, exercisesStackView],
                                                          axis: .vertical,
                                                          spacing: 1)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        exercisesInfoStackView.alignment = .leading
        exercisesInfoStackView.distribution = .fillEqually
        addSubview(exercisesDifferenceLabel)
        addSubview(lineView)
        addSubview(exercisesInfoStackView)
    }
    
    func configure(_ model: DifferenceWorkout) {
        exercisesNameLabel.text = model.name
        exercisesBeforeLabel.text =
        model.firstReps == 0 ? "Before: \(model.firstTimer.getTimeFromSeconds())" : "Before: \(model.firstReps)"
        
        exercisesNowLabel.text =
        model.lastReps == 0 ? "Now: \(model.lastTimer.getTimeFromSeconds())" : "Now: \(model.lastReps)"
        
        let difference =
        model.firstReps == 0 ? model.lastTimer - model.firstTimer : model.lastReps - model.firstReps
        exercisesDifferenceLabel.text = "\(difference)"
        
        if model.lastTimer != 0 {
            switch difference {
            case ..<0:
                exercisesDifferenceLabel.textColor = .specialGreen
                exercisesDifferenceLabel.text = "\(difference) sec"
            case 1...:
                exercisesDifferenceLabel.textColor = .red
                exercisesDifferenceLabel.text = "+\(difference) sec"
            default:
                exercisesDifferenceLabel.textColor = .specialDarkYellow
            }
        } else {
            switch difference {
            case ..<0:
                exercisesDifferenceLabel.textColor = .red
            case 1...:
                exercisesDifferenceLabel.textColor = .specialGreen
                exercisesDifferenceLabel.text = "+\(difference)"
            default:
                exercisesDifferenceLabel.textColor = .specialDarkYellow
            }
        }
    }
}

extension StatisticsTableViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            exercisesInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            exercisesInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            exercisesInfoStackView.trailingAnchor.constraint(equalTo: exercisesDifferenceLabel.leadingAnchor,
                                                             constant: -5),
            exercisesInfoStackView.heightAnchor.constraint(equalTo: heightAnchor,
                                                           multiplier: 0.8),

            exercisesDifferenceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            exercisesDifferenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            exercisesDifferenceLabel.widthAnchor.constraint(equalToConstant: 100),
            
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
