//
//  ProductsClient.swift
//  SuperShop
//
//  Created by David on 5/7/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

class ProductClient: APIClient<Product> {
    
    convenience init() {
        self.init(client: Client(), path: "\(Config.baseAPI.value!)/api/product")
    }

    
}
