//
//  AddMedicineViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class AddMedicineViewController: BaseViewController{

    @IBOutlet var tfName: UserInputTextField!
    let alertUtil = AlertUtil()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfName.setup(maxLength: MAXLENGTH.MEDICINE, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_MEDICINE_NAME, ownerVC: self)
    }
    
    
    @IBAction func clickAdd(sender:Any){
        // Check if textfield is empty
        if validateInput() == true{
            // check if this medicine is already added
            checkMedicineExist()
        }
    }
    
    func checkMedicineExist(){
        weak var weakSelf = self
        dbMan().getMedicine(name: tfName.text!) { (result, error) in
            if result.status == .success{
                let medicines = result.data as! [Medicine]
                if medicines.count > 0 {
                    weakSelf?.alertUtil.alert(message: ALERT.MEDICINE_EXIST, vc: self)
                }else{
                    weakSelf?.addMedicine()
                }
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_GET_DATA_FROM_DB, errorDescription: (error?.localizedDescription)!) , vc: self)
            }
        }
    }
    
    func addMedicine(){
        weak var weakSelf = self
        dbMan().addMedicine(name: tfName.text!, handler: { (status, error) in
            if status == .success{
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_ADD_MEDICINE, errorDescription: (error?.localizedDescription)!), vc: self)
            }
        })
    }
    
    func validateInput() -> Bool{
        return tfName.validateTextField()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

