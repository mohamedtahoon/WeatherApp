////
////  NetworkService.swift
////  WeatherApp
////
////  Created by MacBookPro on 7/4/19.
////  Copyright © 2019 MacBookPro. All rights reserved.
////
//
//import Foundation
//import Moya
//import UIKit
//import CoreLocation
//
//let constants = Constants()
//let locationManager = CLLocationManager()
//
//
//enum WeatherAPI {
//    case showCurrentWeatherCity(cityName: String)
//    
//}
//
//extension WeatherAPI: TargetType{
//    var baseURL: URL {
//        return URL(string: constants.WEATHER_URL)!
//    }
//    
//    var path: String {
//        switch self {
//        case .showCurrentWeatherCity:
//            return "/q"
//        }
//    }
//    
//    var method: Moya.Method {
//        return .get
//    }
//    
//    var sampleData: Data {
//        return Data()
//    }
//    
//    var task: Task {
//        switch self {
//        case .showCurrentWeatherCity:
//            
//        default:
//            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//                let location = locations[locations.count - 1]
//                if location.horizontalAccuracy > 0 {
//                    locationManager.stopUpdatingLocation()
//                    let latitude = String(location.coordinate.latitude)
//                    let longtude = String(location.coordinate.longitude)
//                    let params : [String : String] = ["lat" : latitude , "lon" : longtude , "appId" : constants.APP_ID]
//                    
//                    getWeatherData(url: constants.WEATHER_URL ,parameters: params)
//                    
//                    print("long \(longtude)")
//                }
//            }
//            
//            
//            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//                cityLabel.text = "Location Unavailable 😢 "
//            }
//        }
//    }
//    
//    var headers: [String : String]? {
//        <#code#>
//    }
//    
//    
//}
