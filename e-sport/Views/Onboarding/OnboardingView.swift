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
                if viewModel.pageIndex == 2 {
                    Spacer()
                    VStack {
                        HStack {
                            VStack {
                                Image("info")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                Text("About")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 70)
                            Text("Learn more about SEL4")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack {
                            VStack {
                                Image("navigation")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                Text("Navigation")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 70)
                            Text("Directs you to the event")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack {
                            VStack {
                                Image("tournament")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                Text("Tournament")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 70)
                            Text("Provides you information of the event and the latest tournament results")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack {
                            VStack {
                                Image("ar")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                Text("AR")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 70)
                            Text("Point your camera at the SEL4 poster and see it come to life")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        HStack {
                            VStack {
                                Image("assistant")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                Text("Assistant")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 70)
                            Text("Want to know more about the event? Try asking our assistant")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                } else {
                    Text(viewModel.title)
                        .frame(width: 343, height: 100)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 176)
                    Spacer()
                }
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
