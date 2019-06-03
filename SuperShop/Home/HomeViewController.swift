//
//  HomeViewController.swift
//  SuperShop
//
//  Created by David on 5/7/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var products: [Product] = [Product]() {
        didSet {
            updateCollection()
        }
    }
    
    let identifierCell = "producViewCell"
    
    var shopButton: BadgeBarButtonItem? = nil

    private let spacingCell:CGFloat = 15

    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var soldProducts: [Product] = [Product]()
    
    override func viewDidLoad() {
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(UINib(nibName: "ProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifierCell)
        productsCollectionView.backgroundColor = UIColor.Shop.backgroundPage
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacingCell, left: spacingCell, bottom: spacingCell, right: spacingCell)
        layout.minimumLineSpacing = spacingCell
        layout.minimumInteritemSpacing = spacingCell
        productsCollectionView.collectionViewLayout = layout
        
        // Logo
        let logoView = UIImageView(image: UIImage(named: "logo"))
        logoView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoView
        
        shopButton = BadgeBarButtonItem(title: "Cart", target: self, action: #selector(tapShopButton))
        
        navigationItem.rightBarButtonItem = shopButton
        
        loadData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateBadgeArticles()
    }
    
    func updateCollection() {
        productsCollectionView.reloadData()
    }
    
    func loadData() {
        
        let client = ProductstClient()
        
        client.show { (products) in
            self.products = products
        }
        
    }
    
    @objc func tapShopButton() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        next.listItems = soldProducts
        navigationController?.pushViewController(next, animated: true)
    }
    
    func addArticle(article: Product) {
        soldProducts.append(article)
    }
    
    func updateBadgeArticles() {
        guard let btn = self.shopButton else { return }
        btn.badgeText = "\(soldProducts.count)"
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCell, for: indexPath) as? ProductsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.product = products[indexPath.row]
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 4
        let totalSpacing = (2 * self.spacingCell) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        let width = (productsCollectionView.bounds.width - totalSpacing - self.spacingCell)/numberOfItemsPerRow
        //let height = width * 1.5 < 230 ? 230 : width * 1.5
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        next.product = products[indexPath.row]
        navigationController?.pushViewController(next, animated: true)
    }
    
    func successBuy() {
        soldProducts.removeAll()
        updateBadgeArticles()
        let alert = UIAlertController(title: "Congratulations!", message: "Your order is going on the way!", preferredStyle: .alert)
        
        let optionOk = UIAlertAction(title: "Ok", style: .default) { (sender) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(optionOk)
        
        self.present(alert, animated: true)

    }
    
}
