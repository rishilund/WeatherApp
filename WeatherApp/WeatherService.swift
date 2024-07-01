//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Clover on 01/07/24.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
}

struct Wind: Codable {
    let speed: Double
}

class WeatherService {
    private let apiKey = "313f995f7bcb3f3749cc39d2051156af"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}
