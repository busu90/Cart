//
//  CartDAO.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

struct CartDAO: Codable {
    let products: [ProductDAO]
    let discount: [CartDiscountDAO]
}
