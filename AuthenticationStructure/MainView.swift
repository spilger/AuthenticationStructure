//
//  MainView.swift
//  AuthenticationStructure
//
//  Created by Cem Yilmaz on 22.09.20.
//

import SwiftUI

struct MainView: View {
    
    @Binding public var userIsLoggedIn: Bool
    
    var body: some View {
        VStack {
            Text(loggedInUser.emailAddress)
            
            Button("Abmelden") {
                self.userIsLoggedIn = false
                logUserOut()
            }
        }
    }
}
