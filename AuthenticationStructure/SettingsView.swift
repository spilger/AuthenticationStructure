//
//  SettingsView.swift
//  AuthenticationStructure
//
//  Created by Cem Yilmaz on 22.09.20.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding public var userIsLoggedIn: Bool
    @Environment(\.presentationMode) private var presentationMode
    @State private var useBiometricsAuthenticationToggle: Bool = useBiometricsAuthentication
    @State private var alertForToSettings: Bool = false
    @State private var actionSheetForUserLogout: Bool = false
    @State private var sheetForAppPasswordChange: Bool = false
    
    var body: some View {
        
        var useBiometricsAuthenticationToggleWithOnChange = Binding<Bool>(
            get: {
                self.useBiometricsAuthenticationToggle
            }, set: {
                self.useBiometricsAuthenticationToggle = $0
                if !changeUseBiometricsAuthentication(to: $0) {
                    self.useBiometricsAuthenticationToggle = false
                }
            }
        )
        
        List {
            Section {
                Button(
                    action: {
                        self.alertForToSettings = true
                    },
                    label: {
                        HStack {
                            Text("Zu Systemeinstellungen").foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "gear")
                        }
                    }
                )
            }
            
            Section {
                Toggle(isOn: useBiometricsAuthenticationToggleWithOnChange) {
                    Text("Face ID").foregroundColor(biometricsAuthenticationEnabledOrRequestable() ? .primary : .gray)
                }.disabled(!biometricsAuthenticationEnabledOrRequestable())
            }
            
            Section {
                Button(
                    action: {
                        self.sheetForAppPasswordChange = true
                    },
                    label: {
                        HStack {
                            Text("App Passwort ändern").foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "lock")
                        }
                    }
                )
            }
            
            Section {
                Button(
                    action: {
                        self.actionSheetForUserLogout = true
                    },
                    label: {
                        HStack {
                            Spacer()
                            Text("Abmelden").foregroundColor(.red)
                            Spacer()
                        }
                    }
                )
            }
        }
        .listStyle(GroupedListStyle())
        .alert(isPresented: self.$alertForToSettings) {
            Alert(
                title: Text("Sytemeinstellungen"),
                message: Text("Bei dem Wechsel zu den Systemeinstellungen verlassen Sie diese App"),
                primaryButton: Alert.Button.cancel(Text("Abbrechen")),
                secondaryButton: Alert.Button.default(Text("Einstellungen")) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            )
        }
        .actionSheet(isPresented: self.$actionSheetForUserLogout) {
            ActionSheet(
                title: Text("Abmeldung von Ihrem Benutzerkonto"),
                message: Text("Dabei werden alle Benutzerkontobezogenen Daten gelöscht. Die App-spezifischen Daten wie App-Passwort, und ob die Verwendung von Face ID bevorzugt ist bleibt erhalten"),
                buttons: [
                    ActionSheet.Button.destructive(Text("Abmelden")) {
                        self.userIsLoggedIn = false
                        logUserOut()
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    ActionSheet.Button.cancel(Text("Abbrechen"))
                
                ]
            )
        }
        .sheet(isPresented: self.$sheetForAppPasswordChange) {
            UpdateAppPasswortView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userIsLoggedIn: .constant(true))
    }
}
