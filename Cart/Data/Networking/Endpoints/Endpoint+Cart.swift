//
//  Endpoint+Cart.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

extension Endpoint {
    static func getCart() -> Self {
        Endpoint(path: "cart")
    }

    static func addProduct() -> Self {
        Endpoint(path: "cart/add", method: .post)
    }

    static func removeProduct(_ product: String) -> Self {
        Endpoint(path: "cart/remove", method: .delete, queryItems: [URLQueryItem(name: "id", value: product)])
    }
}
