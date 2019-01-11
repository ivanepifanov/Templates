//
//  JSONDecoder+iso8601.swift
//  NexusCustomer
//
//  Created by Ivan Epifanov on 12/7/18.
//  Copyright © 2018 Intellectsoft. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static func iso8601() -> JSONDecoder {
     let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
