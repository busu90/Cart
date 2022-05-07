//
//  Endpoint.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

enum EndpointType: String {
    case get, post, delete
}

struct Endpoint {
    var path: String
    var method: EndpointType = .get
    var queryItems = [URLQueryItem]()

    func makeRequest() -> URLRequest? {
        var components = URLComponents()
        //these params should be set depending on environment
        components.scheme = ""
        components.host = ""
        components.path = "/" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()

        return URLRequest(url: url)
    }
}
