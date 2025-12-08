//
//  DashboardView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 30/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var web = WebService()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bg950.ignoresSafeArea()
                
                
                VStack {
                    if web.isLoading {
                        ProgressView()
                    } else {
                        AttendanceChart()
                            .padding()
                        
                        Text("Próximos Eventos")
                            .font(.title2)
                            .bold()
                        
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(web.events) { event in
                                    EventCard(event: event)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .onAppear {
                loadEvents()
            }
            .refreshable {
                loadEvents()
            }
        }
    }
    
    func loadEvents() {
        web.fetchEvents { _ in }
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: event.fields.icon ?? "calendar.fill")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.fields.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(event.fields.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    DashboardView()
}
