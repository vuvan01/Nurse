//
//  NurseAdministrationTests.swift
//  NurseAdministrationTests
//
//  Created by An on 11/30/16.
//  Copyright © 2016 An. All rights reserved.
//

import XCTest
import CoreData
@testable import Nurse

class DataManagerTests: XCTestCase {
    
    let dm = DBManager.shared
    let encryptUtil = EncryptionUtil()
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
        super.setUp()
        
        clearDB(table: DB.TABLE.USER)
        clearDB(table: DB.TABLE.MEDICINE)
        clearDB(table: DB.TABLE.SCHEDULE)
        clearDB(table: DB.TABLE.PATIENT)
    }
    
    func clearDB(table: String){
        let managedContext = delegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: table)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results{
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch {
            XCTFail()
        }
    }
    
    func testEncryptPassword(){
        encryptUtil.encryptPassword(password: C.TEST_PASSWORD) { (result, error) in
            if result.status == .success{
                XCTAssertNotNil(result.data)
            }else{
                XCTFail()
            }
        }
    }
    
    func testDecryptPassword(){
        encryptUtil.encryptPassword(password: C.TEST_PASSWORD) { (result, error) in
            if result.status == .success{
                encryptUtil.decryptPassword(data: result.data as! Data) { (result, error) in
                    if result.status == .success{
                        XCTAssertEqual(result.data as! String, C.TEST_PASSWORD)
                    }else{
                        XCTFail()
                    }
                }
            }else{
                XCTFail()
            }
        }
    }
    
    
    func testAddUser() {
        encryptUtil.encryptPassword(password: C.TEST_PASSWORD) { (result, error) in
            if result.status == .success{
                dm.addUser(email: C.TEST_EMAIL, password: result.data as! NSData, handler: { (status, error) in
                    XCTAssertEqual(status, SaveStatus.success)
                })
            }else{
                XCTFail()
            }
        }
    }
    
    func testGetUser(){
        testAddUser()
        dm.getUser(email: C.TEST_EMAIL) { (result, error) in
            
            XCTAssertEqual(result.status, FetchStatus.success)
            
            let array = result.data as! [User]
            XCTAssertGreaterThan(array.count, 0)
            
            if array.count > 0 {
                let item = array[0]
                XCTAssertEqual(item.email, C.TEST_EMAIL)
            }
            
        }
    }
    
    func testAddPatient(){
        testAddUser()
        dm.getUser(email: C.TEST_EMAIL) { (result, error) in
            
            XCTAssertEqual(result.status, FetchStatus.success)
            
            let array = result.data as! [User]
            XCTAssertGreaterThan(array.count, 0)
            
            if array.count > 0 {
                let item = array[0]
                self.delegate.loggedInUser = item
                
                self.dm.addPatient(email: C.PATIENT_EMAIL, fullname: C.PATIENT_FULLNAME, phone: C.PATIENT_PHONE) { (status, error) in
                    XCTAssertEqual(status, SaveStatus.success)
                }
            }
        }
    }
    
    func testGetPatient(){
        testAddPatient()
        dm.getPatient(email: C.PATIENT_EMAIL) { (result, error) in
            XCTAssertEqual(result.status, FetchStatus.success)
            
            let array = result.data as! [Patient]
            XCTAssertGreaterThan(array.count, 0)
            
            if array.count > 0 {
                let item = array[0]
                XCTAssertEqual(item.email, C.PATIENT_EMAIL)
            }
            
        }
    }
    
    func testAddMedicine(){
        dm.addMedicine(name: C.MEDICINE_NAME) { (status, error) in
            XCTAssertEqual(status, SaveStatus.success)
        }
    }
    
    func testGetMedicine(){
        testAddMedicine()
        dm.getMedicine(name: C.MEDICINE_NAME) { (result, error) in
            XCTAssertEqual(result.status, FetchStatus.success)
            
            let array = result.data as! [Medicine]
            XCTAssertGreaterThan(array.count, 0)
            
            if array.count > 0 {
                let item = array[0]
                XCTAssertEqual(item.name, C.MEDICINE_NAME)
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
}
