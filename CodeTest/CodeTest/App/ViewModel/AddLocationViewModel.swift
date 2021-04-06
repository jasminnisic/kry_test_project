//
//  AddLocationViewModel.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation

protocol AddLocationViewModelDelegate: class {
    
    func didChangeCountry()
    func didCreateNewLocation(location: WeatherLocation)
    func didFailCreatingNewLocation()
}

protocol LocationDateUpdateDelegate: class {
    
    func didAddNewLocation(location: WeatherLocation)
    
}

class AddLocationViewModel {
    
    private var countryIso: String? {
        didSet {
            delegate?.didChangeCountry()
        }
    }
    private var selectedStatus: Status?
    private weak var delegate: AddLocationViewModelDelegate?
    private weak var dataUpdateDelegate: LocationDateUpdateDelegate?
    private var service: WeatherService!
    
    init(service: WeatherService, delegate: AddLocationViewModelDelegate, dataUpdateDelegate: LocationDateUpdateDelegate?) {
        self.delegate = delegate
        self.service = service
        self.dataUpdateDelegate = dataUpdateDelegate
        selectedStatus = Status.allStatuses().first
    }
    
    var country: String? {
        return countryIso
    }
    
    func changeCountry(to country: String) {
        countryIso = country
    }
    
    var numberOfStatuses: Int {
        return Status.allStatuses().count
    }
    
    func statusCellViewModel(at index: Int) -> WeatherStatusCellViewModel {
        return WeatherStatusCellViewModel(with: Status.allStatuses()[index])
    }
    
    func selectStatus(at index: Int) {
        selectedStatus = Status.allStatuses()[index]
    }
    
    func createNew(location: String, temperature: Int) {
        var locationWithCountry = location
        if let country = countryIso {
            locationWithCountry = locationWithCountry + ";" + country
        }
        service.createNew(name: locationWithCountry, temperature: temperature, status: selectedStatus!) { [weak self] (newLocation, error) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if error != nil || newLocation == nil {
                    strongSelf.delegate?.didFailCreatingNewLocation()
                    return
                }
                strongSelf.dataUpdateDelegate?.didAddNewLocation(location: newLocation!)
                strongSelf.delegate?.didCreateNewLocation(location: newLocation!)
            }
        }
    }
}
