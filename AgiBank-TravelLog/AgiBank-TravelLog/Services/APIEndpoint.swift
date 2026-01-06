//
//  APIEndpoint.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import Foundation

/// Struct vazio usado para representar respostas HTTP sem corpo decodificável.
struct EmptyResponse: Decodable {
    init() {}
    init(from decoder: Decoder) throws {
        // do nothing
    }
}

/// Enum com os endpoints da API do TravelLog.
///
/// Use `url` e `method` para construir requisições HTTP.
enum APIEndpoint {
    case destinations
    case saveDestination(TravelDestination)
    case uploadImage(Data)
    
    /// URL completa do endpoint.
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
    
    /// Método HTTP a ser usado para o endpoint.
    var method: String {
        switch self {
        case .destinations: return "GET"
        case .saveDestination: return "POST"
        case .uploadImage: return "POST"
        }
    }
}

/// Cliente HTTP assíncrono que realiza requisições e decodifica respostas.
///
/// - Observação: lança `APIError` em cenários de falha.
actor APIClient {
    private let session: URLSession
    
    /// Inicializa o cliente com uma configuração de sessão opcional.
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    /// Faz uma requisição para o endpoint e decodifica o resultado em `T`.
    ///
    /// - Parameter endpoint: endpoint a ser solicitado.
    /// - Returns: objeto decodificado do tipo `T`.
    /// - Throws: `APIError` em caso de falhas de rede, status HTTP inválido ou erro de decodificação.
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

   /// Requisição sem retorno (usa `EmptyResponse`).
   /// - Parameter endpoint: endpoint a ser solicitado.
   func request(_ endpoint: APIEndpoint) async throws {
       let _: EmptyResponse = try await request(endpoint)
   }
    
    /// Upload fictício — placeholder que retorna uma URL de exemplo.
    /// - Parameter data: dados a enviar.
    /// - Returns: URL do arquivo enviado.
    func upload(data: Data) async throws -> URL {
        //MARK: TODO Implementation for file upload
        return URL(string: "https://cdn.travellog.com/photo.jpg")!
    }
}
