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
import MapKit

class WeatherViewController: UIViewController,CLLocationManagerDelegate, ChangeCityDelegate, UISearchBarDelegate, MKMapViewDelegate {
    
    
    let constants = Constants()
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    let initialLocation = CLLocation(latitude: 30.050000000000001, longitude: 31.239999999999998)
    let searchRadius: CLLocationDistance = 100000
    var pointAnnotation:MKPointAnnotation!
    let changeCityViewController = ChangeCityViewController()

    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapView.delegate = self
        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        searchInMap()
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
           
            if let coord = json["coord"]["lat"]["lon"].double{
                weatherDataModel.coord = Double(coord)
            }
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
        
        
        
        self.mapView.showsUserLocation = true


    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            //locationManager.stopUpdatingLocation()
            let latitude = String(location.coordinate.latitude)
            let longtude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat" : latitude , "lon" : longtude , "appId" : constants.APP_ID]
            
            
            
            print("longsssssssssssssss \(longtude)")
            getWeatherData(url: constants.WEATHER_URL ,parameters: params)


        }
    }
    
    
    func searchInMap() {
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
        // 1
        let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = self.cityLabel.text
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0)
            request.region = MKCoordinateRegion(center: self.initialLocation.coordinate, span: span)
        // 3
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
         
             self.addPinToMapView(title: "\(String(describing: self.cityLabel.text))", latitude: response!.boundingRegion.center.latitude, longitude: response!.boundingRegion.center.longitude)

        
            print("city name \(self.cityLabel.text)")
            
        })
    }
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let deadline = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            if let title = self.cityLabel.text {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = title
                self.mapView.addAnnotation(annotation)
                
            }
        }
        }
        
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable 😢 "
    }
    
    
    
    
    func userEnteredCityName(city: String) {
        print(city)
        let params : [String : String] = ["q" : city , "appId" : constants.APP_ID]

        mapView.removeAnnotations(mapView.annotations)
        
       
        
        getWeatherData(url: constants.WEATHER_URL, parameters: params)
        searchInMap()
        locationManager.startUpdatingLocation()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.changeCityName = self
            mapView.showsUserLocation = true

        }
    }
    
    
    
}



