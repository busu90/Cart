//
//  MockCardRepository.swift
//  CartTests
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import XCTest
@testable import Cart
import Combine

class MockCartRepository: CartRepositoryInterface {
    var localCart = CartDAO(products: [], discount: [])

    func updateCart() -> AnyPublisher<CartDAO, Error> {
        .just(localCart)
    }

    func addProduct(_ product: ProductDAO) -> AnyPublisher<CartDAO, Error> {
        localCart = CartDAO(products: localCart.products + [product], discount: localCart.discount)
        return .just(localCart)
    }

    func removeProduct(_ product: String) -> AnyPublisher<CartDAO, Error> {
        var products = localCart.products
        products.removeAll { $0.id == product }
        localCart = CartDAO(products: products, discount: localCart.discount)
        return .just(localCart)
    }

    func getCart() -> CartDAO {
        localCart
    }
}
