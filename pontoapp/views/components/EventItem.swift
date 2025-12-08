//
//  EventItem.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 30/10/25.
//

import SwiftUI

struct EventItem: View {
    let title: String
    let date: String
    let image: Image
    
    var body: some View {
        HStack{
            Rectangle()
                .foregroundStyle(.blue)
                .frame(width: 10)
            
            VStack(alignment: .leading){
                Text(title)
                    .font(.title2)
                    .bold()
                Text(date)
            }
            
            Spacer()
            
            image
            
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    EventItem(title: "Apresentação", date: "12/12/2025", image: Image(systemName: "balloon.fill"))
}

