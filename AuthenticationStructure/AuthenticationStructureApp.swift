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

func pre_start_setup() {
    if let data = UserDefaults.standard.string(forKey: "app_password") {
        app_password = data
    }
}
