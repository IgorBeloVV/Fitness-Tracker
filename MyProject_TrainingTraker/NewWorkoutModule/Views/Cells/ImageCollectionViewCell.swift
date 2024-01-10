//
//  ImageCollectionViewCell.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 19.09.2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let idImageCellNumber = "idImageCellNumber"
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .specialLightBrown
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
               backgroundColor = .specialYellow
                iconImageView.tintColor = .black
            } else {
//                backgroundColor = .specialYellow
//                 iconImageView.tintColor = .black
                backgroundColor = .none
                iconImageView.tintColor = .specialLightBrown
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
    }
}

//MARK: -Set Constraints

extension ImageCollectionViewCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            iconImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
    }
}
