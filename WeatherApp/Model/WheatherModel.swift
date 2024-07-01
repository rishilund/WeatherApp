//
//  WheatherModel.swift
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
