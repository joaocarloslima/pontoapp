//
//  SettingsViews.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 07/11/24.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("userId") var userId: String?
    
    var body: some View {
        ZStack {
            Color.bg950
                .ignoresSafeArea()
            
            VStack{
                Text("Configurações")
                    .fontWeight(.semibold)
                    .foregroundColor(.white).opacity(0.9)
                    .font(.system(size: 40))
                
                Button(action: {
                    self.userId = nil
                }) {
                    Text("Sair")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                        .frame(width: 200)
                        .background(Color.red.opacity(0.5))
                        .cornerRadius(10)
                }
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}
