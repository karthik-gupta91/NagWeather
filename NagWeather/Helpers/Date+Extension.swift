//
//  Date+Extension.swift
//  NagWeather
//
//  Created by Kartik Gupta on 14/01/25.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
