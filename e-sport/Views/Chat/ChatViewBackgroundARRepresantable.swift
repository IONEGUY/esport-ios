//
//  ChatViewBackgroundARRepresantable.swift
//  e-sport
//
//  Created by MacBook on 27.10.21.
//

import Foundation
import SwiftUI
import UIKit

struct ChatViewBackgroundARRepresantable: UIViewControllerRepresentable {
    @State var viewModel: ChatViewModel
    
    func makeUIViewController(context: Context) -> ChatViewBackgroundARViewController {
        return ChatViewBackgroundARViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: ChatViewBackgroundARViewController, context: Context) {}
}
