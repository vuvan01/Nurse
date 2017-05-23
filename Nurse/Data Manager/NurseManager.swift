//
//  NurseManager.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CoreData

class NurseManager: BaseDBManager {

    func getLoggedInUser() -> User?{
        return (UIApplication.shared.delegate as? AppDelegate)?.loggedInUser
    }
    
    func setLoggedInUser(user: User){
        (UIApplication.shared.delegate as? AppDelegate)?.loggedInUser = user
    }
    
    func addUser(email: String, password: NSData, handler: @escaping (_ status: SaveStatus, _ error: NSError?) -> Void){
        let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: DB.TABLE.USER, in: managedContext!)!
        let nurse = NSManagedObject(entity: entity, insertInto: managedContext) as! User
        nurse.email = email
        nurse.password = password
        
        save { (status, error) in
            handler(status, error)
        }
    }
    
    func getUser(email: String, handler: @escaping (_ result: FetchResult, _ error: NSError?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DB.TABLE.USER)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", DB.TABLE.USER_COLUME.EMAIL, email)
        
        fetch(fetchRequest: fetchRequest) { (result, error) in
            handler ( result, error )
        }
    }
    
}
