//
//  SoundFile.swift
//  SmARt
//
//  Created by MacBook on 15.09.21.
//

import Foundation

struct Sound: FileProtocol, Codable {
    var id: String = .empty
    var url: String = .empty
    var fileExtension = "mp3"
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
    }
}
