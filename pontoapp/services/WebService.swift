//
//  WebService.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import Foundation

class WebService: ObservableObject {
    
    func postRecord(latitude: Double, longitude: Double, userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "http://apppontoapi-production.up.railway.app/records") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "userId": userId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"])))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
}
