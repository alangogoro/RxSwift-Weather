//
//  ViewController.swift
//  RxSwiftWeather
//
//  Created by usr on 2021/8/12.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameTextField.returnKeyType = .search
        // ⭐️ 觀測 textField 的「輸入完畢」事件
        /* ➡️ 將 TextField 的 editingDidEndOnExit 事件
         * 轉成 Observable 物件。
         * 再隨著每次事件，取得 textField 上的文字
         * 把文字做為參數呼叫查詢天氣的 API */
        cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
        .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { cityName in
                
                if let city = cityName {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
                
            }).disposed(by: disposeBag)
        
        // ⭐️ 訂閱 TextField 取得輸入文字
        /* 原先這個寫法，每當 TextField 有文字異動時，都會去呼叫 API
        cityNameTextField.rx.value
            .subscribe(onNext: { cityName in
                
                if let city = cityName {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
                
            }).disposed(by: disposeBag)
         */
    }
    
    // MARK: - Helpers
    private func fetchWeather(by city: String) {
        // ➡️ 避免使用者輸入空白 City，將文字編碼為符合 URL 的%字串
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else { return }
        
        // ⭐️ 利用 URL 生成天氣資料資源
        let resource = Resource<WeahterData>(url: url)
        
        // MARK: - ⭐️ Driver
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WeahterData.empty)
        
        search.map { "\($0.main.temp) °C" }
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        search.map { "\($0.main.humidity)°💧" }
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        /*
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(WeahterData.empty)
        
        // MARK: - ⭐️ Binding Observables
        search.map { "\($0.main.temp) °C" }
            .bind(to: self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        search.map { "\($0.main.humidity)°💧" }
            .bind(to: self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
        */
        
        /* 原本的寫法：subscribe URLRequest.load() 回傳的 weatherData
         URLRequest.load(resource: resource)
            /* ⭐️ observeOn(MainScheduler.instance) 限制程式跑在 UI 執行緒上 */
            .observeOn(MainScheduler.instance)
            /* ⭐️ catchErrorJustReturn 如果 API 未抓到正確的資料，Return 一個自訂的元素 */
            .catchErrorJustReturn(WeahterData.empty)
            .subscribe(onNext: { weahterData in
                let weather = weahterData.main
                self.displayWeather(weather)
            }).disposed(by: disposeBag)
         */
    }
    
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            temperatureLabel.text = "\(weather.temp) °C"
            humidityLabel.text = "\(weather.humidity)°💧"
        } else {
            temperatureLabel.text = "😶‍🌫️"
            humidityLabel.text = "--"
        }
    }
}
