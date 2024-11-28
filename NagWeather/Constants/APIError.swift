//
//  APIError.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation


enum WeatherApiError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
}

extension WeatherApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Failed to decode the object from the service"
            case .errorCode(let code):
                return "\(code) - error code from API"
            case .unknown:
                return "Unkwown error"
        }
    }
}
