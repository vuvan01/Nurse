//
//  DataManager.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CoreData

protocol DataSaveable {
    
}

struct LoginData {
    var email: String
    var password: String
    
    init(email: String, password: String){
        self.email = email
        self.password = password
    }
}

struct PatientData{
    var email: String
    var phone: String
    
    init(email: String, phone: String){
        self.email = email
        self.phone = phone
    }
}

class DBManager: NSObject {
    
    static let shared = DBManager()

    private var nurseManager: NurseManager!
    private var patientManager: PatientManager!
    private var medicineManager: MedicineManager!
    private var scheduleManager: ScheduleManager!
    
    typealias SaveStatusHandler = (_ status: SaveStatus, _ error: NSError?) -> Void
    typealias FetchStatusHandler = (_ result: FetchResult, _ error: NSError?) -> Void
    
    
    
    override init() {
        nurseManager = NurseManager()
        patientManager = PatientManager()
        medicineManager = MedicineManager()
        scheduleManager = ScheduleManager()
    }
    
    // GENERIC function ... not generic yet
    func addDataToDB(object: AnyObject, handler: @escaping SaveStatusHandler){
        switch object {
        case is LoginData:
            break
        default:
            print("patient data")
            break
        }
    }

    // MARK: Nurse Manager
    func addUser(email: String, password: NSData, handler: @escaping SaveStatusHandler){
        nurseManager.addUser(email: email, password: password) { (status, error) in
            handler(status, error)
        }
    }
    
    func getLoggedInUser() -> User?{
        return nurseManager.getLoggedInUser()
    }
    
    func setLoggedInUser(user: User){
        nurseManager.setLoggedInUser(user: user)
    }
    
    func getUser(email: String, handler: @escaping FetchStatusHandler){
        nurseManager.getUser(email: email) { (result, error) in
            handler (result, error)
        }
    }
    
    
    
    // MARK: Medicine Manager
    func addMedicine(name: String, handler: @escaping SaveStatusHandler){
        medicineManager.addMedicine(name: name) { (status, error) in
            handler(status, error)
        }
    }
    
    func getAllMedicine(handler: @escaping FetchStatusHandler){
        medicineManager.getAllMedicine { (result, error) in
            handler (result, error)
        }
    }
    
    func getMedicine(name: String, handler: @escaping FetchStatusHandler){
        medicineManager.getMedicine(name: name) { (result, error) in
            handler(result, error)
        }
    }
    
    
    
    // MARK: Patient Manager
    func addPatient(email: String, fullname: String, phone: String, handler: @escaping SaveStatusHandler){
        if let currentUser = nurseManager.getLoggedInUser(){
            patientManager.addPatient(email: email, fullname: fullname, phone: phone, nurse: currentUser) { (status, error) in
                handler(status, error)
            }
        }else{
            handler(SaveStatus.failure, getNoNurseError())
        }
    }
    
    
    func getPatient(email: String, handler: @escaping FetchStatusHandler){
        patientManager.getPatient(email: email) { (result, error) in
            handler(result, error)
        }
    }
    
    func getAssociatedPatients(handler: @escaping FetchStatusHandler){
        if let currentUser = nurseManager.getLoggedInUser(){
            patientManager.getAssociatedPatients(nusre: currentUser) { (result, error) in
                handler(result, error)
            }
        }else{
            handler(getNoNurseResult(), getNoNurseError())
        }
    }
    
    
    
    // MARK: Schedule Manager
    func getSchedule(handler: @escaping FetchStatusHandler){
        if let currentUser = nurseManager.getLoggedInUser(){
            scheduleManager.getSchedule(nurse: currentUser) { (result, error) in
                handler(result, error)
            }
        }else{
            handler(getNoNurseResult(), getNoNurseError())
        }
    }
    
    func addSchedule(time: Date, amount: String, medicine: Medicine, priority: String, patient: Patient, dosageType: String,
                     handler: @escaping SaveStatusHandler){
        if let currentUser = nurseManager.getLoggedInUser(){
            scheduleManager.addSchedule(time: time, amount: amount, medicine: medicine, priority: priority, patient: patient, dosageType: dosageType, nurse: currentUser, handler: { (status, error) in
                handler(status, error)
            })
        }else{
            handler(SaveStatus.failure, getNoNurseError())
        }
    }
    
    func getScheduleForPatient(patient: Patient, handler: @escaping FetchStatusHandler){
        scheduleManager.getScheduleForPatient(patient: patient) { (result, error) in
            handler(result, error)
        }
    }
    
}

extension DBManager{
    func getNoNurseError() -> NSError{
        let userInfo: [String : String] = [NSLocalizedDescriptionKey :  DB.ERROR_MSG.NO_NURSE]
        return NSError(domain: "", code: DB.ERROR_CODE.NO_NURSE, userInfo: userInfo)
    }
    
    func getNoNurseResult() -> FetchResult{
        return FetchResult(FetchStatus.failure, nil)
    }
}
