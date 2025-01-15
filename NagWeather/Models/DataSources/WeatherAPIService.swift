//
//  WeatherAPIRepository.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation
import Combine

class WeatherAPIService {

    private let session: URLSession
    private let jsonDecoder: JSONDecoder

    init(urlSession: URLSession = .shared) {
        self.session = urlSession
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }

    func fetchWeather(location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        let endpoint = Api.fetchWeather(location: location)
        return performRequest(for: endpoint.urlRequest, responseType: WeatherModel.self)
    }

    func searchSuggestion(query: String) -> AnyPublisher<[SLocation], WeatherApiError> {
        let endpoint = Api.searchSuggestion(query: query)
        return performRequest(for: endpoint.urlRequest, responseType: [SLocation].self)
    }

    private func performRequest<T: Decodable>(
        for request: URLRequest,
        responseType: T.Type
    ) -> AnyPublisher<T, WeatherApiError> {
        session
            .dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .mapError { error in
                WeatherApiError.errorCode(error.errorCode)
            }
            .flatMap { data, response -> AnyPublisher<T, WeatherApiError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: WeatherApiError.unknown).eraseToAnyPublisher()
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    return Fail(error: WeatherApiError.errorCode(httpResponse.statusCode)).eraseToAnyPublisher()
                }

                return Just(data)
                    .decode(type: responseType, decoder: self.jsonDecoder)
                    .mapError { _ in WeatherApiError.decodingError }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
