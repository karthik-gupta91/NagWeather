//
//  Helpers.swift
//  NagWeather
//
//  Created by Kartik Gupta on 28/11/24.
//

import Foundation

enum Helpers {
    static func dayOfWeek(from value: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: value) else { return nil }

        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
        // or use capitalized(with: locale) if you want
    }

    static func day(from value: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let date = dateFormatter.date(from: value) else { return nil }

        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    static func stringToDate(str: String) -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: str) else {
            return Date()
        }

        return date

    }
}
