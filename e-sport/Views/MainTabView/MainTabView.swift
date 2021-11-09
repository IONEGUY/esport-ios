//
//  MainTabView.swift
//  e-sport
//
//  Created by MacBook on 12.10.21.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
            TabView {
                AboutView()
                    .tabItem {
                        Image("info")
                        Text("About")
                    }
                MapNavigationView()
                    .tabItem {
                        Image("navigation")
                        Text("Navigation")
                    }
                ARScannerViewControllerRepresantable()
                    .ignoresSafeArea()
                    .tabItem {
                        Image("ar")
                        Text("AR")
                    }
                ChatView()
                    .tabItem {
                        Image("assistant")
                        Text("Assistant")
                    }
            }
            .font(.headline)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
