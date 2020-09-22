//
//  ContentView.swift
//  AuthenticationStructure
//
//  Created by Spilger, Michael on 22.09.20.
//

import SwiftUI

struct EntryView: View {
    
    @State private var animationComplete: Bool = false
    
    @ViewBuilder var body: some View {
        
        if self.animationComplete {
            NavigationView {
                if app_password == nil {
                    SetAppPasswordView()
                } else {
                    AppLoginView(restartApp: self.$animationComplete)
                }
            }
        } else {
            Text("Animation").onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.animationComplete = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
