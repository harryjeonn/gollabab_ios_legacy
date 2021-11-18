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
    
    private let baseViewController = BaseViewController()
    
    func getLocation() {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        
        if let coor = locManager.location?.coordinate {
            myLocation = MTMapPointGeo(latitude: coor.latitude, longitude: coor.longitude)
        }
    }
    
    func checkPermission() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showAlert()
//                locManager.startUpdatingLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    private func showAlert() {
        if UserDefaults.standard.bool(forKey: "launchedBefore") != true {
            return
        }
        
        guard let topVC = baseViewController.topViewController() else { return }
        let alert = UIAlertController(title: "'골라밥'이 사용자의 위치를 사용하도록 허용하겠습니까?", message: "주변 식당을 찾기 위해 위치정보 접근 권한이 필요합니다.\n설정 -> 위치 접근을 허용해 주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: {(alert: UIAlertAction!) in
            topVC.navigationController?.popToRootViewController(animated: true)
        })
        let settingAction = UIAlertAction(title: "설정", style: .cancel, handler: {(alert: UIAlertAction!) in
            // 접근권한 페이지로 이동
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            
        })
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        
        topVC.present(alert, animated: true)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
