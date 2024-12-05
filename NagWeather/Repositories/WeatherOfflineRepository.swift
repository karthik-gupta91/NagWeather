//
//  WeatherOfflineRepository.swift
//  NagWeather
//
//  Created by Kartik Gupta on 05/12/24.
//

import Foundation
import Combine

class WeatherOfflineRepository {
    
    init() {
        
    }
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private func fileURL(_ path: String) -> URL {
        return Self.documentsFolder.appendingPathComponent("\(path).data")
    }

    func fetchWeatherData(for location: String) -> AnyPublisher<WeatherModel, WeatherApiError> {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                guard let data = try? Data(contentsOf: self.fileURL(location)) else {
                    return
                }
                guard let weatherData = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                    fatalError("Can't decode saved data.")
                }
                promise(.success(weatherData))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func saveWeatherData(_ weatherData: WeatherModel) -> AnyPublisher<Void, Never> {
        return Future { promise in
            DispatchQueue.global(qos: .background).async {
                guard let data = try? JSONEncoder().encode(weatherData) else { fatalError("Error encoding data") }
                do {
                    let outfile = self.fileURL(weatherData.location?.name ?? "unknown")
                    try data.write(to: outfile)
                    promise(.success(()))
                } catch {
                    fatalError("Can't write to file")
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func modifiedDate(_ location: String) -> Date? {
        let file: URL = self.fileURL(location)
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let modifiedDate = attributes[FileAttributeKey.modificationDate] as? Date {
            return modifiedDate
        }
        return nil
    }
    
}
