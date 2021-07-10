//
//  AuthManager.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/10.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    public func createNewUser(email: String, password: String, completion: @escaping ((Bool) -> Void) ) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error)
                completion(false)
            }
            else {
                completion(true)
            }
        }
    }
    
    public func checkUserLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        else {
            return false
        }
    }
    
    public func loginUser(email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error)
                completion(false)
            }
            else {
                completion(true)
            }
        }
    }
    
    public func logoutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
