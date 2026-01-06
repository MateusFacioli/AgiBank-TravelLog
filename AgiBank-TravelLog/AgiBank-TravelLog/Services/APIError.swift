//
//  APIError.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import Foundation

/// Enum que representa os erros possíveis na camada de API.
/// Fornece descrições legíveis, sugestões de recuperação e códigos quando apropriado.
enum APIError: Error, LocalizedError, Equatable {
    // Network errors
    case noInternetConnection
    case timeout
    case networkConnectionLost
    case notConnectedToInternet
    case dnsLookupFailed
    
    // HTTP errors
    case invalidResponse
    case invalidStatusCode(Int)
    case unauthorized
    case forbidden
    case notFound
    case methodNotAllowed
    case conflict
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
    case gatewayTimeout
    
    // Client errors
    case invalidURL
    case invalidRequest
    case badRequest
    case malformedRequest
    case requestBodyEncodingFailed
    
    // Response errors
    case responseDecodingFailed
    case invalidResponseFormat
    case emptyResponse
    case responseValidationFailed
    
    // Authentication errors
    case authenticationFailed
    case tokenExpired
    case invalidCredentials
    case sessionExpired
    
    // Server/API specific errors
    case apiError(message: String, code: String?)
    case maintenanceMode
    case apiVersionDeprecated
    case rateLimitExceeded(retryAfter: TimeInterval?)
    
    // Data errors
    case dataCorrupted
    case invalidData
    case missingRequiredFields([String])
    
    // File/Upload errors
    case fileUploadFailed
    case fileTooLarge(maxSize: Int)
    case invalidFileType(allowedTypes: [String])
    
    // Other errors
    case unknownError
    case cancelled
    case operationNotPermitted
    case resourceUnavailable
    case duplicateEntry
    
    // Custom error
    case custom(message: String, code: Int? = nil)
    
    // MARK: - Properties
    /// Mensagem legível representando o erro.
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "Sem conexão com a internet"
        case .timeout:
            return "Tempo de requisição excedido"
        case .networkConnectionLost:
            return "Conexão de rede perdida"
        case .notConnectedToInternet:
            return "Não conectado à internet"
        case .dnsLookupFailed:
            return "Falha ao resolver o endereço do servidor"
            
        case .invalidResponse:
            return "Resposta inválida do servidor"
        case .invalidStatusCode(let code):
            return "Código de status HTTP inválido: \(code)"
        case .unauthorized:
            return "Não autorizado"
        case .forbidden:
            return "Acesso proibido"
        case .notFound:
            return "Recurso não encontrado"
        case .methodNotAllowed:
            return "Método não permitido"
        case .conflict:
            return "Conflito de dados"
        case .tooManyRequests:
            return "Muitas requisições"
        case .internalServerError:
            return "Erro interno do servidor"
        case .serviceUnavailable:
            return "Serviço indisponível"
        case .gatewayTimeout:
            return "Tempo limite do gateway"
            
        case .invalidURL:
            return "URL inválida"
        case .invalidRequest:
            return "Requisição inválida"
        case .badRequest:
            return "Requisição mal formada"
        case .malformedRequest:
            return "Formato da requisição inválido"
        case .requestBodyEncodingFailed:
            return "Falha ao codificar o corpo da requisição"
            
        case .responseDecodingFailed:
            return "Falha ao decodificar a resposta"
        case .invalidResponseFormat:
            return "Formato da resposta inválido"
        case .emptyResponse:
            return "Resposta vazia"
        case .responseValidationFailed:
            return "Validação da resposta falhou"
            
        case .authenticationFailed:
            return "Autenticação falhou"
        case .tokenExpired:
            return "Token expirado"
        case .invalidCredentials:
            return "Credenciais inválidas"
        case .sessionExpired:
            return "Sessão expirada"
            
        case .apiError(let message, _):
            return message
        case .maintenanceMode:
            return "Serviço em manutenção"
        case .apiVersionDeprecated:
            return "Versão da API obsoleta"
        case .rateLimitExceeded:
            return "Limite de requisições excedido"
            
        case .dataCorrupted:
            return "Dados corrompidos"
        case .invalidData:
            return "Dados inválidos"
        case .missingRequiredFields(let fields):
            return "Campos obrigatórios faltando: \(fields.joined(separator: ", "))"
            
        case .fileUploadFailed:
            return "Falha ao fazer upload do arquivo"
        case .fileTooLarge(let maxSize):
            let sizeInMB = Double(maxSize) / (1024 * 1024)
            return "Arquivo muito grande. Tamanho máximo: \(String(format: "%.1f", sizeInMB)) MB"
        case .invalidFileType(let allowedTypes):
            return "Tipo de arquivo inválido. Tipos permitidos: \(allowedTypes.joined(separator: ", "))"
            
        case .unknownError:
            return "Erro desconhecido"
        case .cancelled:
            return "Operação cancelada"
        case .operationNotPermitted:
            return "Operação não permitida"
        case .resourceUnavailable:
            return "Recurso indisponível"
        case .duplicateEntry:
            return "Entrada duplicada"
            
        case .custom(let message, _):
            return message
        }
    }
    
    /// Sugestões de recuperação para apresentar ao usuário.
    var recoverySuggestion: String? {
        switch self {
        case .noInternetConnection, .notConnectedToInternet:
            return "Verifique sua conexão com a internet e tente novamente"
        case .timeout, .gatewayTimeout:
            return "Tente novamente em alguns instantes"
        case .unauthorized, .tokenExpired, .sessionExpired:
            return "Faça login novamente"
        case .rateLimitExceeded:
            return "Aguarde alguns minutos antes de tentar novamente"
        case .maintenanceMode, .serviceUnavailable:
            return "O serviço está temporariamente indisponível. Tente novamente mais tarde"
        case .tooManyRequests:
            return "Você fez muitas requisições. Aguarde um momento"
        default:
            return "Tente novamente mais tarde"
        }
    }
    
    /// Código numérico associado ao erro (quando aplicável).
    var errorCode: Int? {
        switch self {
        case .noInternetConnection: return -1009
        case .timeout: return -1001
        case .networkConnectionLost: return -1005
        case .notConnectedToInternet: return -1009
        case .dnsLookupFailed: return -1006
            
        case .invalidStatusCode(let code): return code
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .methodNotAllowed: return 405
        case .conflict: return 409
        case .tooManyRequests: return 429
        case .internalServerError: return 500
        case .serviceUnavailable: return 503
        case .gatewayTimeout: return 504
            
        case .invalidURL: return -1000
        case .badRequest: return 400
            
        case .apiError(_, let code):
            return Int(code ?? "")
            
        case .custom(_, let code):
            return code
            
        default:
            return nil
        }
    }
    
    // MARK: - Helper Methods
    /// Indica se é um erro de rede (útil para exibir mensagens apropriadas).
    var isNetworkError: Bool {
        switch self {
        case .noInternetConnection, .timeout, .networkConnectionLost,
             .notConnectedToInternet, .dnsLookupFailed:
            return true
        default:
            return false
        }
    }
    
    /// Indica se é um erro de autenticação.
    var isAuthenticationError: Bool {
        switch self {
        case .unauthorized, .forbidden, .authenticationFailed,
             .tokenExpired, .invalidCredentials, .sessionExpired:
            return true
        default:
            return false
        }
    }
    
    /// Indica se é um erro do lado do cliente (4xx).
    var isClientError: Bool {
        if case .invalidStatusCode(let code) = self {
            return (400...499).contains(code)
        }
        
        switch self {
        case .badRequest, .unauthorized, .forbidden, .notFound,
             .methodNotAllowed, .conflict, .tooManyRequests:
            return true
        default:
            return false
        }
    }
    
    /// Indica se é um erro do servidor (5xx).
    var isServerError: Bool {
        if case .invalidStatusCode(let code) = self {
            return (500...599).contains(code)
        }
        
        switch self {
        case .internalServerError, .serviceUnavailable, .gatewayTimeout:
            return true
        default:
            return false
        }
    }
    
    /// Mapeia um status code HTTP para um `APIError`.
    /// - Parameters:
    ///   - statusCode: código retornado pela API
    ///   - message: mensagem opcional vinda do servidor
    static func from(statusCode: Int, message: String? = nil) -> APIError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 405: return .methodNotAllowed
        case 409: return .conflict
        case 429: return .tooManyRequests
        case 500: return .internalServerError
        case 503: return .serviceUnavailable
        case 504: return .gatewayTimeout
        default:
            if let message = message, !message.isEmpty {
                return .apiError(message: message, code: "\(statusCode)")
            }
            return .invalidStatusCode(statusCode)
        }
    }
    
    /// Converte `Error` de rede para `APIError`.
    static func from(error: Error) -> APIError {
        let nsError = error as NSError
        
        switch nsError.code {
        case -1001:
            return .timeout
        case -1009, -1020:
            return .noInternetConnection
        case -1005:
            return .networkConnectionLost
        case -1000:
            return .invalidURL
        case -1003:
            return .dnsLookupFailed
        case -999:
            return .cancelled
        case -1200...(-1016):
            return .networkConnectionLost
        default:
            if let apiError = error as? APIError {
                return apiError
            }
            return .unknownError
        }
    }
}

// MARK: - Convenience Extensions
extension APIError {
    /// Dicionário pronto para envio a analytics/telemetria.
    var analyticsDictionary: [String: Any] {
        var dict: [String: Any] = [
            "error_type": String(describing: self),
            "error_description": errorDescription ?? "",
            "is_network_error": isNetworkError,
            "is_authentication_error": isAuthenticationError,
            "is_client_error": isClientError,
            "is_server_error": isServerError
        ]
        
        if let code = errorCode {
            dict["error_code"] = code
        }
        
        if let recovery = recoverySuggestion {
            dict["recovery_suggestion"] = recovery
        }
        
        return dict
    }
}
