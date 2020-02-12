//
//  TwoFAViewController.swift
//  Hydravion
//
//  Created by bmlzootown on 2/9/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit

class TwoFAViewController: UIViewController {
    @IBOutlet weak var twoFACode: UITextField!
    @IBOutlet weak var incorrectCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectCode.isHidden = true
    }

    @IBAction func doLogin(_ sender: UIButton) {
        if (!twoFACode.text!.isEmpty) {
            // User gave 2FA code, let's see if it works
            getTwoFA()
        } else {
            // User didn't provide 2FA code, so let's show incorrect code label
            incorrectCode.isHidden = false
        }
    }
    
    func getTwoFA() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.floatplane.com/api/auth/checkFor2faLogin")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        // Prepare 2FA token for sending to server
        let params = ["token": String(twoFACode.text!)] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loggedInSegue", sender: self)
                        // 2FA was successful, so let's go back to NavigationView --> which will redirect us to MainView
                    }
                } else {
                    // 2FA failed, show incorrect code label; Note - User can always try again.
                    self.incorrectCode.isHidden = false
                }
            }
        })
        
        task.resume()
    }
    

}
