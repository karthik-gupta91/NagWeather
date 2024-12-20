//
//  NagWeatherApp.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import SwiftUI

@main
struct NagWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherAPIService = WeatherAPIService(urlSession: URLSession(configuration: .default))
            let weatherRepository = WeatherRepositoryImpl(weatherAPIService: weatherAPIService, weatherOfflineService: WeatherOfflineService())
            ContentView(viewModel: WeatherViewModel(weatherRepo: weatherRepository))
        }
    }
}
