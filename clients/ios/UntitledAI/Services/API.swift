//
//  API.swift
//  UntitledAI
//
//  Created by ethan on 1/23/24.
//

import Foundation
class API {
    static let shared = API()
    
    private init() {}

    func fetchConversations(completionHandler: @escaping (ConversationsResponse) -> Void) {
        guard let url = URL(string: "\(AppConstants.apiBaseURL)/conversations/") else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder.dateDecoder()
                    let conversationsResponse = try decoder.decode(ConversationsResponse.self, from: data)
                    completionHandler(conversationsResponse)
                } catch {
                    print("Unable to decode, \(error)")
                }
            }
        }
        task.resume()
    }

    func saveLocation(_ location: Location, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(AppConstants.apiBaseURL)/capture/location") else {
            completionHandler(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(location)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON String: \(jsonString)")
                }
            request.httpBody = jsonData
        } catch {
            completionHandler(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completionHandler(.success(true))
            } else {
                completionHandler(.failure(NSError(domain: "Error saving location", code: -1, userInfo: nil)))
            }
        }
        task.resume()
    }
}