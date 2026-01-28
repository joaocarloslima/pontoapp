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
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "AirtableToken") as? String ?? ""
    
    func postRecord(record: RecordModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/tblkNzlaXHa3x5SVr") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        var fields: [String: Any] = [
            "latitude": record.latitude,
            "longitude": record.longitude,
            "student": [record.studentId],
            "datetime": Date.dateTimeNow(),
            "Status": record.status.rawValue
        ]
        
        if let justifyText = record.justifyText, !justifyText.isEmpty {
            fields["Justify"] = justifyText
        }
        
        if let files = record.filesURL, !files.isEmpty {
            let attachmentsArray = files.map { url in
                return ["url": url]
            }
            
            fields["Attach"] = attachmentsArray
        }
        
        let body: [String: Any] = [
            "fields": fields,
            "typecast": true
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

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"])))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let jsonErro = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("ERRO DO AIRTABLE: \(jsonErro)")
                }
                
                let erro = NSError(
                    domain: "APIError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "Erro no servidor. Status \(httpResponse.statusCode)"]
                )
                
                completion(.failure(erro))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    func fetchCalendar(student: String, month: Int, year: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
        let baseURL = "https://api.airtable.com/v0/app4Cut7Wu9GESQDL/Timelog"
        var components = URLComponents(string: baseURL)
        
        components?.queryItems = [
            URLQueryItem(name: "filterByFormula",value: "AND(SEARCH('\(student)',{student}),MONTH({datetime}) = \(month), YEAR({datetime}) = \(year))")
        ]
        
        guard let url = components?.url else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Resposta: \(jsonString)")
                }
            }
        }
        task.resume()
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
