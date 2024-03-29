//
//  UIColor+Extension.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

extension UIColor {

    static let kryDarkBlue = UIColor(named: "kry-dark-blue")!
    static let krySmokeBlue = UIColor(named: "kry-smoke-blue")!
    static let kryOrange = UIColor(named: "kry-orange")!
    static let kryLightGray = UIColor(named: "kry-light-gray")!
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            var hexValue = hex
            if hex.count == 7 {
                hexValue = hex + "ff"
            }
            let start = hexValue.index(hexValue.startIndex, offsetBy: 1)
            let hexColor = String(hexValue[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
