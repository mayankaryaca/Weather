//
//  ViewController.swift
//  IOS-Mayank-101300566
//
//  Created by Mayank Arya on 2021-05-21.
//

import UIKit
import CoreLocation
import Combine

class ViewController: UIViewController {
    private var cancellables : Set<AnyCancellable> = []

    //MARK : Weather api variables
    private let weatherApiCall = WeatherAPI.getSharedInstance()
    
    //MARK : Geocoding variables
    private let geocoder = CLGeocoder()
    private let locationHandler = LocationHandler()
    
    
    //MARK : UI Labels
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    @IBOutlet weak var uvIndexLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func fetchWeatherDetailsButton(_ sender: Any) {
        self.locationHandler.getCurrentLocation()
        self.recieveLocationVariable()
        self.recieveCurrentWeatherChange()
    }
 
 
    //MARK : Weather API Functions

    private func recieveCurrentWeatherChange(){
        self.weatherApiCall.$weatherObject
            .receive(on: RunLoop.main)
            .sink{(currentWeather) in
            print(#function, "Current Weather Information recieved")

                self.tempLabel.text = String(currentWeather?.tempC  ?? 0) + " C"
                self.feelsLikeTempLabel.text = String(currentWeather?.feelslikeC ?? 0) + " C"
                self.windSpeedLabel.text = String(currentWeather?.windKph ?? 0)
                self.windDirectionLabel.text = currentWeather?.windDir ?? "NA"
                self.uvIndexLabel.text = String(currentWeather?.uv ?? 0)

        }
            .store(in: &cancellables)
    }
    
    //MARK : Geocoding Functions

    private func recieveLocationVariable(){
        self.locationHandler.$currentLocation
            .receive(on: RunLoop.main)
            .sink{(currentLocation) in
            print(#function, "Current Location recieved")
                let locationToSend = CLLocation(latitude: currentLocation?.latitude ?? 0.0,longitude: currentLocation?.longitude ?? 0.0)
                self.getCityGeoCoder(location: locationToSend)

        }
            .store(in: &cancellables)
    }
    
    private func getCityGeoCoder(location : CLLocation){
        self.geocoder.reverseGeocodeLocation(location) { (placemark, error)in
            self.processLocationToGetCity(placemarkList: placemark, error: error)
        }
    }
    
    private func processLocationToGetCity(placemarkList : [CLPlacemark]?, error : Error?){
        
        if error != nil{
            print(#function,"Unable to get city")
            self.currentLocationLabel.text = "Unable to get city"

        }else{
            if let placemarks = placemarkList, let placemark = placemarks.first{
                let city = placemark.locality ?? "Not Available"
                self.currentLocationLabel.text = city
                let URL = self.weatherApiCall.generateURL(location: city)
                self.weatherApiCall.fetchDataFromAPI(URLString: URL)
            }else{
                self.currentLocationLabel.text = "No city found"

            }
        }
    }
    

}

