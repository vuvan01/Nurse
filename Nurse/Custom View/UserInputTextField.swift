//
//  NonEmptyTextField.swift
//  Nurse
//
//  Created by Ken Vu on 12/7/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class UserInputTextField: UITextField, UITextFieldDelegate{

    private var maxLength = Int.max
    private var errorMessageWhenEmpty: String!
    private var ownerVC: UIViewController!
    
    func setup(maxLength: Int?, errorMessageWhenEmpty: String, ownerVC: UIViewController!) {
        if maxLength != nil{
            self.maxLength = maxLength!
        }
        self.errorMessageWhenEmpty = errorMessageWhenEmpty
        self.ownerVC = ownerVC
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return shouldChangeCharacterInRange(text: textField.text!, maxLength: maxLength, shouldChangeCharactersIn: range, replacementString: string)
    }

    func validateTextField() -> Bool{
        let isEmptyTextField = self.text!.isEmptyString()
        
        // show alert if textfield is empty
        if isEmptyTextField == true{
            if errorMessageWhenEmpty != nil{
                let alertUtil = AlertUtil()
                alertUtil.alert(message: errorMessageWhenEmpty!, vc: ownerVC!)
            }
        }
        
        return !isEmptyTextField
    }

}

extension UserInputTextField{
    func shouldChangeCharacterInRange(text: String, maxLength: Int, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let currentString = text as NSString?
        let newString = currentString?.replacingCharacters(in: range, with: string)
        return (newString?.characters.count)! <= maxLength
    }
}

extension String{
    func isEmptyString() -> Bool{
        let whitespaceSet = NSCharacterSet.whitespaces
        
        if (self.trimmingCharacters(in: whitespaceSet).isEmpty) {
            return true
        }else{
            return false
        }
    }
}
