//
//  WeatherView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 01.09.2023.
//

import UIKit

class WeatherView: UIView {
    
    private let sunImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sun")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Солнечно"
        label.textColor = .specialGray
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherInfo: UILabel = {
        let label = UILabel()
        label.text = "Хорошая погода, чтобы позаниматься на улице"
        label.numberOfLines = 2
        label.textColor = .specialLine
        label.font = .robotoMedium14()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        backgroundColor = .white
        layer.cornerRadius = 10
        addShadowOnView()
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sunImageView)
        addSubview(weatherLabel)
        addSubview(weatherInfo)
    }
    
    func updateImage(data: Data) {
        guard let image = UIImage(data: data) else { return }
        sunImageView.image = image
    }
    
    func updateLabels(model: WeatherModel) {
        weatherLabel.text = "\(model.name), \(model.weather[0].myDescription)  \(model.main.temperatureCesius)°C"
        switch model.weather[0].weatherDescription {
        case "clear sky", "few clouds", "scattered clouds", "broken clouds", "overcast clouds", "mist":
            weatherInfo.text = "Отличное время для тренировок"
        case "shower rain", "rain", "thunderstorm", "snow":
            weatherInfo.text = "Лучше остаться дома"
        default:
            weatherInfo.text = "No data"
        }
    }
}

//MARK: - Set Constraints

extension WeatherView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            sunImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sunImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            sunImageView.heightAnchor.constraint(equalToConstant: 60),
            sunImageView.widthAnchor.constraint(equalToConstant: 60),
            
            weatherLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            weatherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            weatherLabel.trailingAnchor.constraint(equalTo: sunImageView.leadingAnchor, constant: -5),
        
            weatherInfo.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 5),
            weatherInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            weatherInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            weatherInfo.trailingAnchor.constraint(equalTo: sunImageView.leadingAnchor, constant: -5)
        ])
    }
}
