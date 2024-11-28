//
//  WeatherAPIRepository.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine

class WeatherAPIRepository {
    
    let session: URLSession

    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }

    func fetchWeather(location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        let endpoint = Api.fetchWeather(location: location)

        return session
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                WeatherApiError.errorCode(error.errorCode)
            }
            .flatMap { data, response -> AnyPublisher<WeatherModel, WeatherApiError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: WeatherApiError.unknown).eraseToAnyPublisher()
                }
                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data)
                        .decode(type: WeatherModel.self, decoder: jsonDecoder)
                        .mapError { _ in
                            return WeatherApiError.decodingError
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: WeatherApiError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

}


private enum Api {
    case fetchWeather(location: String)
    
    private var baseURL: URL {
        switch self {
            case .fetchWeather:
                return AppConstants.Api.apiUrl
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
        }
    }

    var urlRequest: URLRequest {
        switch self {
            case .fetchWeather:
                guard let url = baseURL.appendingParams(params: params) else { fatalError("Failed to construct url") }
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
