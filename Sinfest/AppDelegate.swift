//
//  AppDelegate.swift
//  Sinfest
//
//  Created by Jurjen van Dijk on 25/11/2019.
//  Copyright © 2019 frombeyond. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let notificationSinLoaded = NSNotification.Name(rawValue: "SinLoaded")
    public static let notificationLoadSins = NSNotification.Name(rawValue: "LoadSins")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ImageManager.shared.loadCurrentAndPrevious(50)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadImages),
                                               name: .notificationLoadSins,
                                               object: nil)
        //NotificationCenter.default.post(name: .notificationLoadSins, object: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    @objc func loadImages() {
        _ = ImageManager.shared.listImagesFromDisk(false)
    }

}
