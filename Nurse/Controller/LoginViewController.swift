//
//  LoginViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import ReactiveKit

class LoginViewController: BaseViewController {
    
    @IBOutlet var tfTest: UITextField!
    @IBOutlet var tfEmail: UserInputTextField!
    @IBOutlet var tfPassword: UserInputTextField!
    let alertUtil = AlertUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if K.DEVELOPMENT == true{
            tfEmail.text = K.TEST_EMAIL
            tfPassword.text = K.TEST_PASSWORD
        }
        
        tfEmail.setup(maxLength: MAXLENGTH.EMAIL, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_EMAIL, ownerVC: self)
        tfPassword.setup(maxLength: MAXLENGTH.PASSWORD, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_PASSWORD, ownerVC: self)
    }

    
    @IBAction func clickLogin(sender: Any){
        // Check if textfield is empty
        if validateInput() == true{
            checkUserEmail()
        }
        
    }
    
    func checkUserEmail(){
        weak var weakSelf = self
        dbMan().getUser(email: tfEmail.text!) { (result, error) in
            if result.status == .success{
                let users = result.data as! [User]
                if users.count == 0{
                    weakSelf?.alertUtil.alert(message: ALERT.WRONG_EMAIL, vc: self)
                }else{
                    weakSelf?.checkPassword(users: users)
                }
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_GET_DATA_FROM_DB, errorDescription: (error?.localizedDescription)!) , vc: self)
            }
        }
    }
    
    func checkPassword(users: [User]){
        let user = users[0]
        let encryptUtil = EncryptionUtil()

        
        weak var weakSelf = self
        encryptUtil.decryptPassword(data: user.password as! Data) { (result, error) in
            if result.status == .success{
                let password = result.data as! String
                if password == tfPassword.text{
                    dbMan().setLoggedInUser(user: user)
                    let vc = weakSelf?.storyboard?.instantiateViewController(withIdentifier: STORYBOARD_ID.MAIN)
                    weakSelf?.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    weakSelf?.alertUtil.alert(message: ALERT.WRONG_PASSWORD, vc: self)
                }
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_ENCRYPT_PASSWORD, errorDescription: (error?.localizedDescription)!) , vc: self)
            }
        }
    }
    
    func validateInput() -> Bool{
        return tfEmail.validateTextField() && tfPassword.validateTextField()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

