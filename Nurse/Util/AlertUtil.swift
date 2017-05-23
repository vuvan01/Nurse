//
//  AlertUtil.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class AlertUtil: NSObject {

    func alert(message: String, title: String = "", vc: UIViewController) {
        if vc.presentedViewController == nil{
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: K.ALERT_OK_BUTTON, style: .default, handler: nil)
            alertController.addAction(OKAction)
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}
