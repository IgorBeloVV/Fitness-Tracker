//
//  SliderView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 13.09.2023.
//

import UIKit

protocol SliderViewProtocol: AnyObject {
    func changeValue(type: SliderType, value: Int)
}

class SliderView: UIView {
    
    weak var delegate: SliderViewProtocol?
    
    private let nameLabel = UILabel(text: "Sets", font: .robotoMedium18(), textColor: .specialGray)
    private let numberLabel = UILabel(text: "0", font: .robotoMedium24(), textColor: .specialGray)
    private let slider = GreenSlider()
    
    private lazy var nameStackView = UIStackView(arrangedSubviews: [nameLabel, numberLabel],
                                                 axis: .horizontal,
                                                 spacing: 10)
    private lazy var unitStackView = UIStackView(arrangedSubviews: [nameStackView, slider],
                                                 axis: .vertical,
                                                 spacing: 10)
    
    private var sliderType: SliderType?
    
    var isActive: Bool = true {
        didSet {
            if isActive {
                nameLabel.alpha = 1
                numberLabel.alpha = 1
                slider.alpha = 1
            } else {
                nameLabel.alpha = 0.5
                numberLabel.alpha = 0.5
                slider.alpha = 0.5
                slider.value = 0
                numberLabel.text = "0"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String, maxValue: Float, type: SliderType) {
        self.init()
        nameLabel.text = text
        self.slider.minimumValue = 0
        self.slider.maximumValue = maxValue
        self.sliderType = type
       
       setupViews()
       setConstraints()
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(unitStackView)
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        nameStackView.distribution = .equalSpacing
    }
    
    @objc private func sliderChanged() {
        let intSliderValue = Int(slider.value)
        numberLabel.text = sliderType == .timer ? intSliderValue.getTimeFromSeconds() : "\(intSliderValue)"
        guard let sliderType else {return}
        delegate?.changeValue(type: sliderType, value: intSliderValue)
    }
    
    func resetValues() {
        numberLabel.text = "0"
        slider.value = 0
        isActive = true
    }
}

//MARK: -Set Constraints

extension SliderView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            unitStackView.topAnchor.constraint(equalTo: topAnchor),
            unitStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            unitStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            unitStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
