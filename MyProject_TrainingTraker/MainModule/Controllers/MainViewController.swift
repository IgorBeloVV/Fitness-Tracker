//
//  ViewController.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 01.09.2023.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var coordinate: CLLocationCoordinate2D?

    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .specialLine
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Name"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.numberOfLines = 2 // количество линий текста
        label.adjustsFontSizeToFitWidth = true // уменьшать размер шрифта под размер frame label
        label.minimumScaleFactor = 0.5 // ограничивает минимальный размер шрифта, задается от 0 до 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addWorcoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("Add workout", for: .normal)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .specialDarkGreen
        button.titleLabel?.font = .robotoMedium12()
        button.addShadowOnView()
        button.imageEdgeInsets = .init(top: 0, left: 20, bottom: 15, right: 0)
        button.titleEdgeInsets = .init(top: 50, left: -40, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(addWorcoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    private let workoutToday = UILabel(text: "Workout today")
    private let tableView = MainTableView()
    
    private let noWorkoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noWorkout")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var workoutArray = [WorkoutModel]()
    private var selectDate = Date()
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUserParametrs()
        selectItem(date: selectDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showOnboatding()
        getWeather()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setConstraints()
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }
                self.coordinate = location.coordinate
            }
        }
    }
    private func setupView() {
        view.backgroundColor = .specialBackground
        calendarView.setDelegate(self)
        view.addSubview(calendarView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorcoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutToday)
        tableView.mainDelegate = self
        view.addSubview(tableView)
        view.addSubview(noWorkoutImageView)
    }
    @objc private func addWorcoutButtonTapped() {
        let newWorkoutViewController = NewWorkoutViewController()
        newWorkoutViewController.modalPresentationStyle = .fullScreen
        present(newWorkoutViewController, animated: true)
    }
    
    private func getWorkouts(date: Date) {
        let weekday = date.getWeekDayNumber()
        let startDate = date.startEndDate().start
        let endDate = date.startEndDate().end
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnrepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [startDate, endDate])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnrepeat])
        let resultArray = RealmManager.shared.getResultWorkoutModel()
        let filteredArray = resultArray.filter(compound).sorted(byKeyPath: "workoutName")
        workoutArray = filteredArray.map{ $0 }
    }
    
    private func checkWorkoutToday() {
        noWorkoutImageView.isHidden = !workoutArray.isEmpty
        tableView.isHidden = workoutArray.isEmpty
    }
    
    private func setUserParametrs() {
        let usersArray = RealmManager.shared.getResultUserModel()
        if !usersArray.isEmpty {
            userNameLabel.text = usersArray[0].userFirstName + " " + usersArray[0].userSecondName
            
            guard let data = usersArray[0].userImage,
                  let image = UIImage(data: data) else { return }
            userPhotoImageView.image = image
            userPhotoImageView.contentMode = .scaleAspectFill
        }
    }
    
    private func getWeather() {
        guard let latitude = self.coordinate?.latitude,
              let longitude = self.coordinate?.longitude else { return }
        NetworkDataFetch.shared.fetchweather(latitude: latitude,
                                             longitude: longitude) { [weak self] result, error in
            guard let self else { return }
            if let model = result {
                self.weatherView.updateLabels(model: model)
                NetworkImageRequest.shared.requestImageData(id: model.weather[0].icon) { result in
                    switch result {
                    case .success(let data):
                        self.weatherView.updateImage(data: data)
                    case .failure(let error):
                        print (error.localizedDescription)
                    }
                }
            }
            if let error {
                self.presentSimpleAlert("Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showOnboatding() {
        let userDefaults = UserDefaults.standard
        let onBoardingWasViewed = userDefaults.bool(forKey: "OnBoardingWasViewed")
        if !onBoardingWasViewed {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
        }
    }
}

//MARK: - CalendarViewProtocol

extension MainViewController: CalendarViewProtocol {
    func selectItem(date: Date) {
        getWorkouts(date: date)
        tableView.setWotkoutsArray(workoutArray)
        tableView.reloadData()
        checkWorkoutToday()
        selectDate = date
    }
}

//MARK: - MainTableViewProtocol
    
extension MainViewController: MainTableViewProtocol {
    func deleteWorkoutModel(_ model: WorkoutModel, index: Int) {
        RealmManager.shared.deleteWorkoutModel(model)
        workoutArray.remove(at: index)
        tableView.setWotkoutsArray(workoutArray)
        tableView.reloadData()
        checkWorkoutToday()
    }
}

//MARK: - WorkoutCellProtocol

extension MainViewController: WorkoutCellProtocol {
    func startButtonTapped(_ model: WorkoutModel) {
        if model.workoutTimer == 0 {
            let startWorkout = RepsStartWorkoutViewController()
            startWorkout.setWorkoutModel(model)
            startWorkout.modalPresentationStyle = .fullScreen
            present(startWorkout, animated: true)
        } else {
            let startWorkout = TimerStartWorkoutViewController()
            startWorkout.setWorkoutModel(model)
            startWorkout.modalPresentationStyle = .fullScreen
            present(startWorkout, animated: true)
        }
    }
}

//MARK: - Set Constraints

extension MainViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            calendarView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70),
        
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        
            addWorcoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorcoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorcoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorcoutButton.widthAnchor.constraint(equalToConstant: 80),
            
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.leadingAnchor.constraint(equalTo: addWorcoutButton.trailingAnchor, constant: 10),
            weatherView.heightAnchor.constraint(equalToConstant: 80),
            
            workoutToday.topAnchor.constraint(equalTo: addWorcoutButton.bottomAnchor, constant: 10),
            workoutToday.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workoutToday.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: workoutToday.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noWorkoutImageView.topAnchor.constraint(equalTo: workoutToday.bottomAnchor),
            noWorkoutImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noWorkoutImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noWorkoutImageView.heightAnchor.constraint(equalTo: noWorkoutImageView.widthAnchor)
        ])
    }
}

