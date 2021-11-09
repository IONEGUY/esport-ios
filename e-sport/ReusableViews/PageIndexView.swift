//
//  PageIndexView.swift
//  e-sport
//
//  Created by MacBook on 7.10.21.
//

import SwiftUI

struct PageIndexView: View {
    @State var pagesCount: Int
    @Binding var currentIndex: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<pagesCount) { index in
                Capsule(style: .circular)
                    .frame(width: 8, height: 8)
                    .foregroundColor(index == currentIndex
                                    ? Color(hex: 0x007AFF)
                                    : Color(hex: 0x007AFF, alpha: 0.2))
            }
        }
    }
}
