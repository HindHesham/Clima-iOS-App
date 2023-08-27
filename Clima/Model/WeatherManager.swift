//
//  WeatherManager.swift
//  Clima
//
//  Created by Hind Hesham on 14/10/2022.
//

import Foundation
import CoreLocation

//to useing delegate design pattern
//First: create protocol in the same file that we will use it
protocol WeatherManagerDelegate{
    
    //seconde: Function must be implement
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager{
    
    static let apiKey: String = ""
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(apiKey)"
    
    
    //third: set delegate to the optinal protocol we created so if class set himself as a delegate
    //we can call it delegate. and use the method inside
    var delegate: WeatherManagerDelegate?
    
    func featchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func featchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        print(lat)
        print(lon)
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1- create url
       
        if let url = NSURL(string: urlString){
            //2- create urlsession
            let session = URLSession(configuration: .default)

            //3- give task to urlsession
            let task = session.dataTask(with: url as URL) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    print(safeData)
                    if let weather = self.parseJSON(safeData){

                        //useing delegate
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4 start task
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
           print(decodedData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weatherObj = WeatherModel(conditionID: id, cityName: name, temprature: temp)
            return weatherObj
        
        } catch{
            print(error)
            return nil
        }
    }

}
