//
//  AboutViewModel.swift
//  e-sport
//
//  Created by MacBook on 13.10.21.
//

import Foundation
import SwiftUI
import Combine

class AboutViewModel: ObservableObject {
    func openMoreDetails() {
        if let url = URL(string: "www.apple.com") {
            UIApplication.shared.open(url)
        }
    }
}
