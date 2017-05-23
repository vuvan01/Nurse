//
//  EncryptionUtil.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit
import CryptoSwift

class EncryptionUtil: NSObject {
    
    enum EncryptionStatus : Int {
        case success
        case failure
    }
    
    struct EncryptionResult{
        var status: EncryptionStatus
        var data: Any?
        
        init(_ encryptionStatus: EncryptionStatus, _ data: Any?) {
            self.status = encryptionStatus
            self.data = data
        }
    }

    func encryptPassword(password: String, handler: (_ result: EncryptionResult, _ error: NSError?) -> Void){
        do {
            let aes = try AES(key: K.ENCRYPTION_KEY , iv: K.ENCRYPTION_IV)
            let encrypted = try aes.encrypt(password.utf8.map({$0}))
            let data = NSData(bytes: encrypted, length: encrypted.count)
            
            let result = EncryptionResult(EncryptionStatus.success, data)
            handler(result, nil)
        } catch let error as NSError {
            let result = EncryptionResult(EncryptionStatus.failure, nil)
            handler(result, error)
        }
    }
    
    func decryptPassword(data: Data, handler: (_ result: EncryptionResult, _ error: NSError?) -> Void){
        do {
            let encrypted = [UInt8](data)
            
            let aes = try AES(key: K.ENCRYPTION_KEY , iv: K.ENCRYPTION_IV)
            let decrypted: Array<UInt8> = try aes.decrypt(encrypted)
            let password = String(bytes: decrypted, encoding: String.Encoding.utf8)
            
            let result = EncryptionResult(EncryptionStatus.success, password)
            handler(result, nil)
        } catch let error as NSError {
            let result = EncryptionResult(EncryptionStatus.failure, nil)
            handler(result, error)
        }
    }

}
