//
//  MainTabViewController.swift
//  e-sport
//
//  Created by MacBook on 12.10.21.
//

import Foundation
import UIKit
import SwiftUI

class MainTabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onboardingView = UIHostingController(rootView: MainTabView())
        addChild(onboardingView)
        view.addSubview(onboardingView.view)
        onboardingView.view.fillSuperview()
    }
}
