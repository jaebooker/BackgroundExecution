//
//  AppDelegate.swift
//  BackgroundExecution
//
//  Created by Jaeson Booker on 7/2/19.
//  Copyright © 2019 Jaeson Booker. All rights reserved.
//

import UIKit
import BackgroundTasks
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.jaeson.background", using: nil) { (task) in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.jaeson.backgroundtwo", using: nil) { (task) in
//            self.handleDatabaseCleaning(task: task as! BGProcessingTask) //downcast
//        }
        return true
    }
    //handles going into the background
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "itemstring")
        //won't refresh until 15 minutes later
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 68)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not scheduel app refresh ): \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh() //refreshes throughout the day
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let context = PersistentContainer.shared.newBackgroundContext()
        let operations = Operations.getOperationsToFetchLatestEntries(using: context, server: server)
        //if out of time, cancel operations in background
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        let lastOperation = operations.last!
        lastOperation.completionBlock = {
            task.setTaskCompleted(success: !lastOperation.isCancelled)
        }
        queue.addOperation(operations, waitUntilFinished: false)
    }

//    func handleDatabaseCleaning(task: BGProcessingTask) {
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        let context = PersistentContainer.shared.newBackgroundContext()
//        let predicate = NSPredicate(format: "timestamp < %@", NSData(timeIntervalSinceNow: -24 * 60 * 68))
//        let clearDatabaseOperation = DeleteFeedEntriesOperation(context: context, predicate: predicate)
//        //if out of time, cancel operations in background
//        task.expirationHandler = {
//            queue.cancelAllOperations()
//        }
//        cleanDatabaseOperation.completionBlock = {
//            let success = !cleanDatabaseOperation.isCancelled
//            if success {
//                //update last cleanup date to current time
//                PersistentContainer.shared.lastCleaned = Data[]
//            }
//            task.setTaskCompleted(success: success)
//        }
//        queue.addOperation(cleanDatabaseOperation)
//    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

