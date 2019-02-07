//
//  AppDelegate.swift
//  KeepYourMind
//
//  Created by Yuki Nagashima on 2019/01/01.
//  Copyright © 2019 yuki-n.inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //------------- 2018/1/23 追加----------------//
        print("AppDelegate/WillResignActive/アプリ閉じる前に起動")
        print(dayArray)
        let udDay = UserDefaults.standard
        udDay.set(dayArray, forKey: "selectedDay")
        udDay.synchronize()
        //------------- 2018/1/23 追加----------------//
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //------------- 2018/1/23 追加----------------//
        let udDay2 = UserDefaults.standard
        let input = udDay2.object(forKey: "selectedDay")
        //------------- 2018/1/23 追加----------------//
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    
}

