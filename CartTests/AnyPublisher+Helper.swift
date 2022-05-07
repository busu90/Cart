//
//  AnyPublisher+Helper.swift
//  CartTests
//
//  Created by Andrei Busuioc on 07.05.2022.
//

import Foundation
import Combine

extension AnyPublisher {
    static func just(_ item: Output) -> Self {
        Just(item)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
}
