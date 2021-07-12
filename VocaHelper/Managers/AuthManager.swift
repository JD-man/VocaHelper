//
//  AuthManager.swift
//  VocaHelper
//
//  Created by JD_MacMini on 2021/07/10.
//

import Foundation
import FirebaseAuth
//import FirebaseAnalytics

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
    
    public func checkUserVeryfied() -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
        if currentUser.isEmailVerified {
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
    
    public func sendVerificationEmail(completion: @escaping ((Bool) -> Void)) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if let error = error {
                print(error)
                completion(false)
            }
            else {
                completion(true)
            }
        })
    }
    
    public func deleteCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        currentUser.delete { error in
            if let _ = error {
                print("current user delete fail")
            }
            else {
                print("current user delete")
            }
        }
    }
    
    public func userReload(completion: @escaping ((Bool) -> Void)) {
        Auth.auth().currentUser?.reload(completion: { error in
            if let error = error {
                print(error)
                completion(false)
            }
            else {
                completion(true)
            }
        })
    }
}
