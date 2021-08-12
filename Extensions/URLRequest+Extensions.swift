//
//  URLRequest+Extensions.swift
//  RxSwiftWeather
//
//  Created by usr on 2021/8/12.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    // 限制參數需遵從 Decodable 協定
    static func load<T: Decodable>(resource: Resource<T>)
    -> Observable<T> {
        // TODO: WHAT IS THIS
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
                    // 此處 return 一個 Observable<Data>
            }.map { data -> T in
                        // 將上方的 Observable<Data> 解碼成自訂的型別 (WeatherData, Weather)
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()
        
    }
}
