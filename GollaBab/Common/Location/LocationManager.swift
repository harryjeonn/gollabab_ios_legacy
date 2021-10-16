//
//  LocationManager.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/16.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private var locManager = CLLocationManager()
    var myLocation: MTMapPointGeo?
    
    func getLocation() {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.startUpdatingLocation()
        } else {
            print("위치서비스 꺼져 있음")
        }
        
        if let coor = locManager.location?.coordinate {
            myLocation = MTMapPointGeo(latitude: coor.latitude, longitude: coor.longitude)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
