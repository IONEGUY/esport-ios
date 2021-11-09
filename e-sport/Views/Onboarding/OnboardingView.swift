//
//  OnboardingView.swift
//  SmARt
//
//  Created by MacBook on 19.03.21.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image(viewModel.image)
                .resizable()
            VStack {
                Text(viewModel.title)
                    .frame(width: 343, height: 100)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 176)
                Spacer()
                PageIndexView(pagesCount: viewModel.onboardingConfig.count,
                              currentIndex: $viewModel.pageIndex)
                    .padding(.bottom, 62)
                Button(action: viewModel.getStartedButtonAction, label: {
                    Text(viewModel.buttonText)
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.width - 32, height: 48)
                })
                .background(Color(hex: 0x007AFF))
                .cornerRadius(10)
                .padding(.bottom, 82)
            }
        }
        .ignoresSafeArea()
    }
}
