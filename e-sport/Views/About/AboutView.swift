//
//  AboutView.swift
//  e-sport
//
//  Created by MacBook on 12.10.21.
//

import SwiftUI
import SafariServices

struct AboutView: View {
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    @ObservedObject var viewModel: AboutViewModel
    
    init() {
        self.viewModel = AboutViewModel()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("about_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("Information about the current tournament, participating teams, points, completed or future games can be found on our personal website.")
                        .frame(width: 343, height: 200)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Button(action: {
                        let safariVC = SFSafariViewController(url: try! ApiConstants.aboutUrl.asURL())
                        self.viewControllerHolder?.present(safariVC, animated: true, completion: nil)
                    },
                           label: {
                        Text("More details")
                            .foregroundColor(Color.white)
                            .frame(width: 216, height: 48)
                    })
                    .background(Color(hex: 0x007AFF))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        let safariVC = SFSafariViewController(url: try! ApiConstants.g5Url.asURL())
                        self.viewControllerHolder?.present(safariVC, animated: true, completion: nil)
                    },
                           label: {
                        Text("The Scotland 5G Centre")
                            .foregroundColor(Color.white)
                            .frame(width: 216, height: 48)
                    })
                    .background(Color(hex: 0x007AFF))
                    .cornerRadius(10)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("About")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
