//
//  MainTableView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 08.09.2023.
//

import UIKit

protocol MainTableViewProtocol: AnyObject {
    func deleteWorkoutModel(_ model: WorkoutModel, index: Int)
}

class MainTableView: UITableView {
    
    weak var mainDelegate: MainTableViewProtocol?
    
    private var workoutsArray = [WorkoutModel]()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setDelegate()
        register(WorkoutTableViewCell.self, forCellReuseIdentifier: WorkoutTableViewCell.idTableViewCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .none
        separatorStyle = .none
        bounces = false // оттягивание таблицы
        showsVerticalScrollIndicator = false // показать/скрыть индикатор прокрутки
        translatesAutoresizingMaskIntoConstraints = false
    }
    private func setDelegate() {
        dataSource = self
        delegate = self
    }
    
    func setWotkoutsArray(_ array: [WorkoutModel]) {
        workoutsArray = array
    }
}

//MARK: - UITableViewDataSource

extension MainTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.idTableViewCell,
                                                       for: indexPath) as? WorkoutTableViewCell else {
           return UITableViewCell()
        }
        let workoutModel = workoutsArray[indexPath.row]
        cell.configure(model: workoutModel)
        cell.workoutCellDelegate = mainDelegate as? WorkoutCellProtocol
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MainTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, _ in
            guard let self else { return }
            let deleteModel = self.workoutsArray[indexPath.row]
            mainDelegate?.deleteWorkoutModel(deleteModel, index: indexPath.row)
        }
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
