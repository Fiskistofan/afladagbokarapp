// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import Firebase
import FirebaseAuth
import StokkurUtls

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: false)
        
        return controller
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupFireBase()
        setup()

        return true
    }
    
    func setup(){
        
        if UIDevice.current.iPhoneX{
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Fonts.System.bold.of(size: 13), NSAttributedStringKey.foregroundColor: Color.blue.value], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Fonts.System.bold.of(size: 13), NSAttributedStringKey.foregroundColor: Color.white.value], for: .selected)
        }
        else{
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Fonts.System.bold.of(size: 11), NSAttributedStringKey.foregroundColor: Color.blue.value], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: Fonts.System.bold.of(size: 11), NSAttributedStringKey.foregroundColor: Color.white.value], for: .selected)
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        self.appCoordinator = AppCoordinator(navigationController: navigationController)
        self.appCoordinator.start()
        
        Session.manager.configureLoadingIndicator()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Hætta"
    }
    
    func setupFireBase(){
        FirebaseApp.configure()
    }
    
    func logOut(){
        
        FireBaseManager.sharedInstance.logOut()
        Session.manager.logOut()
        self.appCoordinator.start()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

