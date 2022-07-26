// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let marketList = try? newJSONDecoder().decode(MarketList.self, from: jsonData)

import Foundation

// MARK: - MarketList
struct ProductDetail: Codable {
    let id, vendorID: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price, bargainPrice, discountedPrice, stock: Int
    let createdAt, issuedAt: String
    let images: [Image]
    let vendors: Vendors

    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images, vendors
    }
    func showDetail() {
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int
    let url, thumbnailURL: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, url
        case thumbnailURL = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}

// MARK: - Vendors
struct Vendors: Codable {
    let name: String
    let id: Int
    let createdAt, issuedAt: String

    enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
