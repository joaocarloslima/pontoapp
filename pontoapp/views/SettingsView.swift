//
//  SettingsViews.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 07/11/24.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @AppStorage("name") var name: String?
    @AppStorage("userId") var userId: String?
    @StateObject var profileController = ProfileController()

    var body: some View {
                
            VStack{
                VStack{
                    PhotosPicker(selection: $profileController.selectedImage){
                        if let profileImage = $profileController.profileImage.wrappedValue {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.gray)
                        }
                    }
                        
                    
                    Text(name ?? "Usuário Logado")
                        .font(.system(size: 30))
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                List{
                    Section{
                        Button("Sair do App") {
                            userId = nil
                        }
                        .foregroundColor(.red)
                        .padding(8)
                    }
                }
                
            }
            .preferredColorScheme(.dark)
        
    }
}

#Preview {
    SettingsView()
}
