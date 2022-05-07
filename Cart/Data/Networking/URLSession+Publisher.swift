//
//  URLSession+Publisher.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation
import Combine

extension URLSession {
    private static var defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return decoder
    }()

    private static var defaultEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        return encoder
    }()

    func publisher<R: Decodable>(for endpoint: Endpoint, decoder: JSONDecoder = defaultDecoder) -> AnyPublisher<R, Error> {
        guard let request = endpoint.makeRequest() else {
            //should return a custom error
            return Fail( error: NSError()).eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: R.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func publisher<R: Decodable, T: Encodable>(for endpoint: Endpoint, body: T, decoder: JSONDecoder = defaultDecoder, encoder: JSONEncoder = defaultEncoder) -> AnyPublisher<R, Error> {
        guard var request = endpoint.makeRequest() else {
            //should return a custom error
            return Fail( error: NSError()).eraseToAnyPublisher()
        }
        request.httpBody = try? encoder.encode(body)

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: R.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
