//
//  BaseService.swift
//  CodeTest
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import UIKit

class BaseService {
    
    var isMock = false
    private let timeoutInterval: TimeInterval = 30.0
    private var apiKey = ""
    
    init() {
        guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
            let key = UUID().uuidString
            UserDefaults.standard.set(key, forKey: "API_KEY")
            self.apiKey = key
            return
        }
        self.apiKey = apiKey
    }
    
    public func getJsonFromUrl(urlString: String, completion: @escaping (Data?, Error?)->()) {
        guard !isMock else {
            getMockJson(urlString: urlString, completion: completion)
            return
        }
        guard let url = URL(string: urlString) else {
            completion(nil, NSError())
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        URLSession(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                completion(data, error)
            }
        }.resume()
    }
    
    public func executeDeleteOnUrl(urlString: String, completion: @escaping (Data?, Error?)->()) {
        guard !isMock else {
            getMockJson(urlString: urlString, completion: completion)
            return
        }
        guard let url = URL(string: urlString) else {
            completion(nil, NSError())
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        urlRequest.httpMethod = "DELETE"
        URLSession(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                completion(data, error)
            }
        }.resume()
    }

    public func postJsonToUrl(payload: [String:Any], urlString: String, completion: @escaping (Data?, Error?)->()) {
        guard let url = URL(string: urlString) else {
            completion(nil, NSError())
            return
        }
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                completion(data, error)
            }
        }.resume()
    }
    
    let responseCodeMock: [String: Int] = [
        "locations_success": 200,
        "locations_failed": 400,
        "delete_success": 200,
        "delete_failed": 500
    ]
}
