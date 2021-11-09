//
//  ObjectTrigger.swift
//  SmARt
//
//  Created by MacBook on 13.09.21.
//

import Foundation

struct ObjectTrigger: Codable {
    var id: String
    var image: ImageData
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
    }
}
