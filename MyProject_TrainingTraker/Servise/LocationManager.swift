//
//  LocationManager.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 01.11.2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    public let locationManager = CLLocationManager()
    public var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)){
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
           return
        }
        completion?(location)
        locationManager.stopUpdatingLocation()
    }
}
