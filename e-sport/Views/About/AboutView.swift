//
//  AboutView.swift
//  e-sport
//
//  Created by MacBook on 12.10.21.
//

import SwiftUI
import WebKit

struct AboutView: View {
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    @ObservedObject var viewModel: AboutViewModel
    
    init() {
        self.viewModel = AboutViewModel()
    }
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    Image("about_header")
                        .resizable()
                    VStack(alignment: .center) {
                        Spacer()
                        Text("About")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                    }
                }
                .frame(height: 250)
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text(Constants.aboutText)
                            .font(.system(size: 12))
                            .foregroundColor(Color.white)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .padding()
                        Text("SEL4 is sponsored by:")
                        VStack {
                            HStack {
                                Spacer()
                                Image("Image-1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                Spacer()
                                Image("Image-2")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Image("Image-3")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                Spacer()
                                Image("Image-4")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                Spacer()
                            }
                        }
                        Text("SEL4 in partnership with:")
                        VStack {
                            HStack {
                                Spacer()
                                Image("Image-5")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                                Image("Image-6")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                                Image("Image-7")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Image("Image-8")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                                Image("Image-9")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                                Image("Image-10")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Image("Image-11")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                                Image("Image-12")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                                Image("Image-13")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                            }
                            .frame(height: 70)
                            HStack {
                                Spacer()
                                Image("Image-14")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                Spacer()
                            }
                            .frame(height: 70)
                        }
                    }
                    .padding(.bottom, 15 )
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(Color(hex: 0x00008b))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
