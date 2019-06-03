//
//  Product.swift
//  SuperShop
//
//  Created by David on 5/6/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let description: String
    let price: String
    let thumbnail: String
    let stock: String
    let category: Category
}
