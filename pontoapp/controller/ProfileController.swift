//
//  ProfileController.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import SwiftUI
import PhotosUI

class ProfileController: NSObject, ObservableObject {
    
  
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }
    }
    
    @Published var profileImage: Image?
    
    func loadImage() async throws{
        guard let item = selectedImage else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let image = UIImage(data: imageData) else { return }
        DispatchQueue.main.async {
            self.profileImage = Image(uiImage: image)
        }
    }
    
    
    
}
