//
//  MainViewController.swift
//  Hydravion
//
//  Created by bmlzootown on 2/5/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var subscriptions:[Subscription] = []
    var videos:[Video] = []
    var selected:Int = 0
    var selectedGuid:String = ""
    var selectedCreator:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController = self
        //UIApplication.shared.keyWindow?.rootViewController = self
        getSubscriptions()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector(("handleMenuPress:")))
        let number = NSNumber(value: UIPress.PressType.menu.rawValue)
        tapRecognizer.allowedPressTypes = [number]
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "creatorSelectedSegue" {
            let destination = segue.destination as? VideoSelectionViewController
            destination?.videos = videos
            destination?.creatorName = selectedCreator
        }
    }
    
    func handleMenuPress(recognizer: UITapGestureRecognizer) {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let title = self.subscriptions[indexPath.row].plan!.title!
        cell.textLabel?.text = "\(title)"
        
        return cell
    }
    
    // Subscription was selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.subscriptions[indexPath.row].plan!.title!)
        tableView.deselectRow(at: indexPath, animated: true)
        self.selected = indexPath.row
        self.selectedGuid = subscriptions[indexPath.row].creator!
        self.selectedCreator = (subscriptions[indexPath.row].plan?.title)!
        getVideos()
    }
    
    func getSubscriptions() {
        print("[Hydravion] GETing subscriptions...")
        let session = URLSession.shared
        guard let url = URL(string: "https://www.floatplane.com/api/user/subscriptions") else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse)
                guard jsonResponse is [[String: Any]] else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let subscriptions = try decoder.decode([Subscription].self, from: data!)
                    self.subscriptions = subscriptions
                    DispatchQueue.main.async {
                        print("Reloading tableView")
                        self.tableView.reloadData()
                    }
                } catch { print(error) }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func getVideos() {
        print("[Hydravion] GETing videos...")
        let session = URLSession.shared
        let urlString = "https://www.floatplane.com/api/creator/videos?creatorGUID=" + self.selectedGuid
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse)
                guard jsonResponse is [[String: Any]] else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let videos = try decoder.decode([Video].self, from: data!)
                    DispatchQueue.main.async {
                        self.videos = videos
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "creatorSelectedSegue", sender: self)
                        }
                    }
                } catch { print(error) }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
