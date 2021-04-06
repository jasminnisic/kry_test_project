//
//  LocationsTestSuccess.swift
//  CodeTestTests
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import XCTest
@testable import CodeTest

class LocationsTestSuccess: XCTestCase {

    private var expectation = XCTestExpectation(description: "Fetch data success")
    private var viewModel: WeatherViewModel!
    
    func testSuccess() throws {
        viewModel = WeatherViewModel(service: WeatherServiceMock.shared)
        viewModel.delegate = self
        viewModel.loadWeatherData()
        wait(for: [expectation], timeout: 1.0)
    }
    
}

extension LocationsTestSuccess: WeatherViewModelDelegate {
    func didAddNewLocation() { }
    
    func didFailLoadingLocations() { }
    
    func didFailDeleting() { }
    
    func didRemoveLocation() { }
    
    func loading(_ isLoading: Bool) { }
        
    func didLoadLocations() {
        expectation.fulfill()
        XCTAssertEqual(4, viewModel.numberOfItems)
        XCTAssertEqual("Oslo", viewModel.cellViewModel(at: 3).city)
    }
    
}
