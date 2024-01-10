//
//  NetworkDataFetch.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 10.10.2023.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchweather(latitude: Double, longitude: Double, responce: @escaping (WeatherModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(latitude: latitude, longitude: longitude) { result in
//            print("fetchweather latitude:\(latitude) longitude:\(longitude)")
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    responce(weather, nil)
                } catch let jsonError {
                    print ("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print(error.localizedDescription)
                responce(nil, error)
            }
        }
    }
}
