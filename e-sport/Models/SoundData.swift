//
//  SoundData.swift
//  SmARt
//
//  Created by MacBook on 15.09.21.
//

import Foundation

struct SoundData: Codable {
    var id: String
    var file: ImageData
    
    enum CodingKeys: String, CodingKey {
        case id
        case file
    }
}
