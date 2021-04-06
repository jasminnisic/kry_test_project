//
//  WeatherViewModel.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation

protocol WeatherViewModelDelegate: class {
    
    func didLoadLocations()
    func didAddNewLocation()
    func didFailLoadingLocations()
    func didFailDeleting()
    func didRemoveLocation()
    func loading(_ isLoading: Bool)
}

class WeatherViewModel {
    
    private var service: WeatherService!
    private var locations: [WeatherLocation] = []
    
    weak var delegate: WeatherViewModelDelegate?
    
    init(service: WeatherService) {
        self.service = service
    }
    
    var numberOfItems: Int {
        return locations.count
    }
    
    func cellViewModel(at index: Int) -> LocationCellViewModel {
        return LocationCellViewModel(with: locations[index])
    }
 
    func loadWeatherData() {
        delegate?.loading(true)
        service.refresh { [weak self] (locations, error) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.delegate?.loading(false)
            }
            if let _ = error {
                DispatchQueue.main.async {
                    strongSelf.delegate?.didFailLoadingLocations()
                }
                return
            }
            strongSelf.locations = locations
            DispatchQueue.main.async {
                strongSelf.delegate?.didLoadLocations()
            }
        }
    }
    
    func removeLocation(at index: Int) {
        delegate?.loading(true)
        service.delete(locationId: locations[index].id) { [weak self] (error) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.delegate?.loading(false)
                guard error == nil else {
                    strongSelf.delegate?.didFailDeleting()
                    return
                }
                strongSelf.locations.remove(at: index)
                strongSelf.delegate?.didRemoveLocation()
            }
        }
    }
    
}

extension WeatherViewModel: LocationDateUpdateDelegate {
    
    func didAddNewLocation(location: WeatherLocation) {
        locations.append(location)
        delegate?.didAddNewLocation()
    }
    
}
