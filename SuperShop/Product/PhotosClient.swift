//
//  PhotosClient.swift
//  SuperShop
//
//  Created by David on 5/20/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

class PhotosClient: APIClient<[Photo]> {
    
    convenience init() {
        self.init(client: Client(), path: Config.baseAPI.value! + "/api/photo")
    }
        
}
