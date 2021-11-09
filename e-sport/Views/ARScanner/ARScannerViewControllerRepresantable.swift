//
//  ARScannerViewControllerRepresantable.swift
//  e-sport
//
//  Created by MacBook on 20.10.21.
//

import Foundation
import SwiftUI
import UIKit

struct ARScannerViewControllerRepresantable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        return UINavigationController(rootViewController: ARScannerViewController(viewModel: ARScannerViewModel()))
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
