//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by MacBookPro on 7/3/19.
//  Copyright © 2019 MacBookPro. All rights reserved.
//

import UIKit


protocol ChangeCityDelegate {
    func userEnteredCityName(city: String)
}


class ChangeCityViewController: UIViewController {
    
    var changeCityName : ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        let cityName = changeCityTextField.text!
        
        changeCityName?.userEnteredCityName(city: cityName)
        print(cityName)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
