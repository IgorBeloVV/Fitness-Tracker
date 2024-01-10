//
//  TimerStartWorkoutViewController.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 27.09.2023.
//

import UIKit

class TimerStartWorkoutViewController: UIViewController {
    
    private let startWorkoutLabel = UILabel(text: "START WORKOUT",
                                            font: .robotoMedium24(),
                                            textColor: .specialGray)
    private let closeButton = CloseButton(type: .system)
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ellipse")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "1:30"
        label.textColor = .specialGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .robotoBold48()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsWorkoutLabel = UILabel(text: "Details")
    private let detailsWorkoutView = TimerDetailsWorkoutView()
    
    private lazy var finishButton = GreenButton(text: "FINISH")
    
    private var workoutModel = WorkoutModel()
    private var customAlert = CustomAlert()
    private var shapeLayer = CAShapeLayer()
    private var timer = Timer()
    
    private var durationTimer = 10
    private var numberOfSet = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        addGesture()
        setWorkoutParametrs()
    }
    
    override func viewDidLayoutSubviews() {
        animationCircular()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        startWorkoutLabel.textAlignment = .center
        view.addSubview(startWorkoutLabel)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(imageView)
        view.addSubview(timerLabel)
        view.addSubview(detailsWorkoutLabel)
        detailsWorkoutView.refreshLabels(workoutModel, numberOfSet: numberOfSet)
        view.addSubview(detailsWorkoutView)
        detailsWorkoutView.cellNextSetDelegate = self
        view.addSubview(finishButton)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        timer.invalidate()
        dismiss(animated: true)
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            RealmManager.shared.updateStatusWorkoutModel(workoutModel)
            dismiss(animated: true)
        } else {
            presentAlertWithAction("Warning", message: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    func setWorkoutModel(_ model: WorkoutModel){
        workoutModel = model
    }
    
    private func addGesture() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc private func startTimer() {
        detailsWorkoutView.buttonIsEnable(false)
        
        if numberOfSet == workoutModel.workoutSets {
            presentSimpleAlert("Warning", message: "Finish your workout")
        } else {
            basicAnimation()
            timerLabel.isUserInteractionEnabled = false
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc private func timerAction() {
        durationTimer -= 1
        print(durationTimer)
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            numberOfSet += 1
            detailsWorkoutView.refreshLabels(workoutModel, numberOfSet: numberOfSet)
            detailsWorkoutView.buttonIsEnable(true)
            timerLabel.isUserInteractionEnabled = true
        }
        let(min, sec) = durationTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
    }
    
    private func setWorkoutParametrs() {
        let (min, sec) = workoutModel.workoutTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
        durationTimer = workoutModel.workoutTimer
    }
}

//MARK: - Animation

extension TimerStartWorkoutViewController {
    
    private func animationCircular() {
        let center = CGPoint(x: imageView.frame.width / 2,
                             y: imageView.frame.width / 2)
        let endAngle = 3 * CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 115.5,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.lineCap = .round
        imageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

//MARK: - NextSetTimerProtocol

extension TimerStartWorkoutViewController: NextSetTimerProtocol {
    func nextSetTapped() {
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            detailsWorkoutView.refreshLabels(workoutModel, numberOfSet: numberOfSet)
        } else {
            presentSimpleAlert("Error", message: "Finish your workout")
        }
    }
    
    func editingTapped() {
        customAlert.presentCustomAlert(viewController: self, repsOrTimer: "Time of set") { [weak self] sets, time in
            guard let self else { return }
            
            if sets != "" && time != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfTime = Int(time) else { return }
                
                RealmManager.shared.updateTimerWorkoutModel(workoutModel, sets: numberOfSets, timer: numberOfTime)
                self.detailsWorkoutView.refreshLabels(self.workoutModel, numberOfSet: self.numberOfSet)
                let (min, sec) = workoutModel.workoutTimer.convertSeconds()
                timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
                self.durationTimer = numberOfTime
            }
        }
    }
    
    
}

//MARK: - Set Constraints

extension TimerStartWorkoutViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            imageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            
            timerLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 140),
            
            detailsWorkoutLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            detailsWorkoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsWorkoutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            detailsWorkoutView.topAnchor.constraint(equalTo: detailsWorkoutLabel.bottomAnchor),
            detailsWorkoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsWorkoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsWorkoutView.heightAnchor.constraint(equalToConstant: 250),
            
            finishButton.topAnchor.constraint(equalTo: detailsWorkoutView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
