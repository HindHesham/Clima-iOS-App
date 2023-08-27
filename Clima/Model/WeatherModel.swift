//
//  WeatherModel.swift
//  Clima
//
//  Created by Hind Hesham on 14/10/2022.
//

import Foundation
struct WeatherModel{
    
    let conditionID: Int
    let cityName: String
    let temprature: Double
    
    //computied properite
    var conditionName: String {
        
        switch conditionID {
        case 200 ... 232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.heavyrain"
        case 600...622:
            return "snowflake.circle"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    var getTemperatureString: String{
        return String(format: "%.1f", temprature)
    }
}
