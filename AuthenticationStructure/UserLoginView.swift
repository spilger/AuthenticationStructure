//
//  UserLoginView.swift
//  AuthenticationStructure
//
//  Created by Cem Yilmaz on 22.09.20.
//

import SwiftUI

struct UserLoginView: View {
    
    @State private var loginSuccessful: Bool = false
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    @State private var rememberLoginInformation: Bool = false
    @State private var triedAutoLoginAndFailed: Bool = false
    
    @ViewBuilder var body: some View {
        if self.loginSuccessful {
            MainView(userIsLoggedIn: self.$loginSuccessful)
        } else if self.triedAutoLoginAndFailed || UserDefaults.standard.value(forKey: "loggedInUser") == nil {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("E-Mail Adresse")
                    TextField("", text: self.$emailAddress).textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("Passwort")
                    SecureField("", text: self.$password).textFieldStyle(RoundedBorderTextFieldStyle())

                    Toggle("Anmeldedaten merken?", isOn: self.$rememberLoginInformation)

                    Button("Anmelden") {
                        rememberUserLoginInformation = self.rememberLoginInformation

                        let loginResponse = initial_login(email_address: self.emailAddress, password: self.password)

                        if loginResponse.success {
                            self.emailAddress = ""
                            self.password = ""
                            self.loginSuccessful = true
                        } else {
                            print(loginResponse.errorMessage)
                        }
                    }.disabled(self.emailAddress == "" || password == "")
                }.padding()
            }
            .navigationBarTitle("Benutzer Anmeldung", displayMode: .large)
            .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
        } else {
            ActivityIndicatorView(isAnimating: true).onAppear {
                if update_login() {
                    self.loginSuccessful = true
                } else {
                    self.triedAutoLoginAndFailed = true
                    self.emailAddress = loggedInUser.emailAddress
                    self.rememberLoginInformation = rememberUserLoginInformation
                }
            }
        }
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserLoginView()
        }
    }
}
