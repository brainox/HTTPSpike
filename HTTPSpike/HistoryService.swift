//
//  HistoryService.swift
//  HTTPSpike
//
//  Created by Decagon on 17/08/2021.
//

import Foundation

struct History: Codable {
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let id: Int
    let type: String
    let amount: String
    let processingDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case amount
        case processingDate = "processed_at"
    }
}

enum ServiceError: Error {
    case server
    case parsing
}

struct HistoryService {
    static let shared = HistoryService()
    
    func fetchTransaction(completion: @escaping ((Result<[Transaction], Error>) -> Void)) {
        
        let url = URL(string: "https://uwyg0quc7d.execute-api.us-west-2.amazonaws.com/prod/history")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
            
            guard let data = data else { return }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(Result.failure(ServiceError.server))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let result = try decoder.decode(History.self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(result.transactions))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(ServiceError.parsing))
                }
            }
        }
        task.resume()
    }
}

// https://uwyg0quc7d.execute-api.us-west-2.amazonaws.com/prod/history


