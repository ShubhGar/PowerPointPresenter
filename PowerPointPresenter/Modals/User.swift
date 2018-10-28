//
//  User.swift
//  PowerPointPresenter
//
//  Created by Shubham Garg on 26/10/18.
//  Copyright © 2018 Shubham Garg. All rights reserved.
//
import Foundation
import Firebase

struct User {
  
    // MARK: Properties
  let uid: String
  let email: String
  
    // MARK: Constructors
  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email!
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
