//
//  Cart.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

class Cart {
    var products: [Product]
    var grupDiscounts: [CartDiscount]
    var price: Float
    var discountedPrice: Float
    var discountExpiracy: Date?

    init(products: [Product],
         grupDiscounts: [CartDiscount],
         price: Float,
         discountedPrice: Float,
         discountExpiracy: Date?) {
        self.products = products
        self.grupDiscounts = grupDiscounts
        self.price = price
        self.discountedPrice = discountedPrice
        self.discountExpiracy = discountExpiracy
    }
}
