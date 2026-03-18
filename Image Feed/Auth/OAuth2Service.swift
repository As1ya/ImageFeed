//
//  OAuth2Service.swift
//  Image Feed
//
//  Created by Анастасия Федотова on 18.03.2026.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage()
    
    private func makeTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyParams = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        let bodyString = bodyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        urlSession.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self?.tokenStorage.token = response.accessToken
                    completion(.success(response.accessToken))  // ✅ использовать accessToken
                } catch {
                    print("Ошибка декодирования OAuthTokenResponseBody:", error)
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("Ошибка запроса OAuth2:", error)
                completion(.failure(error))
            }
        }
    }
}
