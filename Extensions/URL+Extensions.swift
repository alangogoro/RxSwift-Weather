//
//  URL+Extensions.swift
//  RxSwiftWeather
//
//  Created by usr on 2021/8/12.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&APPID=9aa8eb47ca75209cd4c3bccc88045531")
    }
}
