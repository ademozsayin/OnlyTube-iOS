//
//  RegisterViewModel.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 5.07.2024.
//

import Foundation
import Observation
import Firebase
import FirebaseAuth

@MainActor
@Observable final class RegisterViewModel {
    
    var shouldShowErrorAlert:Bool = false
    var displayName:String = ""
    var email: String = ""
    var password: String = ""
    var rePassword: String = ""
    var showPassword: Bool = false
    var showRePassword: Bool = false
    var isRegistering: Bool = false
    private(set) var errorMessage = ""
    
    var primaryButtonDisabled: Bool {
        return email.isEmpty || password.isEmpty || rePassword.isEmpty
    }
    
    private let manager = AuthenticationManager.shared
    
    @MainActor
    final func register() async {
        isRegistering = true
        errorMessage = ""
        if password != rePassword {
            errorMessage = "Passwords do not match"
            shouldShowErrorAlert = true
        } else {
            do {
                try await manager.createUser(withEmail: email, password: password)
                isRegistering = false
                shouldShowErrorAlert = false
                
                if !displayName.isEmpty {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = displayName
                    changeRequest?.commitChanges { error in
                       print(error)
                    }
                }
              
                
            } catch let err {
                errorMessage = err.localizedDescription
                shouldShowErrorAlert = true
                isRegistering = false
            }
        }
    }
}
