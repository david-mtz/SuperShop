//
//  Config.swift
//  SuperShop
//
//  Created by David on 5/7/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

enum Config {
    
    case host
    case baseAPI
    
    var value: String? {
        switch self {
            case .host:
                return "http://shopapi.comunidadtw.x10.mx"
            case .baseAPI:
                return "/public"
        }
    }

}
