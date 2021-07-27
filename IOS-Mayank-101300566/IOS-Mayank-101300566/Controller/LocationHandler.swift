//
//  LocationHandler.swift
//  IOS-Mayank-101300566
//
//  Created by Mayank Arya on 2021-05-21.
//

import UIKit
import MapKit

class LocationHandler : UIViewController {

    let locationManager = CLLocationManager()
    
    @Published var currentLocation : CLLocationCoordinate2D?
    
    func getCurrentLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled(){
            print(#function, "Location access granted")
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
        }else{
            print(#function, "Location access  denied")
        }
    }

}

extension LocationHandler : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else{
            print(#function,"Error while recieving coordinates")
            return
        }
        
        self.currentLocation = currentLocation
        print(#function, "lat : \(currentLocation.latitude) , long : \(currentLocation.longitude)")
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function,"Unable to get the location \(error)")
    }

}
