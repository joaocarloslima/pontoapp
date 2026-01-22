//
//  RegistrationViewModel.swift
//  pontoapp
//
//  Created by Erick Costa on 19/01/26.
//

import Foundation
import CoreLocation

class RegistrationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var successMessage: String = ""
    
    private let webService = WebService()
    private let dropboxService = DropboxService()
    
    func registerEvent(studentId: String, status: RecordStatus, location: CLLocation?, justifyText: String? = nil, files: [URL]? = nil){
        guard let location = location else{
            DispatchQueue.main.async {
                self.errorMessage = "Localização não encontrada"
                self.showError = true
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        if let files = files, !files.isEmpty {
            uploadFilesToDropbox(files: files){ [weak self] dropboxFiles in
                DispatchQueue.main.async {
                    self?.sendToAirtable(studentId: studentId, status: status, location: location, justifyText: justifyText, fileLinks: dropboxFiles)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.sendToAirtable(studentId: studentId, status: status, location: location, justifyText: justifyText, fileLinks: nil)
            }
        }
    }
    
    func uploadFilesToDropbox(files: [URL], completion: @escaping ([String]) -> Void){
        let group = DispatchGroup()
        var uploadedLinks: [String] = []
        
        for file in files {
            group.enter()
            let accessGranted = file.startAccessingSecurityScopedResource()
            
            do{
                let fileData = try Data(contentsOf: file)
                let fileName = file.lastPathComponent
                
                dropboxService.uploadFileAndGetLink(fileData: fileData, fileName: fileName){ link in
                    if let link = link{
                        uploadedLinks.append(link)
                    }
                    
                    if accessGranted{
                        file.stopAccessingSecurityScopedResource()
                    }
                    group.leave()
                }
            } catch {
                print("Erro ao ler arquivo local: \(error.localizedDescription)")
                if accessGranted {
                    file.stopAccessingSecurityScopedResource()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(uploadedLinks)
        }
    }
    
    func sendToAirtable(studentId: String, status: RecordStatus, location: CLLocation, justifyText: String?, fileLinks: [String]?){
        
        let record = RecordModel(
            studentId: studentId,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            status: status,
            filesURL: fileLinks,
            justifyText: justifyText)
        
        webService.postRecord(record: record) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.successMessage = (status == .absent) ? "Falta justificada com sucesso!" : "Presença registrada com sucesso!"
                    self?.showSuccess = true
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            }
        }
    }
}
