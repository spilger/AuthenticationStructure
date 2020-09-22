//
//  AppLoginView.swift
//  AuthenticationStructure
//
//  Created by Cem Yilmaz on 22.09.20.
//

import SwiftUI

struct AppLoginView: View {
    
    @Binding public var restartApp: Bool
    
    @State private var password: String = ""
    @State private var triedBiometricsAuthenticationAndFailed: Bool = false
    
    @ViewBuilder var body: some View {
        
        if self.password == app_password {
            UserLoginView()
        } else {
            if useBiometricsAuthentication && !self.triedBiometricsAuthenticationAndFailed {
                // Das ist nicht wirklich clean
                Text("").onAppear {
                    if biometricsAuthentication() {
                        self.password = app_password
                    } else {
                        self.triedBiometricsAuthenticationAndFailed = true
                    }
                }
            } else {
                ScrollView {
                    VStack (alignment: .leading) {
                        Text("Passwort")
                        SecureField("", text: self.$password).textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Passwort vergessen?") {
                            self.restartApp = false
                            resetApp()
                        }
                    }.padding()
                }
                .navigationBarTitle("App Passwort", displayMode: .large)
                .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
            }
        }
    }
}

struct AppLoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AppLoginView(restartApp: .constant(false))
            }
            NavigationView {
                AppLoginView(restartApp: .constant(false)).environment(\.colorScheme, .dark)
            }
        }
    }
}
