//
//  APIRequest.swift
//  NagWeather
//
//  Created by Kartik Gupta on 20/12/24.
//

import Foundation


enum Api {
    case fetchWeather(location: String)
    case searchSuggestion(query: String)
    
    private var baseURL: URL {
        switch self {
        case .fetchWeather, .searchSuggestion:
            return AppConstants.Api.apiUrl
        }
    }
    
    private var path: String {
        switch self {
            case .searchSuggestion:
                return "/search.json"
            case .fetchWeather:
                return "/forecast.json"
        }
    }
    
    private var params: [AppConstants.Api.QueryKey: String] {
        switch self {
            case .fetchWeather(let location):
                var params: [AppConstants.Api.QueryKey: String] = [.apiKey: AppConstants.Api.apiKey]
                params[.searchString] = location.replacingOccurrences(of: " ", with: "+")
                let weatherParams: [AppConstants.Api.QueryKey: String] = [
                    .aqi: AppConstants.Api.QueryValue.aqi,
                    .days: AppConstants.Api.QueryValue.days
                ]

                params.merge(weatherParams) { current, _ in current }
                return params
        case .searchSuggestion(let query):
            var params: [AppConstants.Api.QueryKey: String] = [.apiKey: AppConstants.Api.apiKey]
            params[.searchString] = query.replacingOccurrences(of: " ", with: "+")
            return params
        }
    }

    var urlRequest: URLRequest {
        switch self {
        case .fetchWeather, .searchSuggestion:
            guard let url = baseURL.appendingPathComponent(path).appendingParams(params: params) else { fatalError("Failed to construct url") }
                return URLRequest(url: url)
        }
    }
}

private extension URL {
    func appendingParams(params: [AppConstants.Api.QueryKey: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key.rawValue, value: element.value) }

        return components?.url
    }
}
