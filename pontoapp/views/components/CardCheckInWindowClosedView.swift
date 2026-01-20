//
//  CardCheckInWindowOpenView.swift
//  pontoapp
//
//  Created by Erick Costa on 20/01/26.
//

import SwiftUI

struct CardCheckInWindowClosedView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "clock.arrow.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gradientEnd)

            VStack(spacing: 5) {
                Text("O ponto não pode ser batido agora")
                    .fontWeight(.semibold)
                    .font(.headline)
                
                Text(getMessageForClosedWindow())
                    .font(.subheadline)
                    .opacity(0.8)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)                .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.bg900)
        )
        .padding(.horizontal, 20)
        .foregroundColor(.white)
    }
    
    func getMessageForClosedWindow() -> String {
        let now = Date.getCurrentMinutes()
        let endMinutes: Int = 18 * 60
        
        if now >= endMinutes {
            return "Volte amanhã às 13:30 para bater o seu ponto!"
        } else {
            return "Volte às 13:30 para bater o seu ponto!"
        }
    }

}

#Preview {
    CardCheckInWindowClosedView()
}
