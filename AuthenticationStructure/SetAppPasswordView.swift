//
//  SetAppPasswordView.swift
//  AuthenticationStructure
//
//  Created by Cem Yilmaz on 22.09.20.
//

import SwiftUI

struct SetAppPasswordView: View {
    
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    @State private var useBiometricsAuthenticationToggle: Bool = useBiometricsAuthentication
    
    @State private var didSetPassword: Bool = false
    
    @ViewBuilder var body: some View {
        
        let useBiometricsAuthenticationToggleWithOnChange = Binding<Bool>(
            get: {
                self.useBiometricsAuthenticationToggle
            }, set: {
                self.useBiometricsAuthenticationToggle = $0
                if !changeUseBiometricsAuthentication(to: $0) {
                    self.useBiometricsAuthenticationToggle = false
                }
            }
        )
        
        if self.didSetPassword {
            UserLoginView()
        } else {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Passwort")
                    SecureField("", text: self.$password).textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("Passwort wiedeholen")
                    SecureField("", text: self.$passwordRepeat).textFieldStyle(RoundedBorderTextFieldStyle())

                    if biometricsAuthenticationEnabledOrRequestable() {
                        Toggle(getBiometricsAuthenticationMethod(), isOn: useBiometricsAuthenticationToggleWithOnChange)
                    }

                    Button(!appPasswordIsValid(password: self.password, passwordRepeat: self.passwordRepeat) ? "Ungültige Eingabe" : "Passwort festlegen") {
                        setAppPassword(password: self.password)
                        self.didSetPassword = true
                    }.disabled(!appPasswordIsValid(password: self.password, passwordRepeat: self.passwordRepeat))

                }.padding()
            }
            .navigationBarTitle("App Passwort", displayMode: .large)
            .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
        }
    }
}

struct SetAppPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SetAppPasswordView()
            }
            NavigationView {
                SetAppPasswordView().environment(\.colorScheme, .dark)
            }
        }
    }
}
