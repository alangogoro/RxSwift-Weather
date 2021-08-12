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
