//
//  BaseServiceMock.swift
//  CodeTestTests
//
//  Created by Jasmin Nišić on 06.04.21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation

extension BaseService {
    
    func getMockJson(urlString: String, completion: @escaping (Data?, NSError?)->()) {
        
        var statusCode = responseCodeMock[urlString]
        var error: NSError?
        if statusCode == nil {
            statusCode = 200
        }
        readLocalJson(filename: urlString) { (object) in
            if statusCode != 200 {
                if let response = object as? NSDictionary, let messagee = response["message"] as? String, let description = response["description"] as? String {
                    error = NSError(domain: "NetworkError", code: statusCode!, userInfo: ["message": messagee, "description": description])
                } else {
                    error = NSError(domain: "NetworkError", code: statusCode!, userInfo: ["message": "An error occurred", "description": ""])
                }
            }
            completion(object as? Data, error)
        }
    }
    
    func readLocalJson(filename: String, completion: (Any)->()) {
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: filename, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                completion(data)
            } catch {
                print("Error! Unable to parse JSON \(filename).json")
            }
        } else {
            print("Error! Cannot find file: \(filename).json")
        }
    }
}
