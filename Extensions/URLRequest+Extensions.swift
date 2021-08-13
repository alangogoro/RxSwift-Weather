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
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.just(resource.url)
            // ⭐️ 包含 <HTTPURLResponse 和取到的 Data> 的 Tuple
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                // ⭐️ Rx.response → 回傳 URLRequest 的回應 的 Observable序列
                return URLSession.shared.rx.response(request: request)
            }.map { response, data in
                // ➡️ 落在 200-299 的區間內才做 JSON 解析
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response,
                                                            data: data)
                }
                
            }.asObservable()
        
    }
    
    // 限制參數需遵從 Decodable 協定
    /* static func load<T: Decodable>(resource: Resource<T>)
    -> Observable<T> {
        
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
                // 此處 return 一個 Observable<Data>
            }.map { data -> T in
                // 將上方的 Observable<Data> 解碼成自訂的型別 (WeatherData, Weather)
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()
        
    } */
}
