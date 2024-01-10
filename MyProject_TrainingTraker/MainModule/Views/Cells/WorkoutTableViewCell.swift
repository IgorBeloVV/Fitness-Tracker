//
//  WorkoutTableViewCell.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 08.09.2023.
//

import UIKit

protocol WorkoutCellProtocol: AnyObject {
    func startButtonTapped(_ model: WorkoutModel)
}

class WorkoutTableViewCell: UITableViewCell {

    static let idTableViewCell = "idTableViewCell"
    
    weak var workoutCellDelegate: WorkoutCellProtocol?
    
    private let backgroundCell: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBrown
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let workoutBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let workoutImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "testWorkout")?.withRenderingMode(.alwaysTemplate) // withRenderingMode позволяет менять изображение
        image.tintColor = .black //тут мы изменили прорисовку линий на черные в исходном рисунке
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium22()
        label.textColor = .specialBlack
//        label.text = "Pull Ups"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutRepsLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium16()
        label.textColor = .specialGray
//        label.text = "Reps: 10"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutSetsLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoMedium16()
        label.textColor = .specialGray
//        label.text = "Sets: 2"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("START", for: .normal)
        button.titleLabel?.font = .robotoBold16()
//        button.tintColor = .specialDarkGreen
//        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var lablesStackView = UIStackView()
    
    private var workoutModel = WorkoutModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none // эффект выделения ячейки
        backgroundColor = .clear
        addSubview(backgroundCell)
        addSubview(workoutBackgroundView)
        workoutBackgroundView.addSubview(workoutImageView)
        addSubview(workoutNameLabel)
        lablesStackView = UIStackView(arrangedSubviews: [workoutRepsLabel,
                                                         workoutSetsLabel],
                                      axis: .horizontal,
                                      spacing: 10)
        addSubview(lablesStackView)
        contentView.addSubview(startButton) // кнопку добавляем через contentView чтобы работала
    }
    
    @objc private func startButtonTapped() {
        workoutCellDelegate?.startButtonTapped(workoutModel)
    }
    
    func configure(model: WorkoutModel){
        workoutModel = model
        
        workoutNameLabel.text = model.workoutName
        
        if model.workoutTimer == 0 {
            workoutRepsLabel.text = "Reps: \(model.workoutReps)"
        } else {
            workoutRepsLabel.text = "Timer: \(model.workoutTimer.getTimeFromSeconds())"
        }
        workoutSetsLabel.text = "Sets: \(model.workoutSets)"
        let test = model.workoutImageName ?? "testWorkout"
        workoutImageView.image = UIImage(named: test)?.withRenderingMode(.alwaysTemplate)
        
        if model.workoutStatus {
            startButton.setTitle("COMPLETE", for: .normal)
            startButton.tintColor = .white
            startButton.backgroundColor = .specialGreen
            startButton.isEnabled = false
        } else {
            startButton.setTitle("START", for: .normal)
            startButton.tintColor = .specialDarkGreen
            startButton.backgroundColor = .specialYellow
            startButton.isEnabled = true
        }
    }
}

//MARK: - Set Constraints

extension WorkoutTableViewCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            workoutBackgroundView.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            workoutBackgroundView.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 10),
            workoutBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            workoutBackgroundView.widthAnchor.constraint(equalToConstant: 80),
        
            workoutImageView.centerYAnchor.constraint(equalTo: workoutBackgroundView.centerYAnchor),
            workoutImageView.centerXAnchor.constraint(equalTo: workoutBackgroundView.centerXAnchor),
            workoutImageView.heightAnchor.constraint(equalTo: workoutBackgroundView.heightAnchor, multiplier: 0.8),
            workoutImageView.widthAnchor.constraint(equalTo: workoutBackgroundView.widthAnchor, multiplier: 0.8),
            
            workoutNameLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            workoutNameLabel.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            workoutNameLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
        
            lablesStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor),
            lablesStackView.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            lablesStackView.heightAnchor.constraint(equalToConstant: 20),
            
            startButton.topAnchor.constraint(equalTo: lablesStackView.bottomAnchor, constant: 5),
            startButton.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            startButton.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            startButton.bottomAnchor.constraint(equalTo: workoutBackgroundView.bottomAnchor)
        ])
    }
}
