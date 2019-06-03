//
//  UIView+Shake.swift
//  SuperShop
//
//  Created by David on 6/2/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func shake(for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
        
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 1
            self.transform = CGAffineTransform(translationX: translation, y: 0)
        }
        
        propertyAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)
        
        propertyAnimator.addCompletion { (_) in
            self.layer.borderWidth = 0
        }
        
        propertyAnimator.startAnimation()
    }
    
}
