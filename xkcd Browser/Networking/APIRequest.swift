//
//  APIRequest.swift
//  xkcd Browser
//
//  Created by Eric Davis on 31/01/2022.
//

import UIKit

protocol APIRequest {
    //Response represents the type of object returned by the request
    associatedtype Response
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
}

//This value never changes, so we set a default value
extension APIRequest {
    var host: String { "xkcd.com" }
}

//Constructed api request
extension APIRequest {
    var request: URLRequest {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        let request = URLRequest(url: components.url!)
        
        return request
    }
}

//Limiting the user of the method inside to only those types whose associated Response typed are decodable
extension APIRequest where Response: Decodable {
    
    func sendAPIRequest(completion: @escaping (Result<Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            do {
                if let data = data {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(decoded))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
            catch {
                print("Request Failed")
            }
        }
    }
    
    
}
