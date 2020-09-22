//
//  AuthenticationController.swift
//  AuthenticationStructure
//
//  Created by Cem Yilmaz on 22.09.20.
//

import Foundation
import LocalAuthentication

func appPasswordIsValid (password: String, passwordRepeat: String) -> Bool {
    return (password == passwordRepeat) && password != ""
}

func setAppPassword (password: String) {
    app_password = password
    UserDefaults.standard.setValue(app_password, forKey: "app_password")
}

func resetApp () {
    app_password = nil
    UserDefaults.standard.setValue(nil, forKey: "app_password")
}


// MARK: User Login Functions

let endpoint = "http://invoice-to-insurance.000webhostapp.com/"

func initial_login(email_address: String, password: String) -> (success: Bool, errorMessage: String) {
    var successful_login: Bool = false
    var errorMessage: String = ""
    
    let urlString = endpoint + "APIs/ExampleLogin.php"
    guard let url = URL(string: urlString) else {
        errorMessage = "Internal Server Error"
        return (successful_login, errorMessage)
    }
    var request = URLRequest(url: url)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"

    let query_string = "email_address=\(email_address)&password=\(password)".replacingOccurrences(of: " ", with: "%20")
    request.httpBody = query_string.data(using: .utf8)

    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in

        if let _ = error {
            print(error as Any)
        } else {
            if let response_content = String(data: data!, encoding: .utf8) {
                
                switch response_content {
                case "0":
                    errorMessage = "Internal Server Error"
                case "1":
                    errorMessage = "Anmeldung fehlgeschlagen"
                default:
                    if let data = try? JSONDecoder().decode(User.self, from: data!) {
                        loggedInUser = data
                        storeLoggedInUser()
                        successful_login = true
                    } else {
                        errorMessage = "Internal Server Error"
                    }
                }
                
            } else {
                print("Nicht decodoerbare Antwort")
            }
        }
        
        semaphore.signal()
        
    }.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return (successful_login, "")
}

struct User: Codable {
    let userID: String
    let emailAddress: String
    let authenticationToken: String
}


func update_login () -> Bool {
    var successful_login = false
    return true
    
    let urlString = endpoint + "APIs/"
    guard let url = URL(string: urlString) else { return false }
    var request = URLRequest(url: url)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
  
    let query_string = "user_id=\(loggedInUser.userID)&authentication_token=\(loggedInUser.authenticationToken)".replacingOccurrences(of: " ", with: "%20")
    request.httpBody = query_string.data(using: .utf8)

    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in

        if let _ = error {
            print(error as Any)
        } else {
            if let response_content = String(data: data!, encoding: .utf8) {
                
                switch response_content {
                case "0":
                    print("Internal Server Error")
                case "1":
                    print("Anmeldung fehlgeschlagen")
                default:
                    if let data = try? JSONDecoder().decode(User.self, from: data!) {
                        loggedInUser = data
                        storeLoggedInUser()
                        successful_login = true
                    }
                }
            }
        }
        
        semaphore.signal()
        
    }.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    
//    store_logged_in_customer()
    
    return successful_login
}













// MARK: Biometrics Authentication

func biometricsAuthenticationEnabledOrRequestable () -> Bool {
    return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
}

func biometricsAuthentication () -> Bool {
    var successfulAuthenticated = false
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let localAuthenticationContext = LAContext()
    if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Wird benötigt um Ihr Gerät ohne App Passwort entsperren zu können") { (success, _) in
            if success {
                successfulAuthenticated = true
            }
            semaphore.signal()
        }
    }
    
    _ = semaphore.wait(timeout: .distantFuture)
    
    return successfulAuthenticated
}

func changeUseBiometricsAuthentication (to: Bool) -> Bool {
    if to {
        let myTry = biometricsAuthentication()
        if myTry {
            UserDefaults.standard.setValue(true, forKey: "useBiometricsAuthentication")
        } else {
            return false
        }
    } else {
        UserDefaults.standard.setValue(false, forKey: "useBiometricsAuthentication")
    }
    
    return true
}
