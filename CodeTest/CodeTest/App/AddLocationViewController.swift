//
//  AddLocationViewController.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    private let cellWidth: CGFloat = 75.0
    private let cellHeight: CGFloat = 120.0
    
    @IBOutlet weak var addButton: LoadingButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var feedback = UISelectionFeedbackGenerator()
    private var contentShown = false
    private var viewModel: AddLocationViewModel!
    private var touchBeganPosition: CGPoint = CGPoint(x: 0, y: 0)
    private var selectionFeedback = UISelectionFeedbackGenerator()
    
    static func create(dataUpdateDelegate: LocationDateUpdateDelegate?) -> AddLocationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let viewController = storyboard.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.viewModel = AddLocationViewModel(service: WeatherService.shared, delegate: viewController, dataUpdateDelegate: dataUpdateDelegate)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    private func configUI() {
        backgroundView.alpha = 0.0
        temperatureTextField.delegate = self
        locationTextField.delegate = self
        containerBottomConstraint.constant = -containerView.bounds.height
        locationTextField.superview?.layer.borderWidth = 1.0
        locationTextField.superview?.layer.borderColor = UIColor.kryLightGray.cgColor
        temperatureTextField.superview?.layer.borderWidth = 1.0
        temperatureTextField.superview?.layer.borderColor = UIColor.kryLightGray.cgColor
        countryButton.superview?.layer.borderWidth = 1.0
        countryButton.superview?.layer.borderColor = UIColor.kryLightGray.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard !contentShown else { return }
        contentShown = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(notification:)), name: UIWindow.keyboardWillChangeFrameNotification, object: nil)
        animateIn()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.backgroundView.alpha = 0.0
        }, completion: nil)
        
        containerBottomConstraint.constant = -containerView.bounds.height
        UIView.animate(withDuration: 0.4, delay: 0.00, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.layoutIfNeeded()
        }, completion: { _ in
            super.dismiss(animated: false, completion: {
                completion?()
            })
        })
    }
    
    private func animateIn() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.backgroundView.alpha = 1.0
            strongSelf.view.layoutIfNeeded()
        }, completion: nil)

        containerBottomConstraint.constant = 15
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.layoutIfNeeded()
        }, completion: nil)
        
        containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:))))
    }
    
    @objc func showKeyboard(notification: Notification) {
        guard let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let frame = frameValue.cgRectValue
        let newY = 15 + (view.bounds.height - frame.minY) - 160
        containerBottomConstraint.constant = max(newY, 15)
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int {
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(curve))) {
                self.view.layoutIfNeeded()
            } completion: { _ in }
        } else {
            view.layoutIfNeeded()
        }
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            touchBeganPosition = sender.location(in: self.view)
        case .changed:
            let y = sender.location(in: self.view).y
            var yDifference = (y - touchBeganPosition.y)
            if yDifference < 0 {
                yDifference = yDifference / 15
            }
            containerBottomConstraint.constant = -yDifference + 15
        case .cancelled, .ended:
            let velocity = sender.velocity(in: self.view)
            let shouldDismiss = containerBottomConstraint.constant < -containerView.frame.height / 2 || velocity.y > CGFloat(80)
            if shouldDismiss {
                dismiss(animated: true, completion: nil)
            } else {
                containerBottomConstraint.constant = 15
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.view.layoutIfNeeded()
                }, completion: nil)
            }
        default:
            break
        }
    }
    
    //MARK: IBActions
    
    @IBAction func background_onTap(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add_onTap(_ sender: Any) {
        guard locationTextField.text != "" else {
            KryBanner.shared.show(withTitle: "Please enter location", message: "It's a mandatory field", type: .error, in: view)
            return
        }
        guard let temperature = Int(temperatureTextField.text!), temperatureTextField.text != "" else {
            KryBanner.shared.show(withTitle: "Please enter temperature", message: "It's a mandatory field", type: .error, in: view)
            return
        }
        addButton.showLoading()
        viewModel.createNew(location: locationTextField.text!, temperature: temperature)
    }
    
    @IBAction func country_onTap(_ sender: Any) {
        view.endEditing(true)
        let vc = CountryPickerViewController.create(delegate: self, preselectedCountry: viewModel.country)
        present(vc, animated: true, completion: nil)
    }
}

extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == temperatureTextField else { return }
        if Int(textField.text!) == nil {
            textField.text = ""
        }
        if let temperature = Int(textField.text!), abs(temperature) > 50 {
            KryBanner.shared.show(withTitle: "Invalid temperature", message: "Temperature can be between -50 and 50 degrees", type: .error, in: view)
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

extension AddLocationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfStatuses
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherStatusCollectionViewCell", for: indexPath) as! WeatherStatusCollectionViewCell
        cell.configure(with: viewModel.statusCellViewModel(at: indexPath.item))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        feedback.selectionChanged()
        viewModel.selectStatus(at: indexPath.item)
    }
    
}

extension AddLocationViewController: AddLocationViewModelDelegate {
    
    func didCreateNewLocation(location: WeatherLocation) {
        addButton.hideLoading()
        dismiss(animated: true, completion: nil)
    }
    
    func didFailCreatingNewLocation() {
        addButton.hideLoading()
        KryBanner.shared.show(withTitle: "An error occurred", message: "Location is not created", type: .error, in: view)
    }
    
    func didChangeCountry() {
        guard let countryIso = viewModel.country else { return }
        countryButton.setTitle(countryIso, for: .normal)
        countryButton.tintColor = UIColor.black
    }        
    
}

extension AddLocationViewController: CountryPickerDelegate {
    
    func didPickCountry(iso: String) {
        viewModel.changeCountry(to: iso)
    }
    
}
