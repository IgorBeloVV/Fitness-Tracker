//
//  DateAndRepeat.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 13.09.2023.
//

import UIKit

class DateAndRepeat: UIView {
    
    private let dateAndRepeatLabel = UILabel(text: "Date and repeat")
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBrown
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel = UILabel(text: "Date",
                                    font: .robotoMedium18(),
                                    textColor: .specialGray)
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.tintColor = .specialGreen
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let repeatLabel = UILabel(text: "Repeat every 7 days",
                                      font: .robotoMedium18(),
                                      textColor: .specialGray)
    
    private lazy var repeatSwitch: UISwitch = {
        let repSwitch = UISwitch()
        repSwitch.isOn = true
        repSwitch.onTintColor = .specialGreen
        repSwitch.translatesAutoresizingMaskIntoConstraints = false
        return repSwitch
    }()
    
    private lazy var dateStack = UIStackView(arrangedSubviews: [dateLabel, datePicker],
                                             axis: .horizontal,
                                             spacing: 10)
    
    private lazy var repeatStack = UIStackView(arrangedSubviews: [repeatLabel,repeatSwitch],
                                               axis: .horizontal,
                                               spacing: 10)
    
    private lazy var dateAndRepeatStack = UIStackView(arrangedSubviews: [dateStack, repeatStack],
                                                      axis: .vertical,
                                                      spacing: 5)
    
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
        addSubview(dateAndRepeatLabel)
        addSubview(backgroundView)
        
        dateStack.distribution = .equalSpacing
        repeatStack.distribution = .equalSpacing
        backgroundView.addSubview(dateAndRepeatStack)
    }
    
    func getDateAndRepeat() -> (date: Date, isRepeat: Bool) {
        (datePicker.date, repeatSwitch.isOn)
    }
    
    func resetDateAndRepeat() {
        datePicker.date = Date()
        repeatSwitch.isOn = true
    }
}

//MARK: - Set Constraints

extension DateAndRepeat {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dateAndRepeatLabel.topAnchor.constraint(equalTo: topAnchor),
            dateAndRepeatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateAndRepeatLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            backgroundView.topAnchor.constraint(equalTo: dateAndRepeatLabel.bottomAnchor, constant: 3),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dateAndRepeatStack.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            dateAndRepeatStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            dateAndRepeatStack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
        ])
    }
}
