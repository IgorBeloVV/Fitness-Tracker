//
//  ProgressCollectionView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 05.10.2023.
//

protocol ProgressCollectionViewProtocol: AnyObject {
    func tappedCell()
}

import UIKit

class ProgressCollectionView: UICollectionView {
    
    private let collectionLayout = UICollectionViewFlowLayout()
    
    private let idCellNumber = "idCellNumber"
    private var resultArray = [ResultWorkout]()
    
    weak var progressDelegate: ProgressCollectionViewProtocol?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        
        register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: idCellNumber)
        setupView()
        setupLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
    
   private func setupLayout() {
       collectionLayout.minimumInteritemSpacing = 10
       collectionLayout.scrollDirection = .horizontal
   }
    
    private func setDelegate() {
        dataSource = self
        delegate = self
    }
    
    func getResultWorkout() {
        let nameArray = RealmManager.shared.getWorkoutsName()
        let workoutArray = RealmManager.shared.getResultWorkoutModel()
        
        for name in nameArray {
            let predicate = NSPredicate(format: "workoutName = '\(name)'")
            let filteredArray = workoutArray.filter(predicate).sorted(byKeyPath: "workoutName")
            var intResult = 0
            var result = ""
            var imageName = "testWorkout"
            filteredArray.forEach { model in
                if model.workoutTimer == 0 {
                    intResult += model.workoutSets * model.workoutReps
                    result = String(intResult)
                } else {
                    intResult += model.workoutTimer * model.workoutSets
                    result = String(intResult / 60) + " min"
                }
                
                if let image = model.workoutImageName {
                    imageName = image
                }
            }
            let resultModel = ResultWorkout(name: name, result: result, image: imageName)
            resultArray.append(resultModel)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ProgressCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCellNumber, for: indexPath) as? ProgressCollectionViewCell else {
            return UICollectionViewCell()
        }
        let number = indexPath.row % 4
        cell.backgroundColor = number == 0 || number == 3 ? .specialGreen : .specialDarkYellow
        let model = resultArray[indexPath.row]
        cell.configure(model)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProgressCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        progressDelegate?.tappedCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProgressCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.frame.width / 2 - 10,
               height: self.frame.height / 2 - 10)
    }
}
