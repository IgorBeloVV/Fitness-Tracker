//
//  NetworkRequest.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 10.10.2023.
//

import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()
    
    private init() {}
    
    func requestData(latitude: Double, longitude: Double, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = "d8d668d0b52ba7814a26107ffff4efef"
//        print("requestData latitude:\(latitude) longitude:\(longitude)")
        let urlString =
        "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)"
        
        guard let url = URL(string: urlString) else {return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                } else {
                    guard let data else { return }
                    completion(.success(data))
                }
            }
        }
        .resume()
    }
}
