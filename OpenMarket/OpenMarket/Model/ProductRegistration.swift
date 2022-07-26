// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let marketList = try? newJSONDecoder().decode(MarketList.self, from: jsonData)

import Foundation
import UIKit

// MARK: - ProductRegistration
//{ "name": "보리", "price":13330, "stock": 1, "currency": "KRW", "secret": "p0ilm9kwYb", "descriptions": "sleep" }
struct ProductRegistration: Codable {
    let name: String
    let price: Int
    let stock: Int
    let currency: Currency
    let secret: String
    let descriptions: String

    enum CodingKeys: String, CodingKey {
        case name
        case price
        case stock
        case currency
        case secret
        case descriptions
    }
}
