//
//  AuthenticationStructureApp.swift
//  AuthenticationStructure
//
//  Created by Spilger, Michael on 22.09.20.
//

import SwiftUI

@main struct AuthenticationStructureApp: App {
    
    init() {
        pre_start_setup()
    }
    
    var body: some Scene {
        WindowGroup {
            EntryView()
        }
    }
}



// MARK: Verwaltung der globalen Variablen

var app_password: String!
var loggedInUser: User!
var rememberUserLoginInformation: Bool = false

func pre_start_setup() {
    if let data = UserDefaults.standard.string(forKey: "app_password") {
        app_password = data
    }
    
    if let data = UserDefaults.standard.value(forKey: "loggedInUser") as? Data {
        let decoder = JSONDecoder()
        if let stored_customer_account = try? decoder.decode(User.self, from: data) {
            loggedInUser = stored_customer_account
            rememberUserLoginInformation = true
        }
    }
}

func storeLoggedInUser () {
    if rememberUserLoginInformation {
        UserDefaults.standard.setValue(try? JSONEncoder().encode(loggedInUser), forKey: "loggedInUser")
    }
}

func logUserOut () {
    UserDefaults.standard.setValue(nil, forKey: "loggedInUser")
}
