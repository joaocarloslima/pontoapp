//
//  RegisterView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 05/11/24.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var userOffset: CGSize = .zero
    @State private var showSuccessView = false
    
    private let maxDragOffset: CGFloat = 250
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 20){
                    Text("Apple Academy")
                        .fontWeight(.semibold)
                        .foregroundColor(.white).opacity(0.9)
                        .font(.system(size: 40))
                    
                    Text("SENAC")
                        .fontWeight(.semibold)
                        .foregroundColor(.white).opacity(0.7)
                        .font(.system(size: 30))
                    
                    Spacer()
                    
                    Image(.apple)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.bottom, -100)
                        .zIndex(10)
                    
                    RoundedRectangle(cornerRadius: 50)
                        .fill(Gradient(colors: [Color.gradientSuccessEnd, Color.gradientSuccessStart]))
                        .frame(
                            width: 100,
                            height: (userOffset.height>0) ? 300 + userOffset.height : 300
                        )
                        .animation(.spring(), value: userOffset)
                    
                    Image(.user)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.top, -100)
                        .offset(y: userOffset.height)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = value.translation.height
                                    if newOffset >= -maxDragOffset{
                                        withAnimation(.spring()) {
                                            userOffset = value.translation
                                        }
                                    }
                                }
                                .onEnded { value in
                                    let newOffset = value.translation.height * -1
                                    if (newOffset <= maxDragOffset - 50){
                                        withAnimation(.spring()) {
                                            userOffset = .zero
                                        }
                                    }else{
                                        withAnimation(.spring(duration: 1)) {
                                            userOffset = CGSize(width: 0, height: -240)
                                            showSuccessView = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            userOffset = .zero
                                        }
                                    }
                                }
                        )
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bg950)
                
               
            }
            
        }
        .fullScreenCover(isPresented: $showSuccessView) {
            RegisterSuccessView()
        }
            
    }

        
    
}

#Preview {
    RegisterView()
}
