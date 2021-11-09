//
//  IncomingMessage.swift
//  e-sport
//
//  Created by MacBook on 22.10.21.
//

import SwiftUI

struct IncomingMessage: View {
    @State var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Color.white)
            .font(.system(size: 13, weight: .regular))
            .padding(20)
            .background(Color(hex: 0x8E8E93, alpha: 0.8))
            .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
            .overlay(OutgoingMessageBorder()
                        .stroke(Color.blue, lineWidth: 3)
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0)))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
