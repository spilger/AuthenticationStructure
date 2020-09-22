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
    
    @ViewBuilder var body: some View {
        
        if self.password == app_password {
            UserLoginView()
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
            .navigationBarTitle("App Anmeldung", displayMode: .large)
            .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
        }
    }
}

//struct AppLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AppLoginView()
//        }
//    }
//}
