//
//  TextMessage.swift
//  e-sport
//
//  Created by MacBook on 25.10.21.
//

import Foundation

struct TextMessage: Identifiable, Hashable {
    var id = UUID()
    var isEmpty = true
    var isIncoming = true
    var text: String = .empty
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
