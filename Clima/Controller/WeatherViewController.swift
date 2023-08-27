

import UIKit
import CoreLocation


class WeatherViewController: UIViewController{
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // second: set class as a delegate to can use method
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func getCurrentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()

    }
    
}

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //las is optional so we first bind it to new constant location
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.featchWeather(lat: lat, lon: lon)
        }
       
    }
   
}


extension WeatherViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField.text! != ""){
            return true
        }else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.featchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//first to implemnt protocol method and useing delegate: adopt protocol
extension WeatherViewController: WeatherManagerDelegate{
    
    //third: implement protocol method
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel){
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.getTemperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
    
    func didFailWithError(error: Error){
        print("error is \(error)")
    }
    
}

