//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation

class WeatherService: BaseService {

    class var shared: WeatherService {
        return WeatherService()
    }
    
    func refresh(url: String = Constants.Endpoints.locations, _ completion: @escaping ([WeatherLocation], Error?)->()) {
        getJsonFromUrl(urlString: url) { (data, error) in
            if let e = error {
                completion([], e)
                return
            }
            guard let data = data else {
                completion([], NSError())
                return
            }
            do {
                let result = try JSONDecoder().decode(LocationsResult.self, from: data)
                completion(result.locations, nil)
            } catch {
                completion([], NSError())
            }
            
        }
    }
    
    func createNew(name: String, temperature: Int, status: Status, url: String = Constants.Endpoints.locations, _ completion: @escaping (WeatherLocation?, Error?)->()) {
        let payload = [
            "name": name,
            "status": status.rawValue,
            "temperature": temperature
        ] as [String : Any]
        postJsonToUrl(payload: payload, urlString: url) { (data, error) in
            if let e = error {
                completion(nil, e)
                return
            }
            guard let data = data else {
                completion(nil, NSError())
                return
            }
            do {
                let result = try JSONDecoder().decode(WeatherLocation.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, NSError())
            }
            
        }
    }
    
    func delete(locationId: String, url: String = Constants.Endpoints.locations, _ completion: @escaping (Error?)->()) {
        let urlString = String(format: "%@/%@", url, locationId)
        executeDeleteOnUrl(urlString: urlString) { (data, error) in
            completion(error)
        }
    }
}

private struct LocationsResult: Decodable {
    var locations: [WeatherLocation]
}
