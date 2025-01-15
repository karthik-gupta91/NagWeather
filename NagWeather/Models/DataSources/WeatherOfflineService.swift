//
//  WeatherOfflineRepository.swift
//  NagWeather
//
//  Created by Kartik Gupta on 05/12/24.
//

import Foundation
import Combine

class WeatherOfflineService {
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private func fileURL(_ path: String) -> URL {
        return Self.documentsFolder.appendingPathComponent("\(path).data")
    }
    
    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetchWeatherData(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                let fileURL = self.fileURL(location)
                do {
                    let data = try Data(contentsOf: fileURL)
                    let weatherData = try self.jsonDecoder.decode(WeatherModel.self, from: data)
                    DispatchQueue.main.async {
                        promise(.success(weatherData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(.dataNotFound))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, WeatherApiError> {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                let fileURL = self.fileURL(weatherData.location?.name ?? "unknown")
                do {
                    let data = try self.jsonEncoder.encode(weatherData)
                    try data.write(to: fileURL)
                    DispatchQueue.main.async {
                        promise(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(.fileWriteFailed))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func modifiedDate(for location: String) -> AnyPublisher<Date?, Never> {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                let fileURL = self.fileURL(location)
                if let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
                   let modifiedDate = attributes[.modificationDate] as? Date {
                    DispatchQueue.main.async {
                        promise(.success(modifiedDate))
                    }
                } else {
                    DispatchQueue.main.async {
                        promise(.success(nil))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
