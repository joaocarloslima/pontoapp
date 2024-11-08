//
//  ContentView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 05/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("userId") var userId: String?
    
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
        
        if isSignedIn {
            AppTabBarView()
        } else {
            LoginView()
        }
    }
    
}

struct AppTabBarView: View {
    var body: some View {
        TabView{
            Tab("Registrar", systemImage: "person.fill.checkmark"){
                RegisterView()
            }
            Tab("Dashboard", systemImage: "rectangle.3.offgrid"){
                //
            }
            Tab("Configurações", systemImage: "slider.horizontal.3"){
                SettingsView()
            }
        }
        .tint(Color.gradientStart)
        .toolbarBackground(Color.bg900, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        
    }
}


#Preview {
    ContentView()
}
