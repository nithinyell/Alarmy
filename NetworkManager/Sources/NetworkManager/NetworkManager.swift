// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// MARK: - Network Errors

public enum NetworkError: Error {
    case invalidURL
    case invalidData
    case unknown
}


// MARK: - Network Manager

public protocol NetworkManager {
    func request(_ url: String) async throws -> Data?
}

// MARK: - Network

public final class Network {
    public init() {}
}

extension Network: NetworkManager {
    public func request(_ url: String) async throws -> Data? {
        guard let url = URL(string: url) else { throw NetworkError.invalidURL }
        
        do {
            let urlRequest = URLRequest(url: url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                throw NetworkError.invalidData
            }
            
            return data
        } catch {
            throw NetworkError.unknown
        }
    }
}
