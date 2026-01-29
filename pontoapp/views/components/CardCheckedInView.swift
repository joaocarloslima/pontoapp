//
//  CardCheckedInView.swift
//  pontoapp
//
//  Created by Erick Costa on 28/01/26.
//

import SwiftUI

struct CardCheckedInView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.green)

            VStack(spacing: 5) {
                Text("Seu ponto foi registrado com sucesso!")
                    .fontWeight(.semibold)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(getMessageForClosedWindow())
                    .font(.subheadline)
                    .opacity(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.bg900)
        )
        .padding(.horizontal, 20)
        .foregroundColor(.white)
    }
    
    func getMessageForClosedWindow() -> String {
        let now = Date.getCurrentMinutes()
        let startMinutes: Int = 13 * 60 + 30
        
        if now < startMinutes {
            return "Volte às 13:30 para bater o seu ponto!"
        }
        
        return "Volte amanhã às 13:30 para bater o seu ponto novamente!"
    }
}

#Preview {
    CardCheckedInView()
}
