//
//  ProductCollectionViewCell.swift
//  SuperShop
//
//  Created by David on 5/28/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

protocol SendCommandToVC {
    func deleteThisCell()
}

class ProductCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var thumbnailImageV: UIImageView!
    
    @IBOutlet weak var nameProductLabel: UITextView!
    
    @IBOutlet weak var priceProductLabel: UILabel!
    
    @IBOutlet weak var contentViewRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var swipeView: UIView!
    
    var item: Product? {
        
        didSet {
            updateView()
        }
        
    }
    
    var delegate: SendCommandToVC?
    
    var startPoint = CGPoint()
    var startingRightLayoutConstraintConstant = CGFloat()

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        // Initialization code
    }
    
    func setUp() {
        priceProductLabel.textColor = UIColor.Shop.textImportant
    }
    
    func updateView() {
        
        guard let product = item else { return }
        
        thumbnailImageV.getImageFromUrl(url: product.thumbnail)

        nameProductLabel.text = product.name

        priceProductLabel.text = "$ \(product.price)"
        
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        
        if let temp = delegate{
            
            temp.deleteThisCell()
            
        } else {
            
            print("you forgot to set the delegate")
        }

    }
    
}
