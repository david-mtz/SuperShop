//
//  BuyViewController.swift
//  SuperShop
//
//  Created by David on 6/2/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {

    var listItems: [Product] = [Product]()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var cvvTextField: UITextField!
    
    @IBOutlet weak var addressTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Shop.backgroundPage
        navigationController?.navigationBar.topItem?.title = "Cancel"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func payNowAction(_ sender: UIButton) {
        
        var error: Bool = false
        
        if nameTextField.text!.isEmpty || !isValidRegEx(nameTextField.text!, "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$") {
            nameTextField.shake()
            error = true
        }
        
        if cardNumberTextField.text!.isEmpty || !isValidRegEx(cardNumberTextField.text!, "^[0-9]{15}(?:[0-9]{1})?$") {
            cardNumberTextField.shake()
            error = true
        }
        
        if cvvTextField.text!.isEmpty || !isValidRegEx(cvvTextField.text!, "^[0-9]{3,4}$") {
            cvvTextField.shake()
            error = true
        }

        if addressTextView.text!.isEmpty {
            addressTextView.shake()
            error = true
        }
        
        if error == false {
            
            let alert = UIAlertController(title: "Alert!", message: "Are you sure to paid?", preferredStyle: .alert)
            
            let optionOk = UIAlertAction(title: "Ok", style: .default) { (sender) in
                guard let rootController = self.navigationController?.viewControllers[0] as? HomeViewController else {return}
                self.navigationController?.popToRootViewController(animated: true)
                rootController.successBuy()
            }
            
            let optionCancel = UIAlertAction(title: "Cancel", style: .destructive) { (sender) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(optionCancel)
            alert.addAction(optionOk)
            
            self.present(alert, animated: true)

        }
        
        
    }
    
    func isValidRegEx(_ testStr: String, _ regex: String) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = stringTest.evaluate(with: testStr)
        return result
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
