//
//  NavigationController.swift
//  Hydravion
//
//  Created by bmlzootown on 2/9/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check to see if cookies are found for Floatplane
        // If found, go to MainView. If not, go to LoginView
        let cookieStorage = HTTPCookieStorage.shared
        let url = URL(string: "https://www.floatplane.com")
        let cookies = cookieStorage.cookies(for: url! as URL) ?? []
        if (cookies.count < 1) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                print("[Hydravion] Not logged in...")
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "alreadyLoggedInSegue", sender: self)
                print("[Hydravion] Already logged in...")
            }
        }
    }
    
    /*@IBAction func returnToStepOne(segue: UIStoryboardSegue) {
        //viewDidLoad()
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }*/
}
