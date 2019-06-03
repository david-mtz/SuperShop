//
//  CartViewController.swift
//  SuperShop
//
//  Created by David on 5/28/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    var listItems: [Product] = [Product]()
    
    let rehuseIdCell = "rehuseCell"
    
    var panGesture = UIPanGestureRecognizer()
    
    let kBounceValue:CGFloat = 0
    
    var swipeActiveCell: ProductCollectionViewCell?

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: rehuseIdCell)
        setUpUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let controller = navigationController?.viewControllers.last as? HomeViewController else {
            return
        }
        controller.soldProducts = listItems
    }
    
    func setUpUI() {
        collectionView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.Shop.backgroundPage
        totalLabel.textColor = UIColor.Shop.textImportant
        viewBottom.addBorder(side: .top, thickness: 1.50, color: UIColor.Shop.backgroundPage)
        
        // Gesture
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panThisCell))
        panGesture.delegate = self
        self.collectionView.addGestureRecognizer(panGesture)
        
        totalUI()
    }
    
    func totalUI() {
        calcTotal()
        buyBtn.isEnabled = (listItems.count == 0) ? false : true
        buyBtn.alpha = (listItems.count == 0) ? 0.8 : 1.0
    }
    
    func calcTotal() {
        var total:Float = 0.0
        
        for item in listItems {
            total += Float(item.price) ?? 0
        }
        let totalToStr = String(format: "%.2f", total)
        totalLabel.text = "Total: $ \(totalToStr)"
        
    }

    @IBAction func buyNowAction(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BuyViewController") as! BuyViewController
        next.listItems = listItems
        navigationController?.pushViewController(next, animated: true)
    }
    
}

extension CartViewController: SendCommandToVC{
    
    func deleteThisCell(){
        
        guard let indexpath = self.collectionView.indexPath(for: swipeActiveCell!) else { return }
        listItems.remove(at: indexpath.row)
        self.collectionView.deleteItems(at: [indexpath])
        totalUI()
        
    }
}


extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rehuseIdCell, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        cell.item = listItems[indexPath.row]
        
        cell.backgroundColor = .white
        //cell.contentVisibleView.backgroundColor = .white
        cell.delegate = self
        cell.layer.cornerRadius = 8

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 100)
    }
            
    
}

extension CartViewController: UIGestureRecognizerDelegate{
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension CartViewController {
    @objc func panThisCell(_ recognizer:UIPanGestureRecognizer){
        
        if recognizer != panGesture{  return }
        
        let point = recognizer.location(in: self.collectionView)
        let indexpath = self.collectionView.indexPathForItem(at: point)
        if indexpath == nil{  return }
        guard let cell = self.collectionView.cellForItem(at: indexpath!) as? ProductCollectionViewCell else{
            
            return
            
        }
        switch recognizer.state {
        case .began:
            
            cell.startPoint =  self.collectionView.convert(point, to: cell)
            cell.startingRightLayoutConstraintConstant  = cell.contentViewRightConstraint.constant
            if swipeActiveCell != cell && swipeActiveCell != nil{
                
                self.resetConstraintToZero(swipeActiveCell!,animate: true, notifyDelegateDidClose: false)
            }
            swipeActiveCell = cell
            
        case .changed:
            
            let currentPoint =  self.collectionView.convert(point, to: cell)
            let deltaX = currentPoint.x - cell.startPoint.x
            var panningleft = false
            
            if currentPoint.x < cell.startPoint.x{
                
                panningleft = true
                
            }
            if cell.startingRightLayoutConstraintConstant == 0{
                
                if !panningleft{
                    
                    let constant = max(-deltaX,0)
                    if constant == 0{
                        
                        self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: false)
                        
                    }else{
                        
                        cell.contentViewRightConstraint.constant = constant
                        
                    }
                }else{
                    
                    let constant = min(-deltaX,self.getButtonTotalWidth(cell))
                    if constant == self.getButtonTotalWidth(cell){
                        
                        self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: false)
                        
                    }else{
                        
                        cell.contentViewRightConstraint.constant = constant
                        cell.contentViewLeftConstraint.constant = -constant
                    }
                }
            }else{
                
                let adjustment = cell.startingRightLayoutConstraintConstant - deltaX;
                if (!panningleft) {
                    
                    let constant = max(adjustment, 0);
                    if (constant == 0) {
                        
                        self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: false)
                        
                    } else {
                        
                        cell.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    let constant = min(adjustment, self.getButtonTotalWidth(cell));
                    if (constant == self.getButtonTotalWidth(cell)) {
                        
                        self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: false)
                    } else {
                        
                        cell.contentViewRightConstraint.constant = constant;
                    }
                }
                cell.contentViewLeftConstraint.constant = -cell.contentViewRightConstraint.constant;
                
            }
            cell.layoutIfNeeded()
        case .cancelled:
            
            if (cell.startingRightLayoutConstraintConstant == 0) {
                
                self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: true)
                
            } else {
                
                self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: true)
            }
            
        case .ended:
            
            if (cell.startingRightLayoutConstraintConstant == 0) {
                
                //Cell was opening
                let halfOfButtonOne = (cell.swipeView.frame).width / 2;
                if (cell.contentViewRightConstraint.constant >= halfOfButtonOne) {
                    //Open all the way
                    self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: true)
                } else {
                    //Re-close
                    self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: true)
                }
            } else {
                //Cell was closing
                let buttonOnePlusHalfOfButton2 = (cell.swipeView.frame).width
                if (cell.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) {
                    //Re-open all the way
                    self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: true)
                } else {
                    //Close
                    self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: true)
                }
            }
            
        default:
            print("default")
        }
    }
    func getButtonTotalWidth(_ cell:ProductCollectionViewCell)->CGFloat{
        
        let width = cell.frame.width - cell.swipeView.frame.minX
        return width
        
    }
    
    func resetConstraintToZero(_ cell:ProductCollectionViewCell, animate:Bool,notifyDelegateDidClose:Bool){
        
        if (cell.startingRightLayoutConstraintConstant == 0 &&
            cell.contentViewRightConstraint.constant == 0) {
            //Already all the way closed, no bounce necessary
            return;
        }
        cell.contentViewRightConstraint.constant = -kBounceValue;
        cell.contentViewLeftConstraint.constant = kBounceValue;
        self.updateConstraintsIfNeeded(cell,animated: animate) {
            cell.contentViewRightConstraint.constant = 0;
            cell.contentViewLeftConstraint.constant = 0;
            
            self.updateConstraintsIfNeeded(cell,animated: animate, completionHandler: {
                
                cell.startingRightLayoutConstraintConstant = cell.contentViewRightConstraint.constant;
            })
        }
        cell.startPoint = CGPoint()
        swipeActiveCell = nil
    }
    
    func setConstraintsToShowAllButtons(_ cell:ProductCollectionViewCell, animate:Bool,notifyDelegateDidOpen:Bool){
        
        if (cell.startingRightLayoutConstraintConstant == self.getButtonTotalWidth(cell) &&
            cell.contentViewRightConstraint.constant == self.getButtonTotalWidth(cell)) {
            return;
        }
        cell.contentViewLeftConstraint.constant = -self.getButtonTotalWidth(cell) - kBounceValue;
        cell.contentViewRightConstraint.constant = self.getButtonTotalWidth(cell) + kBounceValue;
        
        self.updateConstraintsIfNeeded(cell,animated: animate) {
            cell.contentViewLeftConstraint.constant =  -(self.getButtonTotalWidth(cell))
            cell.contentViewRightConstraint.constant = self.getButtonTotalWidth(cell)
            
            
            self.updateConstraintsIfNeeded(cell,animated: animate, completionHandler: {() in
                
                cell.startingRightLayoutConstraintConstant = cell.contentViewRightConstraint.constant;
            })
        }
    }
    
    func setConstraintsAsSwipe(_ cell:ProductCollectionViewCell, animate:Bool,notifyDelegateDidOpen:Bool){
        
        if (cell.startingRightLayoutConstraintConstant == self.getButtonTotalWidth(cell) &&
            cell.contentViewRightConstraint.constant == self.getButtonTotalWidth(cell)) {
            return;
        }
        cell.contentViewLeftConstraint.constant = -self.getButtonTotalWidth(cell) - kBounceValue;
        cell.contentViewRightConstraint.constant = self.getButtonTotalWidth(cell) + kBounceValue;
        
        self.updateConstraintsIfNeeded(cell,animated: animate) {
            cell.contentViewLeftConstraint.constant =  -(self.getButtonTotalWidth(cell))
            cell.contentViewRightConstraint.constant = self.getButtonTotalWidth(cell)
            
            self.updateConstraintsIfNeeded(cell,animated: animate, completionHandler: {() in
                
                cell.startingRightLayoutConstraintConstant = cell.contentViewRightConstraint.constant;
            })
        }
    }
    
    
    func updateConstraintsIfNeeded(_ cell:ProductCollectionViewCell, animated:Bool,completionHandler:@escaping ()->()) {
        var duration:Double = 0
        if animated{
            
            duration = 0.1
            
        }
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            
            cell.layoutIfNeeded()
            
        }, completion:{ value in
            
            if value{ completionHandler() }
        })
    }

}
