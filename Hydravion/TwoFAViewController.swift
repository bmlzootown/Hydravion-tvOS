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
            getTwoFA()
        } else {
            incorrectCode.isHidden = false
        }
    }
    
    func getTwoFA() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.floatplane.com/api/auth/checkFor2faLogin")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["token": String(twoFACode.text!)] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loggedInSegue", sender: self)
                    }
                } else {
                    self.incorrectCode.isHidden = false
                }
            }
        })
        
        task.resume()
    }
    

}
