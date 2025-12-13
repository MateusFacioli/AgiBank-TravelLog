//
//  APIEndpoint.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import Foundation

struct EmptyResponse: Decodable {
    init() {}
    init(from decoder: Decoder) throws {
        // do nothing
    }
}


enum APIEndpoint {
    case destinations
    case saveDestination(TravelDestination)
    case uploadImage(Data)
    
    var url: URL {
        //MARK: GET FLAGS AND CURRENCIES
        let baseURL = URL(string: "https://api.travellog.com/v1")!
        switch self {
        case .destinations:
            return baseURL.appendingPathComponent("destinations")
        case .saveDestination:
            return baseURL.appendingPathComponent("destinations")
        case .uploadImage:
            return baseURL.appendingPathComponent("upload")
        }
    }
    
    var method: String {
        switch self {
        case .destinations: return "GET"
        case .saveDestination: return "POST"
        case .uploadImage: return "POST"
        }
    }
}

actor APIClient {
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               
               let (data, response) = try await session.data(for: request)
               
               guard let httpResponse = response as? HTTPURLResponse else {
                   throw APIError.invalidResponse
               }
               
               print("Status Code: \(httpResponse.statusCode)")
               if let dataString = String(data: data, encoding: .utf8) {
                   print("Response: \(dataString)")
               }
               
               guard (200...299).contains(httpResponse.statusCode) else {
                   throw APIError.from(statusCode: httpResponse.statusCode)
               }
               
               if T.self == EmptyResponse.self && data.isEmpty {
                   return EmptyResponse() as! T
               }
               
               
               if T.self == EmptyResponse.self {
                   return try JSONDecoder().decode(T.self, from: data)
               }
               
               do {
                   return try JSONDecoder().decode(T.self, from: data)
               } catch let decodingError {
                   print("Decoding error: \(decodingError)")
                   throw APIError.responseDecodingFailed
               }
           
        
        return try JSONDecoder().decode(T.self, from: data)
    }

   func request(_ endpoint: APIEndpoint) async throws {
       let _: EmptyResponse = try await request(endpoint)
   }
    
    func upload(data: Data) async throws -> URL {
        //MARK: TODO Implementation for file upload
        return URL(string: "https://cdn.travellog.com/photo.jpg")!
    }
}
