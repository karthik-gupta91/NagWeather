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
            let weatherAPIRepo = WeatherAPIRepository(urlSession: URLSession(configuration: .default))
            let weatherService = WeatherServiceImpl(weatherAPIRepository: weatherAPIRepo)
            ContentView(viewModel: WeatherViewModel(weatherService: weatherService))
        }
    }
}
