//
//  JSONEncoder+iso8601.swift
//  NexusCustomer
//
//  Created by Ivan Epifanov on 12/7/18.
//  Copyright © 2018 Intellectsoft. All rights reserved.
//

import Foundation

extension JSONEncoder {
    static func iso8601() -> JSONEncoder {
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .iso8601
        return decoder
    }
}
