//
//  WeatherViewModelMock.swift
//  NagWeatherTests
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
@testable import NagWeather

class WeatherViewModelMock: WeatherViewModel {
    private let weatherService = WeatherServiceMock()

    init() {
        super.init(weatherService: weatherService)
    }
}
