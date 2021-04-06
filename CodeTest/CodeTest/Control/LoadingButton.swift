//
//  LoadingButton.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {

    @IBInspectable var indicatorColor : UIColor = .white

    var originalButtonText: String?
    var originalButtonImage: UIImage?
    var previousIsEnabledState = true
    var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        previousIsEnabledState = isEnabled
    }
    
    func showLoading() {
        previousIsEnabledState = isEnabled
        isEnabled = false
        originalButtonText = self.titleLabel?.text
        originalButtonImage = self.imageView?.image
        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        DispatchQueue.main.async(execute: {
            self.isEnabled = self.previousIsEnabledState
            self.setTitle(self.originalButtonText, for: .normal)
            self.setImage(self.originalButtonImage, for: .normal)
            self.activityIndicator.stopAnimating()
        })
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = indicatorColor
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }

}
