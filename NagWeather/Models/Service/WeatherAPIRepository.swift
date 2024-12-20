//
//  WeatherAPIRepository.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine

class WeatherAPIService {
    
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

    
    func searchSuggestion(query: String) -> AnyPublisher<[SLocation], WeatherApiError> {
        let endpoint = Api.searchSuggestion(query: query)

        return session
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { error in
                WeatherApiError.errorCode(error.errorCode)
            }
            .flatMap { data, response -> AnyPublisher<[SLocation], WeatherApiError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: WeatherApiError.unknown).eraseToAnyPublisher()
                }
                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data)
                        .decode(type: [SLocation].self, decoder: jsonDecoder)
                        .mapError { error in
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


