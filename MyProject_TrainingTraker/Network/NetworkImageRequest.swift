//
//  NetworkImageRequest.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 10.10.2023.
//

import Foundation

class NetworkImageRequest {
    
    static let shared = NetworkImageRequest()
    
    private init() {}
    
    func requestImageData(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
       
        let urlString =
        "https://openweathermap.org/img/wn/\(id)@2x.png"
        
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
