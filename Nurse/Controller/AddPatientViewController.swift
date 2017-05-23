//
//  AddPatientViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class AddPatientViewController: BaseViewController{

    @IBOutlet var tfEmail: UserInputTextField!
    @IBOutlet var tfFullName: UserInputTextField!
    @IBOutlet var tfPhone: UserInputTextField!
    let alertUtil = AlertUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmail.setup(maxLength: MAXLENGTH.EMAIL, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_PATIENT_EMAIL, ownerVC: self)
        tfFullName.setup(maxLength: MAXLENGTH.PASSWORD, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_PATIENT_FULLNAME, ownerVC: self)
        tfPhone.setup(maxLength: MAXLENGTH.PASSWORD, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_PATIENT_PHONE, ownerVC: self)
    }
    
    @IBAction func clickAdd(sender:Any){
        // Check if textfield is empty
        if validateInput() == true{
            // Check if entered email is already existing
            checkPatientExist()
        }
    }
    
    func checkPatientExist(){
        weak var weakSelf = self
        dbMan().getPatient(email: tfEmail.text!) { (result, error) in
            if result.status == .success{
                let patients = result.data as! [Patient]
                if patients.count > 0 {
                    weakSelf?.alertUtil.alert(message: ALERT.EMAIL_EXIST, vc: self)
                }else{
                    weakSelf?.addPatient()
                }
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_GET_DATA_FROM_DB, errorDescription: (error?.localizedDescription)!) , vc: self)
            }
        }
    }
    
    
    func addPatient(){
        weak var weakSelf = self
        dbMan().addPatient(email: tfEmail.text!, fullname: tfFullName.text!, phone: tfPhone.text!) { (status, error) in
            if status == .success{
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_ADD_PATIENT, errorDescription: (error?.localizedDescription)!), vc: self)
            }
        }
    }
    
    
    
    func validateInput() -> Bool{
        return tfFullName.validateTextField() && tfEmail.validateTextField() &&  tfPhone.validateTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
