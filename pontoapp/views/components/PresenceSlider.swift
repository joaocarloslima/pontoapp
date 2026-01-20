//
//  PresenceSlider.swift
//  pontoapp
//
//  Created by Erick Costa on 08/12/25.
//

import SwiftUI

struct PresenceSlider: View {
    var profileImage: Image?
    
    var onSwipeRight: () -> Void
    var onSwipeLeft: () -> Void
    
    @State private var userOffset: CGSize = .zero
    private let maxDragOffset: CGFloat = 150
    
    @State private var gradientSlider: Gradient = Gradient(colors: [Color.gradientSuccessStart, Color.gradientSuccessEnd])
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let translation = value.translation.width
                
                if translation >= -maxDragOffset && translation <= maxDragOffset {
                    withAnimation(.interactiveSpring()) {
                        userOffset = value.translation
                    }
                    
                    withAnimation(.easeInOut){
                        if translation < -30 {
                            gradientSlider = Gradient(colors: [Color.gradientJustifyStart, Color.gradientJustifyEnd])
                        } else {
                            gradientSlider = Gradient(colors: [Color.gradientSuccessStart, Color.gradientSuccessEnd])
                        }
                    }
                }
            }
            .onEnded { value in
                let finalOffset = value.translation.width
                
                if finalOffset >= maxDragOffset - 20 {
                    finishDrag(isSuccess: true)
                } else if finalOffset <= -maxDragOffset + 20 {
                    finishDrag(isSuccess: false)
                    gradientSlider = Gradient(colors: [Color.gradientSuccessStart, Color.gradientSuccessEnd])
                } else {
                    withAnimation(.spring()) {
                        userOffset = .zero
                        gradientSlider = Gradient(colors: [Color.gradientSuccessStart, Color.gradientSuccessEnd])
                    }
                }
            }
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(gradientSlider)
                .frame(width: 370, height: 70)
            
            HStack {
                Spacer()
                Image(.apple)
                    .resizable()
                    .frame(width: 70, height: 70)
            }
            .frame(width: 370, height: 70)
            
            HStack {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "doc.text.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
                .frame(width: 70, height: 70)
                
                Spacer()
            }
            .frame(width: 370, height: 70)
            
            Text(userOffset.width < 0 ? "Justificar" : "Presença")
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.7))
                .opacity(abs(userOffset.width) > 50 ? 1 : 0)
                .offset(x: 0)
            
            if let image = profileImage {
                image
                    .resizable()
                    .modifier(ProfileImageStyle(offset: userOffset.width))
                    .gesture(dragGesture)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .modifier(ProfileImageStyle(offset: userOffset.width))
                    .gesture(dragGesture)
            }
        }
    }
    
    func finishDrag(isSuccess: Bool) {
        if isSuccess {
            withAnimation(.spring(duration: 0.5)) {
                userOffset = CGSize(width: maxDragOffset, height: 0)
            }
            onSwipeRight()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation { userOffset = .zero }
            }
        } else {
            onSwipeLeft()
            withAnimation { userOffset = .zero }
        }
    }
}

struct ProfileImageStyle: ViewModifier {
    var offset: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .foregroundStyle(.white)
            .offset(x: offset)
            .zIndex(10)
    }
}


#Preview {
    PresenceSlider(profileImage: Image(systemName: "person.circle.fill"), onSwipeRight: {}, onSwipeLeft: {})
}
