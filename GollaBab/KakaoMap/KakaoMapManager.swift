//
//  KakaoMapManager.swift
//  GollaBab
//
//  Created by 전현성 on 2021/09/23.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import SwiftyJSON

struct Place: Codable {
    var placeName: String
    var addressName: String
    var latY: String
    var lonX: String
    var distance: String
    var phone: String
    var placeUrl: String
}

class KakaoMapManager {
    static let shared = KakaoMapManager()
    
    let header: HTTPHeaders = [
        "Authorization" : "KakaoAK 67fde999606c6fa9df4c317a453187f9"
    ]
    let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
    
    var arrResult = [Place]()
    
    func rxGetPlace(query: String, lat: String, lon: String) -> Observable<[Place]?> {
        let param: [String : Any] = [
            "query" : query,
            "x" : lon,
            "y" : lat,
            "radius" : 300
        ]
        
        return RxAlamofire
            .requestJSON(.get, url, parameters: param, headers: header)
            .debug()
            .map { resp, json -> [Place]? in
                switch resp.statusCode {
                case 200..<300:
                    var arrPlace = [Place]()
                    if let documents = JSON(json)["documents"].array {
                        for item in documents {
                            let placeName = item["place_name"].string ?? ""
                            let addressName = item["address_name"].string ?? ""
                            let latY = item["y"].string ?? ""
                            let lonX = item["x"].string ?? ""
                            let distance = item["distance"].string ?? ""
                            let phone = item["phone"].string ?? ""
                            let placeUrl = item["place_url"].string ?? ""
                            arrPlace.append(Place(placeName: placeName, addressName: addressName, latY: latY, lonX: lonX, distance: distance, phone: phone, placeUrl: placeUrl))
                        }
                    }
                    return arrPlace
                default:
                    return nil
                }
            }
    }
}

