//
//  UpdateAppPasswortView.swift
//  AuthenticationStructure
//
//  Created by Cem Yilmaz on 22.09.20.
//

import SwiftUI

struct UpdateAppPasswortView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var oldPassword: String = ""
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    
    @ViewBuilder var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Altes Passwort angeben")
                    SecureField("", text: self.$oldPassword).textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(self.oldPassword == app_password)
                    
                    if self.oldPassword == app_password {
                        Text("Neues Passwort")
                        SecureField("", text: self.$password).textFieldStyle(RoundedBorderTextFieldStyle())

                        Text("Neues Passwort wiedeholen")
                        SecureField("", text: self.$passwordRepeat).textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("Neues Passwort setzen") {
                            setAppPassword(password: self.password)
                            self.presentationMode.wrappedValue.dismiss()
                        }.disabled(!appPasswordIsValid(password: self.password, passwordRepeat: self.passwordRepeat))
                    }

                }.padding()
            }
            .navigationBarTitle("App Passwort", displayMode: .large)
            .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
        }
    }
}

struct UpdateAppPasswortView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAppPasswortView()
    }
}
