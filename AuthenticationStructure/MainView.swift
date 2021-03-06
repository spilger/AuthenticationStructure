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
            Text("Nutzer mit E-Mail Adresse")
            Text(loggedInUser.emailAddress)
            Text("ist angemeldet")
        }
        .navigationBarTitle("Startseite", displayMode: .inline)
        .navigationBarItems(
            leading: EmptyView(),
            trailing:
                NavigationLink(
                    destination: SettingsView(userIsLoggedIn: self.$userIsLoggedIn),
                    label: {Image(systemName: "ellipsis.circle")}
                )
        )
    }
}
