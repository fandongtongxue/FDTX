//
//  AppDelegate.swift
//  FDTX
//
//  Created by fandong on 2017/8/3.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import XCGLogger
import ReachabilitySwift
import NightNight
import RealmSwift
import Realm

let realm = try! Realm()

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let log: XCGLogger = {
    // Setup XCGLogger
    let log = XCGLogger.default
    
    #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
        log.remove(destinationWithIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier)
        log.add(destination: AppleSystemLogDestination(identifier: XCGLogger.Constants.systemLogDestinationIdentifier))
        log.logAppDetails()
    #else
        let logPath: URL = appDelegate.cacheDirectory.appendingPathComponent("XCGLogger_Log.txt")
        
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
        
        // Add colour (using the ANSI format) to our file log, you can see the colour when `cat`ing or `tail`ing the file in Terminal on macOS
        // This is mostly useful when testing in the simulator, or if you have the app sending you log files remotely
        if let fileDestination: FileDestination = log.destination(withIdentifier: XCGLogger.Constants.fileDestinationIdentifier) as? FileDestination {
            let ansiColorLogFormatter: ANSIColorLogFormatter = ANSIColorLogFormatter()
            ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
            ansiColorLogFormatter.colorize(level: .debug, with: .black)
            ansiColorLogFormatter.colorize(level: .info, with: .blue, options: [.underline])
            ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
            ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
            ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)
            fileDestination.formatters = [ansiColorLogFormatter]
        }
        
        // Add colour to the console destination.
        // - Note: You need the XcodeColors Plug-in https://github.com/robbiehanson/XcodeColors installed in Xcode
        // - to see colours in the Xcode console. Plug-ins have been disabled in Xcode 8, so offically you can not see
        // - coloured logs in Xcode 8.
        //if let consoleDestination: ConsoleDestination = log.destination(withIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier) as? ConsoleDestination {
        //    let xcodeColorsLogFormatter: XcodeColorsLogFormatter = XcodeColorsLogFormatter()
        //    xcodeColorsLogFormatter.colorize(level: .verbose, with: .lightGrey)
        //    xcodeColorsLogFormatter.colorize(level: .debug, with: .darkGrey)
        //    xcodeColorsLogFormatter.colorize(level: .info, with: .blue)
        //    xcodeColorsLogFormatter.colorize(level: .warning, with: .orange)
        //    xcodeColorsLogFormatter.colorize(level: .error, with: .red)
        //    xcodeColorsLogFormatter.colorize(level: .severe, with: .white, on: .red)
        //    consoleDestination.formatters = [xcodeColorsLogFormatter]
        //}
    #endif
    
    // You can also change the labels for each log level, most useful for alternate languages, French, German etc, but Emoji's are more fun
    //    log.levelDescriptions[.verbose] = "🗯"
    //    log.levelDescriptions[.debug] = "🔹"
    //    log.levelDescriptions[.info] = "ℹ️"
    //    log.levelDescriptions[.warning] = "⚠️"
    //    log.levelDescriptions[.error] = "‼️"
    //    log.levelDescriptions[.severe] = "💣"
    
    // Alternatively, you can use emoji to highlight log levels (you probably just want to use one of these methods at a time).
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: " 🔹🔹🔹", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️‼️‼️", to: .error)
    emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
    
    log.formatters = [emojiLogFormatter]
    
    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        log.info("沙盒路径:\n"+NSHomeDirectory())
        //重置登录状态
        //Listen Network Status
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        let containerVC = ContainViewController.init(nibName: nil, bundle: nil)
        self.window = UIWindow.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.window?.rootViewController = containerVC
        return true
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

