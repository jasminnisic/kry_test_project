//
//  LocationCellViewModel.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation

class LocationCellViewModel {
    
    private var location: WeatherLocation!
    
    init(with location: WeatherLocation) {
        self.location = location
    }
    
    var city: String {
        let parts = location.name.components(separatedBy: ";")
        return parts.first ?? "Unknown"
    }
    
    var country: String? {
        let parts = location.name.components(separatedBy: ";")
        if parts.count != 2 {
            return nil
        }
        return parts[1].uppercased()
    }
    
    var status: Status {
        return location.status
    }
    
    var temperature: Int {
        return location.temperature
    }
}
