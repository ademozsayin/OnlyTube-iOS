//
//  LogInWithEmailView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 4.07.2024.
//

import SwiftUI
import FirebaseAuth

struct LogInWithEmailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    enum ViewState: CaseIterable {
        case loading
        case result
        case error
    }
    
    @State private var state: ViewState = .loading
    @State private var errorMessage: String = ""
    
    let url: URL
    
    var body: some View {
        Group {
            switch state {
                case .loading:
                    VStack {
                        LoadingView()
                        Text("Please wait while signin in.")
                    }
                   
                case .result:
                    let link = url.absoluteString
                    Text("You have signed in.")
                case .error:
                    Text("Error signing in with email link: \(errorMessage)")
            }
        }
        .task {
            do {
                let result = Auth.auth().isSignIn(withEmailLink: url.absoluteString)
                state = .result
                print(result)
                if result {
                    try await signInWithEmail(link: url.absoluteString)
                } else {
                    // Handle the case where the link is not valid
                }
            } catch let error {
                state = .error
                errorMessage = error.localizedDescription
                // Handle any errors that occur
                print("Error signing in with email link: \(error)")
            }
        }
    }
    
    func signInWithEmail(link: String) async throws {
        do {
            guard let email = UserDefaults.standard.string(forKey: "email") else {
                throw NSError(domain: "LogInWithEmailView", code: 1, userInfo: [NSLocalizedDescriptionKey: "Email not found in UserDefaults"])
            }
            let result = try await Auth.auth().signIn(withEmail: email, link: link)
            
            print(result)
            dismiss()
        } catch {
            throw error
        }
    }
}
