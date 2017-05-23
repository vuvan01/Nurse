//
//  TestValidation.swift
//  NurseAdministration
//
//  Created by An on 12/2/16.
//  Copyright © 2016 An. All rights reserved.
//

import XCTest
@testable import Nurse

class ValidationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidationRegister() {
        let storyboard = UIStoryboard(name: C.STORYBOARD, bundle: Bundle.main)
        let registerVC = storyboard.instantiateViewController(withIdentifier: C.REGISTER_VC) as! RegisterViewController
        UIApplication.shared.keyWindow!.rootViewController = registerVC

        registerVC.tfEmail.text = C.TEST_EMAIL
        registerVC.tfPassword.text = C.EMPTY_PASSWORD
        registerVC.tfConfirmPassword.text = C.EMPTY_PASSWORD
        
        var success = registerVC.validateInput()
        XCTAssertFalse(success)
        
        registerVC.tfEmail.text = C.TAB_PASSWORD
        registerVC.tfPassword.text = C.TEST_PASSWORD
        registerVC.tfConfirmPassword.text = C.TEST_PASSWORD
        
        success = registerVC.validateInput()
        XCTAssertFalse(success)
        
        
        registerVC.tfEmail.text = C.TEST_EMAIL
        registerVC.tfPassword.text = C.LONG_PASSWORD
        registerVC.tfConfirmPassword.text = C.EMPTY_PASSWORD
        
        success = registerVC.validateInput()
        XCTAssertFalse(success)
    }
    
    func testValidationLogin(){
        let storyboard = UIStoryboard(name: C.STORYBOARD, bundle: Bundle.main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: C.LOGIN_VC) as! LoginViewController
        UIApplication.shared.keyWindow!.rootViewController = loginVC
        
        loginVC.tfEmail.text = C.TEST_EMAIL
        loginVC.tfPassword.text = C.EMPTY_PASSWORD
        
        var success = loginVC.validateInput()
        XCTAssertFalse(success)
        
        loginVC.tfEmail.text = C.TAB_STRING
        loginVC.tfPassword.text = C.EMPTY_PASSWORD
        
        success = loginVC.validateInput()
        XCTAssertFalse(success)
    }
    
    func testValidationAddMedicine(){
        let storyboard = UIStoryboard(name: C.STORYBOARD, bundle: Bundle.main)
        let medicineVC = storyboard.instantiateViewController(withIdentifier: C.ADD_MEDICINE_VC) as! AddMedicineViewController
        UIApplication.shared.keyWindow!.rootViewController = medicineVC
        
        medicineVC.tfName.text = C.TAB_STRING
        
        let success = medicineVC.validateInput()
        XCTAssertFalse(success)
    }
    
    func testValidationAddPatient(){
        let storyboard = UIStoryboard(name: C.STORYBOARD, bundle: Bundle.main)
        let patientVC = storyboard.instantiateViewController(withIdentifier: C.ADD_PATIENT_VC) as! AddPatientViewController
        UIApplication.shared.keyWindow!.rootViewController = patientVC
                
        patientVC.tfFullName.text =  C.TAB_STRING
        patientVC.tfEmail.text =  C.TAB_STRING
        patientVC.tfPhone.text = C.EMPTY_STRING
        
        let success = patientVC.validateInput()
        XCTAssertFalse(success)
    }
    
    func testValidationAddSchedule(){
        let storyboard = UIStoryboard(name: C.STORYBOARD, bundle: Bundle.main)
        let scheduleVC = storyboard.instantiateViewController(withIdentifier: C.ADD_SCHE_VC) as! AddScheduleViewController
        UIApplication.shared.keyWindow!.rootViewController = scheduleVC
        
        scheduleVC.tfTime.text = C.TAB_STRING
        scheduleVC.tfDosage.text = C.TAB_STRING
        scheduleVC.tfMedicine.text = C.TAB_STRING
        scheduleVC.tfPriority.text = C.EMPTY_STRING
        
        let success = scheduleVC.validateInput()
        XCTAssertFalse(success)
    }
    
}
