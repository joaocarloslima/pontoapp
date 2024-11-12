//
//  RegisterSuccessView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 06/11/24.
//

import SwiftUI

struct RegisterSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var scaleEffect: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .opacity(opacity)
                    .scaleEffect(scaleEffect)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0)) {
                                scaleEffect = 1.0
                                opacity = 0.7
                            }
                        }
                    }
                
                
                Text("Presença registrada com sucesso")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("OK")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                        .frame(width: geometry.size.width - 80)
                        .background(.black.opacity(0.7))
                        .cornerRadius(10)
                }
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gradientSuccessStart)
        }
    }
}

#Preview {
    RegisterSuccessView()
}
