//
//  CartDiscount.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

class CartDiscount {
    var value: Float
    var products: [Product]

    init(value: Float, products: [Product]) {
        self.value = value
        self.products = products
    }
}
