//
//  CartUseCase.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation
import Combine

protocol CartUseCaseInterface {
    func updateCart() -> AnyPublisher<Cart, Error>
    func addProduct(_ product: Product) -> AnyPublisher<Cart, Error>
    func removeProduct(_ product: Product) -> AnyPublisher<Cart, Error>
    func getCart() -> Cart
}

class CartUseCase: CartUseCaseInterface {
    private let repository: CartRepositoryInterface

    init(repository: CartRepositoryInterface = CartRepository()) {
        self.repository = repository
    }

    func updateCart() -> AnyPublisher<Cart, Error> {
        repository.updateCart()
            .map ({ CartUseCase.cartMapping($0) })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func addProduct(_ product: Product) -> AnyPublisher<Cart, Error> {
        repository.addProduct(CartUseCase.productMapping(product))
            .map ({ CartUseCase.cartMapping($0) })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func removeProduct(_ product: Product) -> AnyPublisher<Cart, Error> {
        repository.removeProduct(product.id)
            .map ({ CartUseCase.cartMapping($0) })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func getCart() -> Cart {
        CartUseCase.cartMapping(repository.getCart())
    }

    private static func cartMapping(_ cart: CartDAO) -> Cart {
        let products = cart.products.map { productMapping($0) }
        let discounts = cart.discount.compactMap { cartDiscountMapping($0, withProducts: products) }
        let price = products.reduce(0) { $0 + $1.price * Float($1.count) }
        var discountedPrice = products.reduce(0) { $0 + $1.discountedPrice * Float($1.count) }
        discountedPrice = discounts.reduce(discountedPrice, { $0 - $1.value })
        let productExpirecies = cart.products.compactMap { $0.discount?.expiracy }
        let cartExpiracies = cart.discount.compactMap({ $0.expiracy })
        let expiracy = (productExpirecies + cartExpiracies).sorted().first { $0 > Date() }
        return Cart(products: products,
                    grupDiscounts: discounts,
                    price: price,
                    discountedPrice: discountedPrice,
                    discountExpiracy: expiracy)
    }

    private static func cartDiscountMapping(_ discount: CartDiscountDAO, withProducts products: [Product]) -> CartDiscount? {
        guard discount.expiracy ?? Date() > Date() else {
            return nil
        }
        let filteredProducts = products.filter({
            discount.products.contains($0.id)
        })
        return CartDiscount(value: discount.value, products: filteredProducts)
    }

    private static func productMapping(_ product: ProductDAO) -> Product {
        let hasDiscount = (product.discount?.expiracy ?? Date()) > Date()
        let discountValue = hasDiscount ? (product.discount?.value ?? 0) : 0
        let discountedPrice = product.price - discountValue
        return Product(id: product.id,
                price: product.price,
                name: product.name,
                description: product.description,
                count: product.count,
                image: product.image,
                discountedPrice: discountedPrice)
    }

    private static func productMapping(_ product: Product) -> ProductDAO {
        ProductDAO(id: product.id,
                   price: product.price,
                   name: product.name,
                   image: product.image,
                   description: product.description,
                   count: product.count,
                   discount: nil)
    }
}
