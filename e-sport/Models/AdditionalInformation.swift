//
//  AdditionalInformation.swift
//  SmARt
//
//  Created by MacBook on 9.06.21.
//

import Foundation

struct AdditionalInformation: Codable {
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case text
    }
}
