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
        // UserDefaults let's us store things, sort of like Roku's registry
        let preferences = UserDefaults.standard
        
        // Check to see if cookies are found for Floatplane, and if not, remove stored urlSession from UserDefaults
        let cookieStorage = HTTPCookieStorage.shared
        let url = URL(string: "https://www.floatplane.com")
        let cookies = cookieStorage.cookies(for: url! as URL) ?? []
        if (cookies.count < 1) {
            print("[Hydravion] COOKIES NOT FOUND")
            if (preferences.object(forKey: "loggedIn") != nil) {
                preferences.removeObject(forKey: "loggedIn")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        } else {
            print("[Hydravion] COOKIES FOUND")
            preferences.set(true, forKey: "loggedIn")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "alreadyLoggedInSegue", sender: self)
            }
        }
    }
}
