//
//  AuthenticationManager.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 2.07.2024.
//

import Combine
import Env
import Models
import Network
import Observation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import KeychainSwift

import Combine
import Foundation
import Observation
import os
import OSLog
import SwiftUI

extension User: @unchecked  Sendable {}

@MainActor
@Observable public class AuthenticationManager {
    
    public static var shared = AuthenticationManager()
    
    @AppStorage("latestCurrentAccountKey", store: UserPreferences.sharedDefault)
    public static var latestCurrentAccountKey: String = ""
  
    public var isAuth: Bool {
        currentAccount?.uid != nil
    }
    
    public var currentAccount: User? {
        didSet {
            Self.latestCurrentAccountKey = currentAccount?.uid ?? ""
        }
    }
    
    var loginLink:String? 
    
    init() {
        Task {
            Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                guard let self else { return }
                currentAccount = user ?? nil
                PushNotificationsService.shared.setUser(user:AuthenticationManager.shared.currentAccount)
                print(user?.email)
            }
        }
    }
    
    func requestAuthenticationLink(for email: String) async throws {
        
        do {
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://onlyjose.page.link/login-with-email")
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            
            try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
            UserDefaults.standard.set(email, forKey: "email")
        }
        catch {
            throw error
        }
        
    }
    
    final func createUser(withEmail: String, password: String) async throws {
        
        do {
            try await Auth.auth().createUser(withEmail: withEmail, password: password)
        } catch let error {
            throw error
        }
    }
    
    func signOut() async throws  {
        do {
            try Auth.auth().signOut()
            self.currentAccount = nil
            print("signed out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func fetchAccount() async -> User? {
        guard let currentAccount else { return nil }
        return currentAccount
    }
    
}
