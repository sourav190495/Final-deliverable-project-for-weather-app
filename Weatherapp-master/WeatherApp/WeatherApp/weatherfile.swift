//
//  weatherfile.swift
//  JSONonlineinforetrieval
//
//  Created by SOURAV MAJUMDAR on 5/5/18.
//  Copyright © 2018 SOURAV MAJUMDAR. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary:String
    let icon:String
    let temperature:Double
    let humidity:Double
    let pressure:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
       
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let humidity = json["humidity"] as? Double else {throw SerializationError.missing("humidity is missing")}
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let pressure = json["pressure"] as? Double else {throw SerializationError.missing("pressure is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.pressure = pressure
        self.summary = summary
        self.temperature = temperature
        self.humidity = humidity
        self.icon = icon
        
    }
    
    
    static let bPath = "https://api.darksky.net/forecast/b8388bceb62066e56d6e5ff188f413e7/"
    
    static func weatherforecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = bPath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let taskwork = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    if let dailyForecasts = json["daily"] as? [String:Any] {
                    if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                        for dataPoint in dailyData {
                            if let weatherObject = try? Weather(json: dataPoint) {
                            forecastArray.append(weatherObject)
                            }
                        }
                        }
                    }
                }
                }
                catch
                {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        taskwork.resume()
        
}
}
