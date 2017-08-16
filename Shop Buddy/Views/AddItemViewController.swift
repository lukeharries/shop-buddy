//
//  AddItemViewController.swift
//  Shop Buddy
//
//  Created by Luke Harries on 12/08/17.
//  Copyright © 2017 Luke Harries. All rights reserved.
//

import Foundation
import UIKit
import BarcodeScanner

protocol AddItemViewControllerDelegate: class {
    func addItemViewController(didFinish sender: AddItemViewController, cancelled: Bool)
}


class AddItemViewController : UIViewController, UITextFieldDelegate, BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var formContainerView: UIView!
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var firstLineStackView: UIStackView!
    @IBOutlet weak var secondLineStackView: UIStackView!
    @IBOutlet weak var priceTextField: BuddyFormTextField!
    @IBOutlet weak var quantityTextField: BuddyFormTextField!
    @IBOutlet weak var itemNameTextField: BuddyFormTextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spacerView: UIView!
    
    weak var delegate : AddItemViewControllerDelegate?
    
    
    var retrievedProduct : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(AddItemViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(AddItemViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        spacerView.isHidden = !BuddySettings.scanningEnabled
        cameraButton.isHidden = !BuddySettings.scanningEnabled
        
        applyStyle()
        setupTextFields()
        validate(price: priceTextField.text, units: quantityTextField.text)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        priceTextField.becomeFirstResponder()
    }
    
    func setupTextFields() {
        
        priceTextField.textFieldStyle = .currency
        priceTextField.keyboardType = .decimalPad
        priceTextField.delegate = self
        priceTextField.baseColour = UIColor.accent
        
        quantityTextField.textFieldStyle = .quantity
        quantityTextField.keyboardType = .decimalPad
        quantityTextField.delegate = self
        quantityTextField.baseColour = UIColor.accent

        itemNameTextField.textFieldStyle = .standard
        itemNameTextField.keyboardType = .default
        itemNameTextField.returnKeyType = .done
        itemNameTextField.delegate = self
        itemNameTextField.baseColour = UIColor.accent

    }
    
    func applyStyle () {
        self.view.backgroundColor = UIColor.clear        

        let image = UIImage(named: "barcodeScanner")?.withRenderingMode(.alwaysTemplate)
        cameraButton.setImage(image, for: .normal)
        cameraButton.tintColor = UIColor.accent
        
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        addButton.backgroundColor = UIColor.accent
    }
    
    // MARK: - Actions
    
    @IBAction func didTapCancell(_ sender: Any) {
        cancelAndClose()
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        submitAndClose()
    }
    
    @IBAction func didTapCamera(_ sender: Any) {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    
    func cancelAndClose() {
        close()
    }
    
    func submitAndClose() {
        var product : Product
        
        if retrievedProduct != nil {
            product = retrievedProduct!
        } else {
            var name : String = "Unknown Item"
            if let itemName = itemNameTextField.text, !itemName.isEmpty {
                name = itemName
            }
            
            product = Product(name: name)
        }
        
        do {
            let priceCents = try StringParser.getPriceInCents(fromString: priceTextField.text)
            let units = try StringParser.getUnits(fromString: quantityTextField.text)
            let item = ShoppingItem(product: product, unitPriceCents: priceCents, units: units)
            
            ShoppingSessionService.shared.currentSession.add(item: item)
            close()
        } catch {
            validate(price: priceTextField.text, units: quantityTextField.text)
        }
    }
    
    func validate(price: String?, units: String?) {
        let validPrice = StringParser.validatePriceString(price)
        let validUnits = StringParser.validateUnitsString(units)
        
        addButton.isEnabled = validPrice && validUnits
    }

    fileprivate func close(cancelled: Bool = false) {
        resignFirstResponder()
        
        if let delegate = self.delegate {
            delegate.addItemViewController(didFinish: self, cancelled: cancelled)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Barcodes
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        
//        ProductLookupService.lookupProduct(withBarcode: code).then { (product) -> Void in
//                controller.dismiss(animated: true, completion: nil)
//            }.catch { (error) in
//                controller.dismiss(animated: true, completion: nil)
//        }
    }
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Text Fields
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = (textField.text ?? "") as NSString
        let newString = nsString.replacingCharacters(in: range, with: string)
        
        if textField == priceTextField {
            validate(price: newString, units: quantityTextField.text)
        } else if textField == quantityTextField {
            validate(price: priceTextField.text, units: newString)
        }
        
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate(price: priceTextField.text, units: quantityTextField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == itemNameTextField {
            submitAndClose()
        }
        return false
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo!
        
        guard let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let rawCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value else { return }
        
        let rawAnimationCurve = rawCurve << 16
        
        let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
        
        bottomConstraint.constant = keyboardEndFrame.height
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    
    @objc func keyboardWillHide(notification: Notification) {
        let userInfo = notification.userInfo!
        guard let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let rawCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value else { return }
        
        let rawAnimationCurve = rawCurve << 16
        let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
        
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    
    
    
}
