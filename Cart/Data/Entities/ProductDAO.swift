//
//  ProductDAO.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

struct ProductDAO: Codable {
    let id: String
    let price: Float
    let name: String
    let image: URL?
    let description: String
    let count: Int
    let discount: ProductDiscountDAO?
}
