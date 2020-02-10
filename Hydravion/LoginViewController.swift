//
//  LoginViewController.swift
//  Hydravion
//
//  Created by bmlzootown on 2/6/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var failed: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        failed.isHidden = true
    }

    @IBAction func loginButton(_ sender: Any) {
        if (username.text! != "" && password.text! != "") {
            print("[Hydravion] login button pressed")
            doLogin()
        } else {
            failed.isHidden = false
        }
    }
    
    func doLogin() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.floatplane.com/api/auth/login")! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = ["username": String(username.text!), "password": String(password.text!)] as Dictionary<String, String>
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(String(describing: response))")
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Body: \(String(describing: strData))")
            
            var err: NSError?
            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                print(err!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(String(describing: jsonStr))'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    let success = (parseJSON["needs2FA"] != nil)
                    if (success) {
                        if ((parseJSON["needs2FA"] as? Bool)!) {
                            print("[Hydravion] 2FA found!")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "twoFASegue", sender: self)
                            }
                        } else {
                            //let preferences = UserDefaults.standard
                            //preferences.set(true, forKey: "loggedIn")
                            print("[Hydravion] LOGGED IN!")
                            //let cookieName = "sails.sid"
                            //if let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName }) {
                            //    print("\(cookieName): \(cookie.value)")
                            //}
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "loggedInSegue", sender: self)
                            }
                        }
                    } else {
                        print("[Hydravion] NOT logged in!")
                        self.failed.isHidden = false
                    }
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: \(String(describing: jsonStr))")
                    self.failed.isHidden = false
                }
            }
        })
        
        task.resume()
    }
    
    func storeCookies(_ cookies: [HTTPCookie], forURL url: URL) {
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.setCookies(cookies,
                                 for: url,
                                 mainDocumentURL: nil)
    }

}
