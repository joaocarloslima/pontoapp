//
//  WebService.swift
//  pontoapp
//
//  Created by Joao Carlos Lima on 11/11/24.
//

import Foundation

class WebService: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let apiKey = ProcessInfo.processInfo.environment["AIRTABLE_TOKEN"] ?? ""
    
    func postRecord(latitude: Double, longitude: Double, studentId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/tblkNzlaXHa3x5SVr") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }

        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        
        let body: [String: Any] = [
            "fields": [
                "latitude": latitude,
                "longitude": longitude,
                "student": [studentId]
            ]
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

            //print(response!)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"])))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        
        let baseURL = "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/Eventos"
        
        var components = URLComponents(string: baseURL)
        
        let filterFormula = "{Datetime} >= TODAY()"
        
        components?.queryItems = [
            URLQueryItem(name: "filterByFormula", value: filterFormula),
            URLQueryItem(name: "sort[0][field]", value: "Datetime"),
            URLQueryItem(name: "sort[0][direction]", value: "asc")
        ]
        
        guard let url = components?.url else {
            isLoading = false
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.isLoading = false

            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dados não encontrados"])
                self?.errorMessage = "Dados não encontrados"
                completion(.failure(error))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AirtableResponse.self, from: data)
                self?.events = result.records
                completion(.success(result.records))
            } catch {
                self?.errorMessage = "Erro ao processar dados"
                completion(.failure(error))
            }
        }.resume()
    }

}
