//
//  WeatherModel.swift
//  IOS-Mayank-101300566
//
//  Created by Mayank Arya on 2021-05-21.
//

import Foundation

struct Current : Codable{

    var tempC : Double
    var feelslikeC : Double
    var windKph : Double
    var windDir : String
    var uv : Double
    
    enum CodingKeys : String, CodingKey{
        case current = "current"
    }
    
    func encode(to encoder: Encoder) throws {
        //TODO
        
    }
    
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        let current  = try response.decodeIfPresent(Weather.self, forKey: CodingKeys.current)
        self.tempC = current?.tempC ?? 0.0
        self.feelslikeC = current?.feelslikeC ?? 0.0
        self.windDir = current?.windDir ?? "Unavailable"
        self.windKph = current?.windKph ?? 0.0
        self.uv = current?.uv ?? 0.0
        
    }
}


struct Weather : Codable{
    var tempC : Double
    var feelslikeC : Double
    var windKph : Double
    var windDir : String
    var uv : Double

    enum CodingKeys: String, CodingKey {
      
         case tempC = "temp_c"
         case feelslikeC = "feelslike_c"
         case windKph = "wind_kph"
         case windDir = "wind_dir"
         case uv = "uv"
     }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder : Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tempC = try response.decodeIfPresent(Double.self , forKey: .tempC) ?? 0.0
        self.feelslikeC = try response.decodeIfPresent(Double.self, forKey: .feelslikeC) ?? 0.0
        self.windKph = try response.decodeIfPresent(Double.self, forKey: .windKph) ?? 0.0
        self.windDir = try response.decodeIfPresent(String.self, forKey: .windDir) ?? "Unavailable"
        self.uv = try response.decodeIfPresent(Double.self, forKey: .uv) ?? 0.0

    }
}
