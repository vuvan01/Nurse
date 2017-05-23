//
//  MedicineManager.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CoreData

class MedicineManager: BaseDBManager {

    func addMedicine(name: String, handler: @escaping(_ status: SaveStatus, _ error: NSError?) -> Void){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: DB.TABLE.MEDICINE, in: managedContext!)!
        let medicine = NSManagedObject(entity: entity, insertInto: managedContext) as! Medicine
        medicine.name = name
        
        save { (status, error) in
            handler(status, error)
        }
    }
    
    func getAllMedicine(handler: @escaping (_ result: FetchResult, _ error: NSError?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DB.TABLE.MEDICINE)
        
        fetch(fetchRequest: fetchRequest) { (result, error) in
            handler ( result, error )
        }
    }
    
    func getMedicine(name: String, handler: @escaping (_ result: FetchResult, _ error: NSError?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DB.TABLE.MEDICINE)
        fetchRequest.predicate = NSPredicate(format: "%K LIKE [c] %@", DB.TABLE.MEDICINE_COLUME.NAME, name)
        
        fetch(fetchRequest: fetchRequest) { (result, error) in
            handler ( result, error )
        }
    }
}
