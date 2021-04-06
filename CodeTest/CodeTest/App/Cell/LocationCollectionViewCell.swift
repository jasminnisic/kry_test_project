//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    static var reuseIdentifier: String {
        return "LocationCollectionViewCell"
    }
    
    func setup(_ viewModel: LocationCellViewModel) {
        cityNameLabel.text = viewModel.city
        countryLabel.text = viewModel.country
        countryLabel.superview?.isHidden = viewModel.country == nil
        temperatureLabel.text = String(format: "%d", viewModel.temperature)
        statusLabel.text = viewModel.status.weatherDescription.uppercased()
        iconImageView.image = UIImage(named: viewModel.status.weatherIconImageName)
    }
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? contentView.zoomOut() : contentView.zoomIn()
        }
    }
}
