//
//  ViewController.swift
//  BackgroundExecution
//
//  Created by Jaeson Booker on 7/2/19.
//  Copyright © 2019 Jaeson Booker. All rights reserved.
//

import UIKit
import BackgroundTasks
import Dispatch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.apple.attachments")
        let session = URLSession(configuration: config, delegate: ..., delegateQueue: ...)
        
        config.isDiscretionary = true
        

        // Do any additional setup after loading the view.
    }
    
    func send(message: String) {
        let sendOperation = SendOperation(message: message)
        var identifier: UIBackgroundTaskIdentifier!
        identifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            sendOperation.cancel()
            postUserNotification("Message didn't send! :(")
        })
        sendOperation.completionBlock = {
            UIApplication.shared.endBackgroundTask(identifier)
        }
        OperationQueue.addOperation(sendOperation)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
