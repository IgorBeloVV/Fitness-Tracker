//
//  StatisticsTableView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 09.09.2023.
//

import UIKit

class StatisticsTableView: UITableView {
    
    private var differenceArray = [DifferenceWorkout]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setDelegate()
        register(StatisticsTableViewCell.self, forCellReuseIdentifier: StatisticsTableViewCell.idStaticticsCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .none
        separatorStyle = .none
//        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0) реализация стандартного разделителя
        bounces = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegate() {
       dataSource = self
        delegate = self
    }
    
    func setDifferenceArray(_ array: [DifferenceWorkout]) {
        differenceArray = array
    }
}

//MARK: - UITableViewDataSource

extension StatisticsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        differenceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.idStaticticsCell,
                                                       for: indexPath) as? StatisticsTableViewCell else {
            return UITableViewCell()
        }
        let differenceModel = differenceArray[indexPath.row]
        cell.configure(differenceModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension StatisticsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
