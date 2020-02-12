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
        //Hide failed label until we need it
        failed.isHidden = true
        let cookieStorage = HTTPCookieStorage.shared
        let url = URL(string: "https://www.floatplane.com")
        let cookies = cookieStorage.cookies(for: url! as URL) ?? []
        if (cookies.count > 0) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loggedInSegue", sender: self)
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        if gesture.state == UIGestureRecognizer.State.ended {
            let app = UIApplication.shared
            app.perform(#selector(NSXPCConnection.suspend))
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        if (username.text! != "" && password.text! != "") {
            //print("[Hydravion] login button pressed")
            // User has provided username/pass, so let's try to login
            doLogin()
        } else {
            // User didn't provide enough info, show failed label
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
            
            if(err != nil) {
                print(err!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(String(describing: jsonStr))'")
            }
            else {
                if let parseJSON = json {
                    // Json parsed, double check to see if login was successful (should return needs2FA as either true or false if so)
                    let success = (parseJSON["needs2FA"] != nil)
                    if (success) {
                        if ((parseJSON["needs2FA"] as? Bool)!) {
                            print("[Hydravion] 2FA found!")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "twoFASegue", sender: self)
                            }
                        } else {
                            print("[Hydravion] LOGGED IN!")
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
                    // Something went wrong
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
        cookieStorage.setCookies(cookies, for: url, mainDocumentURL: nil)
    }

}
