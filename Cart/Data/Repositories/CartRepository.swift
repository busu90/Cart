//
//  CartRepository.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation
import Combine

protocol CartRepositoryInterface {
    func updateCart() -> AnyPublisher<CartDAO, Error>
    func addProduct(_ product: ProductDAO) -> AnyPublisher<CartDAO, Error>
    func removeProduct(_ product: String) -> AnyPublisher<CartDAO, Error>
    func getCart() -> CartDAO
}

class CartRepository: CartRepositoryInterface {
    //this should be cached in Realm/CoreDate/UserDefaults
    //currently i just keep it in memory
    private var localCart = CartDAO(products: [], discount: [])

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func updateCart() -> AnyPublisher<CartDAO, Error> {
        let response = urlSession.publisher(for: .getCart()) as AnyPublisher<CartDAO, Error>
        return response.map ({ [weak self] cart -> CartDAO in
            self?.localCart = cart
            return cart
        }).eraseToAnyPublisher()
    }

    func addProduct(_ product: ProductDAO) -> AnyPublisher<CartDAO, Error> {
        let response = urlSession.publisher(for: .addProduct(), body: product) as AnyPublisher<CartDAO, Error>
        return response.map ({ [weak self] cart -> CartDAO in
            self?.localCart = cart
            return cart
        }).eraseToAnyPublisher()
    }

    func removeProduct(_ product: String) -> AnyPublisher<CartDAO, Error> {
        let response = urlSession.publisher(for: .removeProduct(product)) as AnyPublisher<CartDAO, Error>
        return response.map ({ [weak self] cart -> CartDAO in
            self?.localCart = cart
            return cart
        }).eraseToAnyPublisher()
    }

    func getCart() -> CartDAO {
        localCart
    }
}
