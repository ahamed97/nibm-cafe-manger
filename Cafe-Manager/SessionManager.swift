//
//  StoreViewController.swift
//  Cafe-Manager
//
//  Created by dev on 5/3/21.
//  Copyright © 2021 dev. All rights reserved.
//

import Foundation

class SessionManager {
    
    func getLoggedState() ->Bool {
        return UserDefaults.standard.bool(forKey: "LOGGED_IN")
    
    }
    
    func saveUserLogin(user: User) {
        UserDefaults.standard.setValue(true, forKey: "LOGGED_IN")
        UserDefaults.standard.setValue(user.userEmail, forKey: "USER_EMAIL")
        UserDefaults.standard.setValue(user.userPhone, forKey: "USER_PHONE")
    }
    
    func getUserData() -> User {
        let user = User(
            userEmail: UserDefaults.standard.string(forKey: "USER_EMAIL") ?? "",
            userPassword: "",
            userPhone: UserDefaults.standard.string(forKey: "USER_PHONE") ?? "")
        
        return user
        
    }
    
    func clearUserLoggedState() {
          UserDefaults.standard.setValue(false, forKey: "LOGGED_IN")
      }
}

