//
//  AppDelegate.swift
//  FMDB演示_Swift
//
//  Created by langyue on 15/11/25.
//  Copyright © 2015年 langyue. All rights reserved.
//

import UIKit


let num1 : Int = 101
let num2 : Int = 102
let num3 : Int = 103

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        UINavigationBar.appearance().backgroundColor = UIColor.yellowColor()
        
        
        
        let tabbar = UITabBarController()
        
        
        let addressVC = BKAddressViewController()
        let addressNC = UINavigationController(rootViewController: addressVC)
        addressVC.title = "查看插入历史"
        addressNC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.History, tag: num1)
        
        
        
        
        let addUserVC = BKAddUserViewController()
        let addUserNC = UINavigationController(rootViewController: addUserVC)
        addUserVC.title  = "添加新信息"
        addUserNC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Bookmarks, tag: num2)
        
        
        
        let searchVC = MainTableViewController()
        let searchNC = UINavigationController(rootViewController: searchVC)
        searchVC.title  = "历史查询"
        searchNC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Search, tag: num3)
        
        
        
        tabbar.viewControllers = [addressNC,addUserNC,searchNC]
        
        self.window?.rootViewController = tabbar
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

