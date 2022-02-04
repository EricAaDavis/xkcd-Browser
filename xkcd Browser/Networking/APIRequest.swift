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
    var imageURL: URL? { get }
}

//This value usually doesn't changes, so we set a default value
extension APIRequest {
    var host: String { "xkcd.com" }
}

//These will usually be nil, so we set a default value
extension APIRequest {
    var path: String { "/info.0.json" }
    var queryItems: [URLQueryItem]? { nil }
    var imageURL: URL? { nil }
}

//Constructed api request
extension APIRequest {
    var request: URLRequest {
        //If we have an imageURL, send a request with the imageURL for the respectable comic
        if let imageURL = imageURL {
            let imageRequest = URLRequest(url: imageURL)
            return imageRequest
        } else {
            //Otherwise, if we do not have an imageURL, construct a url for the requested comic
            var components = URLComponents()
            
            components.scheme = "https"
            components.host = host
            components.path = path
            components.queryItems = queryItems
            
            let request = URLRequest(url: components.url!)
            
            return request
        }
    }
}

//Limiting the user of the method inside to only those types whose associated Response typed are decodable
extension APIRequest where Response: Decodable {
    
    func send(completion: @escaping (Result<Response, Error>) -> Void) {
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
        }.resume()
    }
}

enum ImageRequestError: Error {
    case coundNotInitializeFromData
}

extension APIRequest where Response == UIImage {
    func send(completion: @escaping (Result<Self.Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data,
               let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(ImageRequestError.coundNotInitializeFromData))
            }
        }.resume()
    }
}

extension APIRequest where Response == Data {
    func send(completion: @escaping (Result<Self.Response, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            } else {
                print("Could not get image data")
            }
        }
    }
}
