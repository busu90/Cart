//
//  Product.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

class Product {
    var id: String
    var price: Float
    var name: String
    var description: String
    var count: Int
    var image: URL?
    var discountedPrice: Float

    init(id: String,
         price: Float,
         name: String,
         description: String,
         count: Int,
         image: URL?,
         discountedPrice: Float) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.count = count
        self.discountedPrice = discountedPrice
        self.image = image
    }
}
