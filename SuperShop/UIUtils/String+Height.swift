//
//  String+Height.swift
//  SuperShop
//
//  Created by David on 6/2/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect,
                                                          options: .usesLineFragmentOrigin,
                                                          attributes: [NSAttributedString.Key.font: font],
                                                          context: nil)
        return boundingBox.height
    }
}
