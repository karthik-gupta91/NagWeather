//
//  AppConstants.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import SwiftUI

enum AppConstants {
    enum Api {
        static let apiUrl = URL(string: "https://api.weatherapi.com/v1")!
        static let apiKey = "f160e09382f74546b7050803242012"

        enum QueryKey: String {
            case apiKey = "key"
            case searchString = "q"
            case aqi = "aqi"
            case days = "days"
        }

        enum QueryValue {
            static let aqi = "no"
            static let days = "5"
        }
    }
    
    enum WeatherColor {
        static let AccentColor = Color("AccentColor")
        static let AppBackground = Color("AppBackground")
    }

    enum AlertConstants {
        static let alert = "Alert"
        static let ok = "Ok"
        static let loading = "Loading…"
        static let noSuggestionFound = "No suggestions found"
    }
    
    static let lastUpdatedAt = "Last updated at"
    static let humidity = "Humidity"
    static let windDirection = "Wind Direction"
    static let weatherForecast = "Weather Forecast"
    static let today = "Today"
    static let degreeCelcius = "°C"
}


