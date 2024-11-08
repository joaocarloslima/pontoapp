//
//  LoginView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 07/11/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack{
            Text("Apple Academy")
                .fontWeight(.semibold)
                .foregroundColor(.white).opacity(0.9)
                .font(.system(size: 40))
            
            Text("SENAC")
                .fontWeight(.semibold)
                .foregroundColor(.white).opacity(0.7)
                .font(.system(size: 30))
            
            Spacer()
            
            Text("Faça login para ter acesso aos recursos do app do Apple Developer Academy do Centro Universitário SENAC")
                .fontWeight(.semibold)
                .foregroundColor(.white).opacity(0.7)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            SignButtonView()
        }
        .background(Color.bg950)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SignButtonView: View {
    @AppStorage("userId") var userId: String?
    @AppStorage("email") var email: String?
    @AppStorage("name") var name: String?
    
    var body: some View {
        
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let credential as ASAuthorizationAppleIDCredential:
                        let userId = credential.user
                        let email = credential.email
                        let name = credential.fullName?.givenName
                        
                        self.userId = userId
                        self.email = email ?? ""
                        self.name = name ?? ""
                        
                        print("User ID: \(userId)")
                        print("Email: \(email ?? "")")
                        print("Name: \(name ?? "")")
                        
                    default:
                        break
                    }
                    
                    
                case .failure(let error):
                    print("Authorization failed: " + error.localizedDescription)
            }
            
                
        }
        .signInWithAppleButtonStyle(.white)
        .frame(height: 50)
        .padding()
        

            
        
    }
        
}

#Preview {
    LoginView()
}
