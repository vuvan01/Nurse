//
//  ScheduleManager.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CoreData

class ScheduleManager: BaseDBManager {

    func addSchedule(time: Date, amount: String, medicine: Medicine, priority: String, patient: Patient, dosageType: String, nurse: User,
                     handler: @escaping (_ status: SaveStatus, _ error: NSError?) -> Void){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: DB.TABLE.SCHEDULE, in: managedContext!)!
        let schedule = NSManagedObject(entity: entity, insertInto: managedContext) as! Schedule
        schedule.dosage = amount
        schedule.dosageType = dosageType
        schedule.time = time as NSDate?
        schedule.medicine = medicine
        schedule.priority = Int16(getPriority(priority: priority))
        schedule.patient = patient
        schedule.user = nurse
        
        save { (status, error) in
            handler(status, error)
        }
    }
    
    func getSchedule(nurse: User, handler: @escaping (_ result: FetchResult, _ error: NSError?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DB.TABLE.SCHEDULE)
        
        let sortDescriptor = NSSortDescriptor(key: DB.TABLE.SCHEDULE_COLUME.TIME, ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: DB.TABLE.SCHEDULE_COLUME.PRIORITY, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        fetchRequest.predicate = NSPredicate(format: "%K.%K == %@", DB.TABLE.SCHEDULE_COLUME.USER, DB.TABLE.USER_COLUME.EMAIL, nurse.email!)
        
        fetch(fetchRequest: fetchRequest) { (result, error) in
            handler ( result, error )
        }
    }
    
    func getScheduleForPatient(patient: Patient, handler: @escaping (_ result: FetchResult, _ error: NSError?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DB.TABLE.SCHEDULE)
        let sortDescriptor = NSSortDescriptor(key: DB.TABLE.SCHEDULE_COLUME.TIME, ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: DB.TABLE.SCHEDULE_COLUME.PRIORITY, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        fetchRequest.predicate = NSPredicate(format: "%K.%K == %@", DB.TABLE.SCHEDULE_COLUME.PATIENT, DB.TABLE.PATIENT_COLUME.EMAIL, patient.email!)
        
        fetch(fetchRequest: fetchRequest) { (result, error) in
            handler ( result, error )
        }
    }
    
    func getPriority(priority: String) -> Int{
        if priority == K.PRIORITY_HIGH{
            return K.PRIORITY_NUMBER_HIGH
        }else if priority == K.PRIORITY_MEDIUM{
            return K.PRIORITY_NUMBER_MEDIUM
        }else if priority == K.PRIORITY_LOW{
            return K.PRIORITY_NUMBER_LOW
        }
        return 999
    }
}
