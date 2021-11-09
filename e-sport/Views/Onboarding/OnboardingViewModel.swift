//
//  OnboardingViewModel.swift
//  SmARt
//
//  Created by MacBook on 19.03.21.
//

import Foundation
import Combine
import SwiftUI

class OnboardingViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    var pushMenuPage = PassthroughSubject<Void, Never>()
    
    @Published var pageIndex: Int = 0
    @Published var buttonText = "Next"
    @Published var title = "Welcome to the Scottish Esports League!"
    @Published var image = "Onboarding_step_1"
    var onboardingConfig = [
        (image: "Onboarding_step_1", title: "Welcome to the Scottish Esports League"),
        (image: "Onboarding_step_2", title: "Scottish esports returns to LAN"),
        (image: "Onboarding_step_3", title: "Six games over four days in Dundee")
    ]
    
    func getStartedButtonAction() {
        buttonText = pageIndex == onboardingConfig.count - 2 ? "Let's go!" : "Next"
        if pageIndex == onboardingConfig.count - 1 {
            pushMenuPage.send()
        } else {
            pageIndex += 1
            title = onboardingConfig[pageIndex].title
            image = onboardingConfig[pageIndex].image
        }
    }
}
