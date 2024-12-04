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
            switch code {
            case 401, 400:
                return "Searched city not found in database"
            default:
                return "\(code) - error code from API"
                
            }
        case .unknown:
            return "Unknown error"
        }
    }
}
