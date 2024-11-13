//
//  RegisterView.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 05/11/24.
//

import SwiftUI

struct RegisterView: View {
    
    @AppStorage("userId") var userId: String?
    
    @State private var userOffset: CGSize = .zero
    @State private var showSuccessView = false
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var profileController = ProfileController()
    @StateObject var web = WebService()
    
    private var profileImage: Image? {
        if let profileImage = profileController.profileImage {
            return profileImage
        } else {
            return Image(systemName: "person.circle.fill")
        }
    }
          
    private let maxDragOffset: CGFloat = 250
     
    var body: some View {
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
                
                Text(userOffset.height < 0 ?
                        "Registrar Presença" :
                        "Justificar Ausência"
                    )
                    .fontWeight(.semibold)
                    .foregroundColor(userOffset.height < 0 ?
                                     Color.gradientSuccessStart: .red).opacity(0.7)
                    .font(.system(size: 30))
                    .opacity( userOffset.height < 30 ?
                              userOffset.height / -maxDragOffset : 1
                    )
                
                
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
                        height: 300
                    )
                    .animation(.spring(), value: userOffset)
                
                profileImage?
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .foregroundStyle(.white)
                    .padding(.top, -110)
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
                                        LocalAuthService().authorizeUser { authenticated in
                                            if authenticated {
                                                handleRegister()
                                                showSuccessView = true
                                            }
                                        }
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
        .fullScreenCover(isPresented: $showSuccessView) {
            RegisterSuccessView()
        }
            
    }
    
    func handleRegister() {
        print("Registrando presença")
        if let location = locationManager.userLocation {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            web.postRecord(
                    latitude: latitude,
                    longitude: longitude,
                    userId: userId!
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            print("Presença registrada com sucesso!")
                            showSuccessView = true
                        case .failure(let error):
                            print("Erro ao registrar presença: \(error.localizedDescription)")
                        }
                    }
            }
        }
    }

}



#Preview {
    RegisterView()
}
