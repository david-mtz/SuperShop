//
//  ProductViewController.swift
//  SuperShop
//
//  Created by David on 5/19/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UIScrollViewDelegate {

    var product: Product?
    
    let client = PhotosClient()
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    @IBOutlet weak var imagesScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
 
    @IBOutlet weak var scrollView: UIScrollView!
        
    @IBOutlet weak var parentView: UIView!
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = UIColor.Shop.backgroundPage
        priceLabel.textColor = UIColor.Shop.textImportant
        imagesScrollView.delegate = self
        
        updateView()
        setUpConstraints()
        // Do any additional setup after loading the view.
    }
        
    func updateView() {
        guard let unwrapping = self.product else { print("Vacio"); return }
        priceLabel.text = "$ \(unwrapping.price)"
        productNameLabel.text = unwrapping.name
        productDescriptionTextView.text = "Description:\n\(unwrapping.description)"
        preloadImgs()
    }
    
    func setUpConstraints() {
        
        productDescriptionTextView.isEditable = false
        productDescriptionTextView.isSelectable = false

        productDescriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
    }

    func preloadImgs() {
        guard let unwrapping = self.product else { print("Vacio"); return }
        client.show(id: unwrapping.id) { (listImgs) in
            for img in listImgs {
                let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
                slide.imgUIImageView.getImageFromUrl(url: img.url)
                self.slides.append(slide)
            }
            self.setupSlideScrollView()
        }
    }
    
    func setupSlideScrollView() {
        imagesScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        imagesScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 1.0)
        
        imagesScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: 300)
            imagesScrollView.addSubview(slides[i])
        }
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    
    @IBAction func addToCart(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Alert!", message: "Are you sure to add this article?", preferredStyle: .alert)
        
        let optionOk = UIAlertAction(title: "Ok", style: .default) { (sender) in
            self.navigationController?.popViewController(animated: true)
            let previousViewController = self.navigationController?.viewControllers.last as! HomeViewController
            previousViewController.addArticle(article: self.product!)
        }
        
        let optionCancel = UIAlertAction(title: "Cancel", style: .destructive) { (sender) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(optionCancel)
        alert.addAction(optionOk)
        
        self.present(alert, animated: true)

    }
    

}
