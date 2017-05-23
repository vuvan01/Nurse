//
//  ScheduleViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import DropDown

class AddScheduleViewController: BaseViewController{

    var ddMedicine = DropDown()
    var ddDosage = DropDown()
    var ddPriority = DropDown()
    
    @IBOutlet var tfTime: UserInputTextField!
    @IBOutlet var tfPriority: UserInputTextField!
    @IBOutlet var tfDosageType: UserInputTextField!
    @IBOutlet var tfDosage: UserInputTextField!
    @IBOutlet var tfMedicine: UserInputTextField!
    @IBOutlet var btnAdd: UIButton!
    
    let datepicker = UIDatePicker()
    var selectedMedicine: Medicine!
    var selectedTime: Date!
    
    let alertUtil = AlertUtil()
    
    var patient: Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = K.TITLE_ADD_SCHEDULE
        
        setupView()
    }
    
    func setupView(){
        
        tfMedicine.setup(maxLength: nil, errorMessageWhenEmpty: ALERT.PLEASE_SELECT_MEDICINE, ownerVC: self)
        tfTime.setup(maxLength: nil, errorMessageWhenEmpty: ALERT.PLEASE_SELECT_SCHEDULE, ownerVC: self)
        tfDosage.setup(maxLength: nil, errorMessageWhenEmpty: ALERT.PLEASE_ENTER_DOSAGE, ownerVC: self)
        tfDosageType.setup(maxLength: nil, errorMessageWhenEmpty: ALERT.PLEASE_SELECT_TYPE, ownerVC: self)
        tfPriority.setup(maxLength: nil, errorMessageWhenEmpty: ALERT.PLEASE_SELECT_PRIORITY, ownerVC: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dissmissAllPicker))
        self.view.addGestureRecognizer(tapGesture)
        
        
        getAllMedicine()
        
        
        ddPriority.dataSource = [K.PRIORITY_HIGH, K.PRIORITY_MEDIUM, K.PRIORITY_LOW]
        ddPriority.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfPriority.text = item
        }
        ddPriority.anchorView = tfPriority
        
        
        ddDosage.dataSource = [DOSAGE_TYPE.ML, DOSAGE_TYPE.PILL]
        ddDosage.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tfDosageType.text = item
        }
        ddDosage.anchorView = tfDosageType
        
        
        setupDropDownView(dd: ddDosage)
        setupDropDownView(dd: ddPriority)
        setupDropDownView(dd: ddMedicine)

        
        tfTime.inputView = datepicker
        datepicker.datePickerMode = UIDatePickerMode.time
        datepicker.addTarget(self, action: #selector(self.didSelectTime), for: .valueChanged)
        tfTime.inputView = datepicker
    }
    
    func setupDropDownView(dd: DropDown){
        dd.textColor = UIColor.white
        dd.backgroundColor = btnAdd.backgroundColor
    }
    
    func getAllMedicine(){
        weak var weakSelf = self
        dbMan().getAllMedicine { (result, error) in
            if result.status == .success{
                let medicines = result.data as! [Medicine] as NSArray
                if medicines.count > 0 {
                    weakSelf?.initDropDownMedicine(medicines: medicines)
                }else{
                    weakSelf?.ddMedicine.dataSource = []
                }
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_GET_MEDICINE_LIST, errorDescription: (error?.localizedDescription)!) , vc: self)
            }
        }
    }
    
    func initDropDownMedicine(medicines: NSArray){
        let medicinesName = medicines.value(forKey: DB.TABLE.MEDICINE_COLUME.NAME)
        ddMedicine.dataSource = medicinesName as! [String]
        ddMedicine.selectionAction = { (index: Int, item: String) in
            self.tfMedicine.text = item
            self.selectedMedicine = medicines[index] as! Medicine
        }
        ddMedicine.anchorView = tfMedicine
    }
    
    
    func dissmissAllPicker(sender: Any){
        self.view.endEditing(true)
    }
    
    func didSelectTime(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        tfTime.text = formatter.string(from: sender.date)
        selectedTime = sender.date
    }
    
    @IBAction func clickSave(sender:Any){
        // Check if textfield is empty
        if validateInput() == true{
            doAddSchedule()
        }
    }
    
    func doAddSchedule(){
        weak var weakSelf = self
        dbMan().addSchedule(time: selectedTime, amount: tfDosage.text!, medicine: selectedMedicine, priority: tfPriority.text!, patient: patient, dosageType: tfDosageType.text!) { (status, error) in
            if status == .success{
                weakSelf?.addScheduleAlarm()
                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }else{
                weakSelf?.alertUtil.alert(message: K.ERROR_MSG(errorMsg: ALERT.CANNOT_ADD_SCHEDULE, errorDescription: (error?.localizedDescription)!), vc: self)
            }
        }
    }
    
    func addScheduleAlarm(){
        let notification: UILocalNotification = UILocalNotification()
        notification.fireDate = selectedTime
        notification.alertBody = K.SCHEDULE_MSG(fullname: patient.fullname!, dosage:tfDosage.text!,  type:tfDosageType.text!, medicine:tfMedicine.text!, priority: tfPriority.text!)
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func validateInput() -> Bool{
        return tfMedicine.validateTextField()
            && tfDosage.validateTextField()
            && tfDosageType.validateTextField()
            && tfTime.validateTextField()
            && tfPriority.validateTextField()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension AddScheduleViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // don't show keyboard when user clicks in textfields, show dropdown list instead
        if textField == tfMedicine{
            ddMedicine.show()
            return false
        }else if textField == tfDosageType{
            ddDosage.show()
            return false
        }else if textField == tfPriority{
            ddPriority.show()
            return false
        }
        return true
    }
}

