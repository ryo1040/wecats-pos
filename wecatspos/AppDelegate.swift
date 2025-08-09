//
//  AppDelegate.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1. ウィンドウ初期化
        window = UIWindow(frame: UIScreen.main.bounds)
        // 2. ルートビューコントローラ設定
        window?.rootViewController = MenuBuilder().build()
        // 3. ウィンドウ表示
        window?.makeKeyAndVisible()
        
        return true
    }

//    // iOS 13以降でSceneDelegateを使う場合はこちらのメソッドを削除
//    func applicationWillResignActive(_ application: UIApplication) {}
//    func applicationDidEnterBackground(_ application: UIApplication) {}
//    func applicationWillEnterForeground(_ application: UIApplication) {}
//    func applicationDidBecomeActive(_ application: UIApplication) {}
//    func applicationWillTerminate(_ application: UIApplication) {}
}


