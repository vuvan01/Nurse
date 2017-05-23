//
//  BaseManager.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CoreData


class BaseDBManager: NSObject {
    
    func save(handler: (_ status: SaveStatus, _ error: NSError?) -> Void){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        do {
            try managedContext?.save()
            handler(SaveStatus.success, nil)
        } catch let error as NSError {
            handler(SaveStatus.failure, error)
        }
    }
    
    
    func fetch(fetchRequest: NSFetchRequest<NSFetchRequestResult>, handler: (_ result: FetchResult, _ error: NSError?) -> Void){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        
        do {
            let fetchedData = try managedContext?.fetch(fetchRequest)
            let result = FetchResult(FetchStatus.success, fetchedData)
            handler( result, nil )
        } catch let error as NSError{
            let result = FetchResult(FetchStatus.failure, nil)
            handler( result, error )
        }
    }
    
    func add(email: String, password: NSData, handler: @escaping (_ status: SaveStatus, _ error: NSError?) -> Void){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: DB.TABLE.USER, in: managedContext!)!
        let nurse = NSManagedObject(entity: entity, insertInto: managedContext) as! User
        nurse.email = email
        nurse.password = password
        
        save { (status, error) in
            handler(status, error)
        }
    }
    
}
