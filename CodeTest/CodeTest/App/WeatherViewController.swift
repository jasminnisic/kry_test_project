//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    private let cellSpacing: CGFloat = 14.0
    private let collectionViewInsets: CGFloat = 19.0
    private let cellHeight: CGFloat = 212.0
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var feedback = UISelectionFeedbackGenerator()
    private var viewModel: WeatherViewModel!
     
    static func create(viewModel: WeatherViewModel!) -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let viewController = storyboard.instantiateInitialViewController() as! WeatherViewController
        viewModel.delegate = viewController
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.loadWeatherData()
    }

    private func setup() {
        title = "Weather Code Test"
        collectionView.contentInset = UIEdgeInsets(top: 0, left: collectionViewInsets, bottom: 0, right: collectionViewInsets)
    }
    
    private func showDeleteActionSheet(index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Delete entry", style: .destructive , handler:{ _ in
                self.collectionView.alpha = 0.5
                self.collectionView.isUserInteractionEnabled = false
                self.viewModel.removeLocation(at: index)
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ _ in }))

            present(alert, animated: true, completion: nil)
    }
    
    //MARK: IBActions    
    @IBAction func add_onTap(_ sender: Any) {
        let viewController = AddLocationViewController.create(dataUpdateDelegate: viewModel)
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func retry_onTap(_ sender: Any) {        
        viewModel.loadWeatherData()
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    
    func loading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func didLoadLocations() {
        emptyStateView.isHidden = true
        collectionView.reloadData()
    }
    
    func didFailLoadingLocations() {
        KryBanner.shared.show(withTitle: "An error occurred", message: "Cannot load locations", type: .error, in: view)
        emptyStateView.isHidden = viewModel.numberOfItems > 0
    }
    
    func didAddNewLocation() {
        collectionView.reloadData()
        KryBanner.shared.show(withTitle: "Success", message: "New location has been added successfully", type: .success, in: view)
        collectionView.scrollToItem(at: IndexPath(item: viewModel.numberOfItems - 1, section: 0), at: .right, animated: true)
    }
    
    func didFailDeleting() {
        self.collectionView.alpha = 1.0
        self.collectionView.isUserInteractionEnabled = true
        KryBanner.shared.show(withTitle: "An error occurred", message: "Entry has not been deleted", type: .error, in: view)
    }
    
    func didRemoveLocation() {
        self.collectionView.alpha = 1.0
        self.collectionView.isUserInteractionEnabled = true
        KryBanner.shared.show(withTitle: "Success", message: "Location has been deleted successfully.", type: .success, in: view)
        collectionView.reloadData()
    }
            
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.reuseIdentifier, for: indexPath) as! LocationCollectionViewCell
        cell.setup(viewModel.cellViewModel(at: indexPath.item))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDeleteActionSheet(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.bounds.width - 2 * collectionViewInsets - cellSpacing) / 2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}

