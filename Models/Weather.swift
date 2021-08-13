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

struct WeatherData: Decodable {
    let main: Weather
}

extension WeatherData {
    // 自定義的空 WeatherData
    static var empty: WeatherData {
        return WeatherData(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
