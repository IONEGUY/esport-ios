//
//  OutgoingMessage.swift
//  e-sport
//
//  Created by MacBook on 22.10.21.
//

import SwiftUI

struct OutgoingMessage: View {
    @State var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Color.white)
            .font(.system(size: 13, weight: .regular))
            .padding(20)
            .background(Color(hex: 0x007AFF))
            .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
            .overlay(OutgoingMessageBorder().stroke(Color.white, lineWidth: 3))
    }
}

struct OutgoingMessageBorder: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 20))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - 20, y: 0),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + 20, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY + 20),
                          control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 20))
        path.addQuadCurve(to: CGPoint(x: rect.minX + 20, y: rect.maxY),
                          control: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}
