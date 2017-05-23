//
//  Constant.swift
//  TestSwift
//
//  Created by An on 8/26/16.
//  Copyright © 2016 NOIS. All rights reserved.
//

/*
    how to share gif via FB?
    have to click 2 times to open FB login
 */

/* IMPROVEMENT:
    - implement more test cases to cover the whole project
    - generic function for adding data to DB or combine them into 1 function
    - typealias for parameters
    - autolayout
    - implement encypt dectypt password in User NSManagedObject subclass
    - validation put in model class?
    - apply MVVM to reduce the heavy job of controllers, what about VIPER? -- Cocoa MVC is the best architectural pattern in terms of the speed of the development.
*/


import UIKit

struct MAXLENGTH{
    static let EMAIL = 254
    static let PASSWORD = 32
    static let FULLNAME = 128
    static let PHONE = 32
    static let MEDICINE = 254
}

struct ALERT {
    static let CANNOT_ECRYPT_PASSWORD = "Cannot encrypt password"
    static let PLEASE_ENTER_EMAIL = "Email is empty"
    static let PLEASE_ENTER_PASSWORD = "Password is empty"
    static let PLEASE_CONFIRM_PASSWORD = "Please confirm your password"
    static let PASSWORDS_NOT_MATCH = "Passwords do not match"
    static let WRONG_EMAIL = "Wrong email"
    static let WRONG_PASSWORD = "Wrong password"
    static let CANNOT_ENCRYPT_PASSWORD = "Cannot decrypt password"
    static let CANNOT_REGISTER_NEW_USER = "Cannot register new users"
    
    static let EMAIL_EXIST = "Email already exists"
    static let CANNOT_ADD_PATIENT = "Cannot add new patients"
    static let PLEASE_ENTER_PATIENT_EMAIL = "Please enter patient's email"
    static let PLEASE_ENTER_PATIENT_FULLNAME = "Please enter patient's full name"
    static let PLEASE_ENTER_PATIENT_PHONE = "Please enter patient's phone number"
    
    static let MEDICINE_EXIST = "Medicine already exists"
    static let PLEASE_ENTER_MEDICINE_NAME = "Please enter medicine's name"
    
    static let PLEASE_SELECT_MEDICINE = "Please select a medicine"
    static let PLEASE_SELECT_SCHEDULE = "Please select schedule time"
    static let PLEASE_ENTER_DOSAGE = "Please enter medicine amount"
    static let PLEASE_SELECT_TYPE = "Please select type"
    static let PLEASE_SELECT_PRIORITY = "Please select priority"
    static let CANNOT_ADD_MEDICINE = "Cannot add new medicine"
    static let CANNOT_ADD_SCHEDULE = "Cannot add new schedule"
    
    static let CANNOT_GET_DATA_FROM_DB = "Cannot get data from database"
    static let CANNOT_GET_MEDICINE_LIST = "Cannot get medicine list from database"
    
}

struct DB{
    static let DB_NAME = "Nurse"
    static let DB_FILENAME = "nurse.sqlite"
    
    static let ERROR_CREATING_DB = "There was an error creating or loading the application's saved data."
    static let ERROR_FAIL_INIT_DB = "Failed to initialize the application's saved data"
    
    struct TABLE{
        static let USER = "User"
        static let MEDICINE = "Medicine"
        static let SCHEDULE = "Schedule"
        static let PATIENT = "Patient"
        
        struct MEDICINE_COLUME{
            static let NAME = "name"
        }
        
        struct USER_COLUME{
            static let EMAIL = "email"
        }
        
        struct PATIENT_COLUME{
            static let USER = "user"
            static let EMAIL = "email"
        }
        
        struct SCHEDULE_COLUME{
            static let PATIENT = "patient"
            static let USER = "user"
            static let TIME = "time"
            static let PRIORITY = "priority"
        }
    }
    
    struct ERROR_CODE{
        static let NO_NURSE = 999
    }
    
    struct ERROR_MSG{
        static let NO_NURSE = "There's no current logged in nurse"
    }
}

struct SEGUE{
    static let ADD_SCHEDULE = "add schedule"
}

struct DOSAGE_TYPE{
    static let ML = "ml"
    static let PILL = "pills"
}

struct STORYBOARD_ID {
    static let PATIENT_DETAILS = "PatientDetailsViewController"
    static let LOGIN = "LoginViewController"
    static let MAIN = "MainViewController"
}

struct CELL_ID {
    static let PATIENT = "patientCellID"
    static let MEDICINE = "medicineCellID"
    static let SCHEDULE = "scheduleCellID"
}

struct K {
    static let DEVELOPMENT = false
    static let TEST_EMAIL = "an@gmail.com"
    static let TEST_PASSWORD = "111111"
    
    static let ALERT_OK_BUTTON = "OK"
    static let BANNER_DURATION = 5.0
    static let BANNER_COLOR = UIColor(red:62.00/255.0, green:64.0/255.0, blue:70/255.0, alpha:1.000)
    
    static let TITLE_ADD_SCHEDULE = "Add Schedule"
    static let TITLE_ALL_SCHEDULES = "All Schedules"
    
    static let KEY_NTF_MESSAGE = "message"
    
    static let ENCRYPTION_KEY = "passwordpasswors"
    static let ENCRYPTION_IV = "drowssapdrowssap"
    
    static let NOTIFICATION_SCHEDULE = "schedule notification"
    
    static let PRIORITY_HIGH = "High"
    static let PRIORITY_MEDIUM = "Medium"
    static let PRIORITY_LOW = "Low"
    
    static let PRIORITY_NUMBER_HIGH = 3
    static let PRIORITY_NUMBER_MEDIUM = 2
    static let PRIORITY_NUMBER_LOW = 1
    
    static let PATIENT = "Patient"
    static let MEDICINE = "Medicine"
    
    static func SCHEDULE_MSG(fullname: String, dosage: String, type: String, medicine: String, priority: String) -> String{
        return "Priority: \(priority). Patient: \(fullname). Medicine: \(dosage) \(type) of \(medicine)"
    }
    
    static func ERROR_MSG(errorMsg: String, errorDescription: String) -> String{
        return "\(errorMsg). ERROR: \(errorDescription)"
    }
}




