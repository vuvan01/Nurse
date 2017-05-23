//
//  RegisterViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CryptoSwift



class RegisterViewController: BaseViewController {

    @IBOutlet var tfEmail: UserInputTextField!
    @IBOutlet var tfPassword: UserInputTextField!
    @IBOutlet var tfConfirmPassword: UserInputTextField!
    
    let alertUtil = AlertUtil()
    
    var canRegister = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if K.DEVELOPMENT == true{
            tfEmail.text = K.TEST_EMAIL
            tfPassword.text = K.TEST_PASSWORD
            tfConfirmPassword.text = K.TEST_PASSWORD
        }
        
        tfEmail.setup(maxLength: MAXLENGTH.EMAIL, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_EMAIL, ownerVC: self)
        tfPassword.setup(maxLength: MAXLENGTH.PASSWORD, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_PASSWORD, ownerVC: self)
        tfConfirmPassword.setup(maxLength: MAXLENGTH.PASSWORD, errorMessageWhenEmpty: ALERT.PLEASE_CONFIRM_PASSWORD, ownerVC: self)
    }
    
    @IBAction func clickRegister(sender: Any){
        // Check if textfield is empty & passwords match
        if validateInput() == true{
            // Check if entered email is already existing in db
            checkUserExist()
        }
    }
    
    func checkUserExist(){
        weak var weakSelf = self
        dbMan().getUser(email: tfEmail.text!) { (result, error) in
            if result.status == .success{
                let users = result.data as! [User]
                if users.count > 0 {
                    weakSelf?.alertUtil.alert(message: ALERT.EMAIL_EXIST, vc: self)
                }else{
                    weakSelf?.encryptPassword()
                }
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_GET_DATA_FROM_DB, errorDescription: (error?.localizedDescription)!) , vc: self)
            }
        }
    }
    
    func encryptPassword() {
        let encryptUtil = EncryptionUtil()
        
        weak var weakSelf = self
        encryptUtil.encryptPassword(password: tfPassword.text!) { (result, error) in
            if result.status == .success{
                weakSelf?.doAddUser(encryptedPW: result.data as! NSData)
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_ECRYPT_PASSWORD, errorDescription: (error?.localizedDescription)!) , vc: self)
            }
        }
    }
    
    func doAddUser(encryptedPW: NSData){
        weak var weakSelf = self
        dbMan().addUser(email: tfEmail.text!, password: encryptedPW, handler: { (status, error) in
            if status == .success{
                let vc = weakSelf?.storyboard?.instantiateViewController(withIdentifier: STORYBOARD_ID.LOGIN)
                weakSelf?.navigationController?.pushViewController(vc!, animated: true)
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_REGISTER_NEW_USER, errorDescription: (error?.localizedDescription)!), vc: self)
            }
        })
    }
    
    func validateInput() -> Bool{
        let password = tfPassword.text
        let confirmPassword = tfConfirmPassword.text
        
        let validInput = tfEmail.validateTextField() && tfPassword.validateTextField() && tfConfirmPassword.validateTextField()
        
        var passwordMatches = false
        if validInput == true{
            if password == confirmPassword{
                passwordMatches = true
            }
            
            if passwordMatches == false{
                alertUtil.alert(message: ALERT.PASSWORDS_NOT_MATCH, vc: self)
            }
        }
        
        return passwordMatches && validInput
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

