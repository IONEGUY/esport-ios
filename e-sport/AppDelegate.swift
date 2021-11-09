//
//  AppDelegate.swift
//  e-sport
//
//  Created by MacBook on 5.10.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeWindow()
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .black
        ExtendedRealityKitView.shared.setup()
        return true
    }
    
    private func initializeWindow() {
        var rootViewController: UIViewController
        if userDefaults.bool(forKey: "App Already Installed") {
            rootViewController = MainTabViewController()
        } else {
            rootViewController = OnboardingViewController()
            userDefaults.set(true, forKey: "App Already Installed")
        }
        self.showVC(rootViewController)
    }
    
    func showVC(_ vc: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
