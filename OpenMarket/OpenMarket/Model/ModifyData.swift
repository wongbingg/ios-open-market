//
//  ModifyData.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/26.
//

import Foundation

struct ModifyData {
    var name: String?
    var descriptions: String?
    var thumbnailId: Int?
    var price: Int?
    var currency: Currency?
    var discountedPrice: Int?
    var stock: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnailId = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
    }
    
    var existData: [String] {
        let list = [name, descriptions, thumbnailId, price, currency, discountedPrice, stock] as [Any]
        let result = list.compactMap { $0 as! String }
        return result
    }
}


