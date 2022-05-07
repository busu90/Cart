//
//  CartDiscountDAO.swift
//  Cart
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation

struct CartDiscountDAO: Codable {
    let value: Float
    let products: [String]
    let expiracy: Date?
}
