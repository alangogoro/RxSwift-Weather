//
//  Weather.swift
//  RxSwiftWeather
//
//  Created by usr on 2021/8/12.
//

import Foundation

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}

struct WeahterData: Decodable {
    let main: Weather
}

let api_sample = "https://api.openweathermap.org/data/2.5/weather?q=tokyo&lang=ja&APPID=9aa8eb47ca75209cd4c3bccc88045531"
