import SwiftUI

struct RegisterView: View {
    
    @AppStorage("studentId") private var studentId: String = "k"
    
    @State private var justifyAbstence: Bool = false
    @State private var justifyLate: Bool = false
    @State private var showSettings = false
    
    @StateObject private var viewModel = RegistrationViewModel()
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var profileController = ProfileController()
    
    private var profileImage: Image? {
        if let profileImage = profileController.profileImage {
            return profileImage
        } else {
            return Image(systemName: "person.circle.fill")
        }
    }
    
    private let maxDragOffset: CGFloat = 150
    
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
            .navigationDestination(isPresented: $justifyLate){
                JustifyView(titleText: "Justificar Atraso", subtitleText: "MOTIVO DE SEU ATRASO"){ text, files in
                    
                    viewModel.registerEvent(
                        studentId: studentId,
                        status: .lated,
                        location: locationManager.userLocation,
                        justifyText: text,
                        files: files
                    )
                    justifyLate = false                }
            }
            .navigationDestination(isPresented: $justifyAbstence){
                JustifyView(titleText: "Justificar Ausência", subtitleText: "MOTIVO DA SUA AUSÊNCIA"){ text, files in
                    viewModel.registerEvent(
                        studentId: studentId,
                        status: .absent,
                        location: locationManager.userLocation,
                        justifyText: text,
                        files: files
                    )
                    justifyAbstence = false
                }
            }
            .fullScreenCover(isPresented: $viewModel.showSuccess) {
                RegisterSuccessView(text: viewModel.successMessage)
            }
            .alert("Erro", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Ocorreu um erro inesperado")
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
            
            CalendarView(){ month, year in
                viewModel.getCalendarInfos(month: month, year: year)
            }
            
            Spacer()
            
            if isChekcInWindowOpen() {
                PresenceSlider(profileImage: profileImage, onSwipeRight: {
                    LocalAuthService().authorizeUser { authenticated in
                        if authenticated {
                            if isOnTime() {
                                viewModel.registerEvent(
                                    studentId: studentId,
                                    status: .present,
                                    location: locationManager.userLocation
                                )
                            } else {
                                justifyLate = true
                            }
                        }
                    }
                    
                }, onSwipeLeft: {
                    justifyAbstence = true
                })
            } else {
                CardCheckInWindowClosedView()
            }
            
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
        
    func isOnTime() -> Bool {
        //limite é 14:10
        let endMinutes: Int = 14 * 60 + 10
        return Date.getCurrentMinutes() <= endMinutes
    }
    
    func isChekcInWindowOpen() -> Bool {
        let beginMinutes: Int = 13 * 60 + 30
        let endMinutes: Int = 17 * 60
        
        let nowMinutes = Date.getCurrentMinutes()

        return nowMinutes >= beginMinutes && nowMinutes < endMinutes
    }
    
}

#Preview {
    RegisterView( )
}
