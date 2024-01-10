//
//  ProgressCollectionViewCell.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 05.10.2023.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private let exerciseLabel = UILabel(text: "PUSH UPS", font: .robotoBold24(), textColor: .white)
    private let countExerciseLabel = UILabel(text: "180", font: .robotoBold48(), textColor: .white)
    
    private let iconExerciseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chest")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        backgroundColor = .specialDarkYellow
        layer.cornerRadius = 15
        translatesAutoresizingMaskIntoConstraints = false
        exerciseLabel.textAlignment = .center
        exerciseLabel.adjustsFontSizeToFitWidth = true
        exerciseLabel.minimumScaleFactor = 0.5
        addSubview(exerciseLabel)
        addSubview(countExerciseLabel)
        countExerciseLabel.textAlignment = .center
        countExerciseLabel.adjustsFontSizeToFitWidth = true
        countExerciseLabel.minimumScaleFactor = 0.5
        addSubview(iconExerciseImageView)
    }
    
   func configure(_ model: ResultWorkout) {
        exerciseLabel.text = model.name
        countExerciseLabel.text = "\(model.result)"
        iconExerciseImageView.image = UIImage(named: model.image)
    }
}

//MARK: - Set Constraints

extension ProgressCollectionViewCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            exerciseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            exerciseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            exerciseLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            exerciseLabel.heightAnchor.constraint(equalToConstant: 30)
            
            iconExerciseImageView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 10),
            iconExerciseImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            iconExerciseImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconExerciseImageView.widthAnchor.constraint(equalToConstant: 60),
            
            countExerciseLabel.centerYAnchor.constraint(equalTo: iconExerciseImageView.centerYAnchor),
            countExerciseLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            countExerciseLabel.leadingAnchor.constraint(equalTo: iconExerciseImageView.trailingAnchor, constant: 10)
        ])
    }
}
