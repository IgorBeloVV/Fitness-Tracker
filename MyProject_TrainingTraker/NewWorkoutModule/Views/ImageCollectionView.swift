//
//  ImageCollectionView.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 19.09.2023.
//

import UIKit

protocol IconNamePropocol: AnyObject {
    func getIconName(iconName: String)
}

class ImageCollectionView: UICollectionView {
    
    let collectionLayout = UICollectionViewFlowLayout()
    let iconsArray = ["testWorkout", "dumbbells", "dumbbells 1", "chest", "timer"]
    
    weak var iconNameDelegate: IconNamePropocol?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionLayout)
        
        setupLayout()
        setupView()
        setDelegate()
        register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.idImageCellNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupLayout() {
        collectionLayout.minimumInteritemSpacing = 2
        collectionLayout.scrollDirection = .horizontal
    }
    
    private func setupView() {
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegate() {
        dataSource = self
        delegate = self
    }
}

//MARK: - UICollectionViewDelegate

extension ImageCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iconNameDelegate?.getIconName(iconName: iconsArray[indexPath.item])
    }
}

//MARK: - UICollectionViewDataSource

extension ImageCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        iconsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.idImageCellNumber,
                                                            for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.iconImageView.image = UIImage(named: iconsArray[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout

extension ImageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.height * 0.75,
               height: collectionView.frame.height * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
