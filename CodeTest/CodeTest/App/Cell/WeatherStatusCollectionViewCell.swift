//
//  WeatherStatusCollectionViewCell.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

class WeatherStatusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(with viewModel: WeatherStatusCellViewModel) {
        iconImageView.image = UIImage(named: viewModel.imageName)
        descriptionLabel.text = viewModel.text.uppercased()
        handleSelection()
    }
    
    override var isSelected: Bool {
        didSet {
            handleSelection()
        }
    }
    
    private func handleSelection() {
        if isSelected {
            contentView.backgroundColor = UIColor.kryOrange
            iconImageView.tintColor = .white
            descriptionLabel.textColor = .white
            contentView.alpha = 1.0
        } else {
            contentView.backgroundColor = UIColor.clear
            iconImageView.tintColor = .black
            descriptionLabel.textColor = .black
            contentView.alpha = 0.53
        }
    }
}
