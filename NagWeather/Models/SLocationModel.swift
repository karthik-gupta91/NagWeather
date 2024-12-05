//
//  SLocationModel.swift
//  NagWeather
//
//  Created by Kartik Gupta on 05/12/24.
//

import Foundation

// MARK: - Location
struct SLocation: Codable, Identifiable {
    let id: Int
    let name: String
    let country: String?
    let region: String?

    enum CodingKeys: String, CodingKey {
        case id, name, country, region
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        if let name = try container.decode(String?.self, forKey: .name) {
            self.name = name
        } else {
            self.name = "Unknown"
        }

        country = try container.decode(String?.self, forKey: .country)
        region = try container.decode(String?.self, forKey: .region)
    }

}

extension SLocation: Hashable {
    static func == (lhs: SLocation, rhs: SLocation) -> Bool {
        if lhs.id == rhs.id, lhs.name == rhs.name, lhs.region == rhs.region, lhs.region == rhs.region, lhs.country == rhs.country {
            return true
        }
        return false
    }
}


