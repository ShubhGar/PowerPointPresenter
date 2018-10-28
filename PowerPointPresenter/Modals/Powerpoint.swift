//
//  Powerpoint.swift
//  PowerPointPresenter
//
//  Created by Shubham Garg on 26/10/18.
//  Copyright © 2018 Shubham Garg. All rights reserved.
//

import Foundation
import Firebase

struct Powerpoint {
    
    // MARK: Properties
    let ref: DatabaseReference?
    let key: String
    let name: String
    let addedByUser: String
    let path: String?
    let isDownloaded:Bool
    
    // MARK: Constructors
    init(name: String, addedByUser: String,isDownloaded:Bool, key: String = "",path: String?) {
        self.ref = nil
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.path = path
        self.isDownloaded = isDownloaded
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let isDownloaded = value["isDownloaded"] as? Bool,
            let path = value["path"] as? String? else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.path = path
        self.addedByUser = addedByUser
        self.isDownloaded = isDownloaded
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "path": path ?? "",
            "isDownloaded" : isDownloaded
        ]
    }
}


