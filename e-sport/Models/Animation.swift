//
//  Animation.swift
//  SmARt
//
//  Created by MacBook on 16.09.21.
//

import Foundation

struct Animation: Codable {
    var id: String = .empty
    var video: VideoData
    
    enum CodingKeys: String, CodingKey {
        case id
        case video
    }
}
