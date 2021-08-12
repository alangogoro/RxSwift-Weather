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

extension WeahterData {
    // 自定義的空 WeatherData
    static var empty: WeahterData {
        return WeahterData(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
