//
//  WeatherServiceMock.swift
//  CodeTestTests
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation
import UIKit

class WeatherServiceMock: WeatherService {
    
    public var success = true
    
    override class var shared: WeatherServiceMock {
        let mockService = WeatherServiceMock()
        mockService.isMock = true
        return mockService
    }
    
    override func refresh(url: String = Constants.Endpoints.locations, _ completion: @escaping ([WeatherLocation], Error?) -> ()) {
        let filename = success ? "locations_success" : "locations_failed"
        super.refresh(url: filename, completion)
    }
    
    override func delete(locationId: String, url: String = Constants.Endpoints.locations, _ completion: @escaping (Error?) -> ()) {
        super.delete(locationId: "123", url: "locations_delete_success", completion)
    }
}
