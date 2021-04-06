//
//  KryBanner.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

enum KryBannerType {
    case success
    case warning
    case error
}

class KryBanner: UIView {

    static let shared = KryBanner(frame: CGRect(x: 0, y: 0, width: UIApplication.shared.keyWindow!.bounds.width, height: 0))
    
    private var isShown = false
    private var isAnimating = false
    
    private var parentView: UIView?
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let messageLabel = UILabel(frame: CGRect.zero)
    private let container = UIView(frame: CGRect.zero)
    private var type: KryBannerType = .success
    private var hideTimer: Timer?
    
    private var action: (()->())?
    
    private var verticalConstraintTopNoOffset: NSLayoutConstraint?
    private var verticalConstraintTopOffset: NSLayoutConstraint?
    
    public func show(withTitle title: String, message: String, type: KryBannerType, in view: UIView, action: (()->())? = nil) {
        self.action = action
        DispatchQueue.main.async {
            if self.isShown {
                self.hide { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.showNewInstance(title: title, message: message, type: type, in: view)
                }
            } else {
                self.showNewInstance(title: title, message: message, type: type, in: view)
            }
        }
    }
    
    private func showNewInstance(title: String, message: String, type: KryBannerType, in view: UIView) {
        self.isShown = true
        self.parentView = view
        self.messageLabel.text = message
        self.titleLabel.text = title
        if message.count == 0 && title.count > 0 {
            self.messageLabel.text = title
            self.titleLabel.text = ""
        }
        self.type = type
        switch type {
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                container.backgroundColor = UIColor.systemRed
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                container.backgroundColor = UIColor.systemOrange
            case .success:
                container.backgroundColor = UIColor.systemGreen
        }
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        messageLabel.textColor = UIColor.white
        messageLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        view.addSubview(self)
        DispatchQueue.main.async {
            if UIApplication.shared.keyWindow!.convert(CGPoint.zero, from: view).y > 0 {
                NSLayoutConstraint.activate([self.verticalConstraintTopNoOffset!])
                NSLayoutConstraint.deactivate([self.verticalConstraintTopOffset!])
            } else {
                NSLayoutConstraint.activate([self.verticalConstraintTopOffset!])
                NSLayoutConstraint.deactivate([self.verticalConstraintTopNoOffset!])
            }
            self.setNeedsLayout()
            self.layoutSubviews()
            self.layoutIfNeeded()
        }
        container.transform = self.container.transform.translatedBy(x: 0, y: -100)
        isAnimating = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
                self.container.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.frame = self.container.bounds
                self.isAnimating = false
            })
        }
        
        hideTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { [weak self] timer in
            guard let strongSelf = self else { return }
            guard strongSelf.isShown else {
                timer.invalidate()
                strongSelf.hideTimer = nil
                return
            }
            strongSelf.hide()
        })
    }
    
    @objc private func onTap() {
        guard !isAnimating else {
            return
        }
        action?()
        action = nil
        hide()
    }
    
    public func hide(_ completion: (()->())? = nil) {
        guard !isAnimating else { return }
        self.isAnimating = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.container.transform = self.container.transform.translatedBy(x: 0, y: -130)
            }, completion: { _ in
                self.removeFromSuperview()
                self.isShown = false
                self.hideTimer?.invalidate()
                self.hideTimer = nil
                self.isAnimating = false
                completion?()
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        clipsToBounds = false
        self.backgroundColor = UIColor.clear
        
        self.gestureRecognizers?.forEach({ recognizer in
            self.removeGestureRecognizer(recognizer)
        })
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTap)))
        setupContent()
    }
    
    private func setupContent() {
        let width = 200.0
        let height = 100.0
        container.frame = CGRect(x: 0, y: 0, width: width, height: height)
        container.layer.cornerRadius = 0
        container.layer.masksToBounds = true
        container.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: width)
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        messageLabel.frame = CGRect(x: 0, y: 0, width: width, height: width)
        messageLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0
        
        if !container.subviews.contains(messageLabel) {
            container.addSubview(messageLabel)
        }
        
        if !container.subviews.contains(titleLabel) {
            container.addSubview(titleLabel)
        }
        
        if !self.subviews.contains(container) {
            self.addSubview(container)
        }
        
        DispatchQueue.main.async {
            self.setupTitleLabelConstraints()
            self.setupMessageLabelConstraints()
            self.setupContainerConstraints()
        
            self.layoutIfNeeded()
        }
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 12
        let horizontalConstraintTrailing = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute:NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -padding)
        let horizontalConstraintLeading = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute:NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: padding)
        
        verticalConstraintTopNoOffset = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: padding)
        
        var offsetPadding: CGFloat = 5
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let safeAreaTop = window?.safeAreaInsets.top ?? 0
            offsetPadding = offsetPadding + safeAreaTop
        }
        verticalConstraintTopOffset = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: container, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: offsetPadding)
        
        NSLayoutConstraint.activate([horizontalConstraintLeading, horizontalConstraintTrailing, verticalConstraintTopNoOffset!])
    }
    
    private func setupMessageLabelConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraintTrailing = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleLabel, attribute:NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let horizontalConstraintLeading = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleLabel, attribute:NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let verticalConstraintTop = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 3)
        let verticalConstraintBottom = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: container, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -12)
        
        NSLayoutConstraint.activate([horizontalConstraintLeading, horizontalConstraintTrailing, verticalConstraintTop, verticalConstraintBottom])
        messageLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
    }
    
    private func setupContainerConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 0
        let safeAreaTop: CGFloat = 0.0
        
        let horizontalConstraintTrailing = NSLayoutConstraint(item: container, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -padding)
        let horizontalConstraintLeading = NSLayoutConstraint(item: container, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: padding)
        let topConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute:NSLayoutConstraint.Attribute.top, multiplier: 1, constant: safeAreaTop)
        let heightConstraint = NSLayoutConstraint(item: container, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute:NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 200)
        
        NSLayoutConstraint.activate([horizontalConstraintLeading, horizontalConstraintTrailing, topConstraint, heightConstraint])
    }
        
}
