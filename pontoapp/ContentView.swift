//
//  ContentView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 05/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("userId") var userId: String?
    @ObservedObject var locationManager = LocationManager.shared
    
    private var isSignedIn: Bool {
        return userId != nil
    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.bg900)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        Group {
            if isSignedIn {
                AppTabBarView()
            } else if locationManager.userLocation == nil {
                LocationRequestView()
            } else {
                LoginView()
            }
        }
    }
    
}

struct AppTabBarView: View {
    var body: some View {
        TabView {
            NavigationStack{
                RegisterView()
                    .tabItem {
                        Image(systemName: "person.fill.checkmark")
                        Text("Registrar")
                    }
            }
            
            DashboardView()
                .tabItem {
                    Image(systemName: "rectangle.3.offgrid")
                    Text("Dashboard")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Configurações")
                }
        }
        
        .accentColor(Color.gradientStart)
    }
}


#Preview {
    ContentView()
}
