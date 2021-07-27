//
//  WeatherAPICall.swift
//  IOS-Mayank-101300566
//
//  Created by Mayank Arya on 2021-05-21.
//

import Foundation

class WeatherAPI : ObservableObject{
    
    @Published var weatherObject : Current?
    
    private static var sharedInstance : WeatherAPI?

    static func getSharedInstance() -> WeatherAPI{
        if sharedInstance != nil{
            return sharedInstance!
        }else{
            sharedInstance = WeatherAPI()
            return sharedInstance!
        }
    }
    
    func generateURL(location : String) -> String {
        let apiFrontURL = "https://api.weatherapi.com/v1/current.json?key=ceb4ee17b82e42b58bb220920212105&q="
        let apiBackURL = "&aqi=no"
        
        let URL = apiFrontURL + location + apiBackURL
        
        return URL
    }
    func fetchDataFromAPI(URLString : String){
        guard let api = URL(string: URLString) else {
            return
        }

        URLSession.shared.dataTask(with: api){(data : Data?,response : URLResponse?,error : Error?) in
            if let err = error{
                print(#function,"Could not fetch Data from provider \(err)")
            }else{
                DispatchQueue.global().async {
                    do{
                        if let jsonData = data{
                            let decoder = JSONDecoder()
                          
                            let weatherDecode = try decoder.decode(Current.self , from: jsonData)
                          
                            DispatchQueue.main.async {
                                print(#function, weatherDecode)
                                self.weatherObject = weatherDecode
                                print(#function ,self.weatherObject)
                            }
                        }else{
                            print(#function,"No Json data recieved")
                        }
                    }catch{
                        print(#function, " Error \(error)")
                    }
                }
            }
        }.resume()
    }
    
}
