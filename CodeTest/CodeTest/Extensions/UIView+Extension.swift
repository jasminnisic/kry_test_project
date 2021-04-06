//
//  UIView+Extension.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

extension UIView {
    func zoomIn() {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func zoomOut() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97)
        }, completion: { _ in
            
        })
    }
}
