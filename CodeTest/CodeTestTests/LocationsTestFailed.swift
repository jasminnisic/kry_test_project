//
//  LocationsTestFailed.swift
//  CodeTestTests
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import XCTest
@testable import CodeTest

class LocationsTestFailed: XCTestCase {

    private var expectation = XCTestExpectation(description: "Fetch data success")
    private var viewModel: WeatherViewModel!
    
    func testFailed() throws {
        let service = WeatherServiceMock.shared
        service.success = false
        viewModel = WeatherViewModel(service: service)
        viewModel.delegate = self
        viewModel.loadWeatherData()
        wait(for: [expectation], timeout: 1.0)
    }
    
}

extension LocationsTestFailed: WeatherViewModelDelegate {
    func didAddNewLocation() { }
    
    func didFailLoadingLocations() {
        expectation.fulfill()
        XCTAssertEqual(0, viewModel.numberOfItems)
    }
    
    func didFailDeleting() { }
    
    func didRemoveLocation() { }
    
    func loading(_ isLoading: Bool) { }
        
    func didLoadLocations() { }
    
}
