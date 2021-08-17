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
            //             ⭐️ Observable<Tuple>：包含 "HTTPURLResponse" & 取到的 "Data"
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                //                    ⭐️ rx.response → 回傳 URLRequest 的回應 的 Observable
                return URLSession.shared.rx.response(request: request)
            }.map { (response, data) in
                // ➡️ statusCode 落在 200-299 的區間內才做 JSON 解析
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response,
                                                            data: data)
                }
            }.asObservable()

    }
    
    // 規範傳入參數，要是遵從 Decodable、能做 JSON 解析的泛型
    /* static func load<T: Decodable>(resource: Resource<T>)
    -> Observable<T> {
        
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
                // 此處回傳一個 Observable<Data>
            }.map { data -> T in
                // 將上方的 Observable<Data> 解碼成自訂的型別 (WeatherData)
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()
        
    } */
}
