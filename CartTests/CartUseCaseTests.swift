//
//  CartTests.swift
//  CartTests
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import XCTest
@testable import Cart
import Combine

class CartUseCaseTests: XCTestCase {
    private var useCase: CartUseCaseInterface!
    private var repository: MockCartRepository!
    private var cancellables = Set<AnyCancellable>()
    override func setUp() {
        super.setUp()

        repository = MockCartRepository()
        useCase = CartUseCase(repository: repository)
    }

    func testCartGetsMappedProperly() {
        let products: [ProductDAO] = [
            ProductDAO(id: "1", price: 12, name: "Product 1", image: nil, description: "Description 1", count: 2, discount: ProductDiscountDAO(value: 2, expiracy: Date())),
            ProductDAO(id: "2", price: 22, name: "Product 2", image: nil, description: "Description 2", count: 1, discount: ProductDiscountDAO(value: 4, expiracy: Date().advanced(by: 300)))
        ]
        let discount = CartDiscountDAO(value: 2, products: ["1", "2"], expiracy: Date().advanced(by: 300))
        repository.localCart = CartDAO(products: products, discount: [discount])
        let cart = useCase.getCart()
        XCTAssertEqual(cart.products.count, 2)
        XCTAssertEqual(cart.products[0].id, "1")
        XCTAssertEqual(cart.products[1].id, "2")
        XCTAssertEqual(cart.products[0].price, 12)
        XCTAssertEqual(cart.products[0].discountedPrice, cart.products[0].price)
        XCTAssertEqual(cart.products[1].discountedPrice, 18)
        XCTAssertEqual(cart.products[1].price, 22)
        XCTAssertEqual(cart.price, 12 * 2 + 22)
        XCTAssertEqual(cart.grupDiscounts[0].value, 2)
        XCTAssertEqual(cart.discountedPrice, 12 * 2 + 18 - 2)
    }

    func testRemoveProduct() {
        let expectation = expectation(description: "testing different cart states")
        let products: [ProductDAO] = [
            ProductDAO(id: "1", price: 12, name: "Product 1", image: nil, description: "Description 1", count: 2, discount: ProductDiscountDAO(value: 2, expiracy: Date())),
            ProductDAO(id: "2", price: 22, name: "Product 2", image: nil, description: "Description 2", count: 1, discount: ProductDiscountDAO(value: 4, expiracy: Date().advanced(by: 300))),
            ProductDAO(id: "3", price: 18, name: "Product 3", image: nil, description: "Description 3", count: 2, discount: nil)
        ]
        let discount = CartDiscountDAO(value: 2, products: ["1", "2"], expiracy: Date().advanced(by: 300))
        repository.localCart = CartDAO(products: products, discount: [discount])
        let cart = useCase.getCart()

        XCTAssertEqual(cart.products.count, 3)
        XCTAssertEqual(cart.products[0].id, "1")
        XCTAssertEqual(cart.products[1].id, "2")
        XCTAssertEqual(cart.products[2].id, "3")
        XCTAssertEqual(cart.products[0].price, 12)
        XCTAssertEqual(cart.products[0].discountedPrice, cart.products[0].price)
        XCTAssertEqual(cart.products[1].discountedPrice, 18)
        XCTAssertEqual(cart.products[1].price, 22)
        XCTAssertEqual(cart.products[2].discountedPrice, 18)
        XCTAssertEqual(cart.products[2].price, 18)
        XCTAssertEqual(cart.price, 12 * 2 + 22 + 18 * 2)
        XCTAssertEqual(cart.grupDiscounts[0].value, 2)
        XCTAssertEqual(cart.discountedPrice, 24 + 18 + 36 - 2)

        useCase.removeProduct(cart.products[2])
            .sink(receiveCompletion: { _ in }, receiveValue: { cart in

                XCTAssertEqual(cart.products.count, 2)
                XCTAssertEqual(cart.products[0].id, "1")
                XCTAssertEqual(cart.products[1].id, "2")
                XCTAssertEqual(cart.products[0].price, 12)
                XCTAssertEqual(cart.products[0].discountedPrice, cart.products[0].price)
                XCTAssertEqual(cart.products[1].discountedPrice, 18)
                XCTAssertEqual(cart.products[1].price, 22)
                XCTAssertEqual(cart.price, 12 * 2 + 22)
                XCTAssertEqual(cart.grupDiscounts[0].value, 2)
                XCTAssertEqual(cart.discountedPrice, 12 * 2 + 18 - 2)

                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)
    }

    func testAddProduct() {
        let expectation = expectation(description: "testing different cart states")
        let existing = ProductDAO(id: "1", price: 12, name: "Product 1", image: nil, description: "Description 1", count: 2, discount: ProductDiscountDAO(value: 2, expiracy: Date()))
        let toAdd = ProductDAO(id: "2", price: 22, name: "Product 2", image: nil, description: "Description 2", count: 1, discount: ProductDiscountDAO(value: 4, expiracy: Date().advanced(by: 300)))

        repository.localCart = CartDAO(products: [existing, toAdd], discount: [])
        let mappedToAdd = useCase.getCart().products[1]
        repository.localCart = CartDAO(products: [existing], discount: [])
        let cart = useCase.getCart()

        XCTAssertEqual(cart.products.count, 1)
        XCTAssertEqual(cart.products[0].id, "1")
        XCTAssertEqual(cart.products[0].price, 12)
        XCTAssertEqual(cart.products[0].discountedPrice, cart.products[0].price)
        XCTAssertEqual(cart.price, 12 * 2 )
        XCTAssertTrue(cart.grupDiscounts.isEmpty)

        useCase.addProduct(mappedToAdd)
            .sink(receiveCompletion: { _ in }, receiveValue: { cart in

                XCTAssertEqual(cart.products.count, 2)
                XCTAssertEqual(cart.products[0].id, "1")
                XCTAssertEqual(cart.products[1].id, "2")
                XCTAssertEqual(cart.products[0].price, 12)
                XCTAssertEqual(cart.products[1].price, 22)
                XCTAssertEqual(cart.price, 12 * 2 + 22)
                XCTAssertTrue(cart.grupDiscounts.isEmpty)

                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)
    }
}
