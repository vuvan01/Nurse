//
//  BaseViewController.swift
//  Nurse
//
//  Created by An on 12/6/16.
//  Copyright © 2016 An. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func dbMan() -> DBManager{
        return DBManager.shared
    }
}

