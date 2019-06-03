//
//  ProductsCollectionViewCell.swift
//  SuperShop
//
//  Created by David on 6/2/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var productNameTextView: UITextView!
    @IBOutlet weak var productPriceLabel: UILabel!
    var product: Product? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLayout()
        // Initialization code
    }
        
    func setUpLayout() {
        productPriceLabel.textColor = UIColor.Shop.textImportant
    }
    
    func updateView() {
        guard let product = product else { return }
        thumbnailImageView.getImageFromUrl(url: product.thumbnail)
        productNameTextView.text = product.name
        productPriceLabel.text = "$ " + product.price
    }

}
