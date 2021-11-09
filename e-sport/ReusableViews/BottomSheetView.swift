//
//  BottomSheetView.swift
//  e-sport
//
//  Created by MacBook on 20.10.21.
//

import SwiftUI

private enum Consts {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 5
    static let indicatorWidth: CGFloat = 64
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 10 : maxHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: Consts.radius)
            .fill(Color(hex: 0x3A3A3C))
            .frame(
                width: Consts.indicatorWidth,
                height: Consts.indicatorHeight
        ).onTapGesture {
            self.isOpen.toggle()
        }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding(8)
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Consts.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
