import SwiftUI

struct RegisterView: View {
    
    @AppStorage("studentId") private var studentId: String = ""
    
    @State private var userOffset: CGSize = .zero
    @State private var justifyAbstence: Bool = false
    @State private var showSuccessView = false
    @State private var showSettings = false
    
    @State private var showError = false
    @State private var errorMessage: String?
    
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
        if studentId.isEmpty {
            noStudentIdView
        } else {
            ZStack {
                VStack(spacing: 20){
                    registerCommand
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bg950)
            }
            
            
            .navigationDestination(isPresented: $justifyAbstence){
                JustifyAbstenceView()
            }
            .fullScreenCover(isPresented: $showSuccessView) {
                RegisterSuccessView()
            }
            .alert("Erro", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Ocorreu um erro inesperado")
            }
        }
    }
    
    var registerCommand: some View {
        VStack{
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
                            print(newOffset)
                            
                            if (newOffset <= maxDragOffset - 50){
                                
                                justifyAbstence = true
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
        
    }
    
    
    var noStudentIdView: some View {
        VStack(spacing: 30) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)
            
            Text("Student ID não configurado")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Por favor, configure seu Student ID nas configurações para registrar presença.")
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
                .padding(.horizontal, 40)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bg950)
        .sheet(isPresented: $showSettings) {
            SettingsView()
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
                studentId: studentId
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Presença registrada com sucesso!")
                        showSuccessView = true
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        showError.toggle()
                        print("Erro ao registrar presença: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}

#Preview {
    RegisterView( )
}
