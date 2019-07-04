//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by MacBookPro on 7/3/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController,CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    let constants = Constants()
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var country: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        
    }
    
    
    
    
    func getWeatherData(url: String , parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                print("Success !! Got Weather Data")
                
                let weatherJSON : SwiftyJSON.JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                print("weather\(weatherJSON)")
            }else{
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Lost 😢"
            }
        }
    }
    
    
    
  
   
    func updateWeatherData(json : SwiftyJSON.JSON){
        if let tempResult = json["main"]["temp"].double{
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconeName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.description = json["weather"][0]["description"].stringValue
            weatherDataModel.country = json["sys"]["country"].stringValue
            updateUIWithWeatherData()
        }else{
            cityLabel.text = "Weather Unavailable 😢 "
        }
    }
    
    
    
    
    
  
    func updateUIWithWeatherData(){
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconeName)
        weatherDescription.text = weatherDataModel.description
        country.text = weatherDataModel.country
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longtude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude , "lon" : longtude , "appId" : constants.APP_ID]
            
            getWeatherData(url: constants.WEATHER_URL ,parameters: params)
            
            print("long \(longtude)")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable 😢 "
    }
    
    
    
    
    func userEnteredCityName(city: String) {
        print(city)
        let params : [String : String] = ["q" : city , "appId" : constants.APP_ID]
        getWeatherData(url: constants.WEATHER_URL, parameters: params)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.changeCityName = self
        }
    }
    
    
    
    
}


