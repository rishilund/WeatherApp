//
//  ViewController.swift
//  WeatherApp
//
//  Created by Clover on 01/07/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var fetchButton: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    let weatherService = WeatherService()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

      
      override func viewDidLoad() {
          super.viewDidLoad()
          loadLastSearchedCity()
          handleKeyBoard()
      }
    
    @IBAction func fetchWeatherTapped(_ sender: UIButton) {
           guard let city = cityTextField.text, !city.isEmpty else { return }
           
           weatherService.getWeather(for: city) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let weatherResponse):
                       self?.updateUI(with: weatherResponse)
                       self?.saveLastSearchedCity(city)
                   case .failure(let error):
                       self?.showError(error)
                   }
               }
           }
       }
    
    private func saveLastSearchedCity(_ city: String) {
            let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
            
            do {
                let cities = try context.fetch(fetchRequest)
                if let existingCity = cities.first {
                    existingCity.name = city
                } else {
                    let newCity = City(context: context)
                    newCity.name = city
                }
                try context.save()
            } catch {
                print("Failed to save city: \(error)")
            }
        }
        
        private func loadLastSearchedCity() {
            let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
            
            do {
                let cities = try context.fetch(fetchRequest)
                if let lastCity = cities.first?.name {
                    cityTextField.text = lastCity
                    fetchWeatherTapped(fetchButton)
                }
            } catch {
                print("Failed to load city: \(error)")
            }
        }

      
      private func updateUI(with weatherResponse: WeatherResponse) {
          temperatureLabel.text = "\(weatherResponse.main.temp)°C"
          descriptionLabel.text = weatherResponse.weather.first?.description
          humidityLabel.text = "Humidity: \(weatherResponse.main.humidity)%"
          windSpeedLabel.text = "Wind Speed: \(weatherResponse.wind.speed) m/s"
      }
      
      private func showError(_ error: Error) {
          let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }
  }

extension ViewController{
    
    func handleKeyBoard(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

       view.addGestureRecognizer(tap)
    }
    
    
  @objc func dismissKeyboard() {
      //Causes the view (or one of its embedded text fields) to resign the first responder status.
      view.endEditing(true)
  }
}
