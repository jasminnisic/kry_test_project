//
//  WeatherStatusCellViewModel.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

class WeatherStatusCellViewModel {
    
    private var status: Status!
    
    init(with status: Status) {
        self.status = status
    }
    
    var imageName: String {
        return status.weatherIconImageName
    }
    
    var text: String {
        return status.weatherDescription
    }
}
