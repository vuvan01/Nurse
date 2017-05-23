//
//  SaveDBContextStatus.swift
//  Nurse
//
//  Created by An on 12/5/16.
//  Copyright © 2016 An. All rights reserved.
//

enum SaveStatus : Int {
    case success
    case failure
}

enum FetchStatus : Int {
    case success
    case failure
}

struct FetchResult {
    var status: FetchStatus
    var data: Any?
    
    init(_ fetchStatus: FetchStatus, _ data: Any?) {
        self.status = fetchStatus
        self.data = data
    }
}
