//
//  PatientManager.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CoreData

class PatientManager: BaseDBManager {

    func addPatient(email: String, fullname: String, phone: String, nurse: User, handler: @escaping (_ status: SaveStatus, _ error: NSError?) -> Void){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: DB.TABLE.PATIENT, in: managedContext!)!
        let patient = NSManagedObject(entity: entity, insertInto: managedContext) as! Patient
        patient.email = email
        patient.fullname = fullname
        patient.phone = phone
        patient.user = nurse
        
        save { (status, error) in
            handler(status, error)
        }
    }
    
    func getPatient(email: String, handler: @escaping (_ result: FetchResult, _ error: NSError?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DB.TABLE.PATIENT)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", DB.TABLE.PATIENT_COLUME.EMAIL, email)
        
        fetch(fetchRequest: fetchRequest) { (result, error) in
            handler ( result, error )
        }
    }
    
    func getAssociatedPatients(nusre: User, handler: @escaping (_ result: FetchResult, _ error: NSError?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DB.TABLE.PATIENT)
        let currentNurse = nusre
        fetchRequest.predicate = NSPredicate(format: "%K.%K == %@", DB.TABLE.PATIENT_COLUME.USER, DB.TABLE.USER_COLUME.EMAIL, currentNurse.email!)
        
        fetch(fetchRequest: fetchRequest) { (result, error) in
            handler ( result, error )
        }
    }
}
