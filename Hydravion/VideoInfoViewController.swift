//
//  VideoInfoViewController.swift
//  Hydravion
//
//  Created by bmlzootown on 2/9/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoInfoViewController: UIViewController {
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDescription: UITextView!
    var videoInfo:[VideoInfo] = []

    override func viewWillAppear(_ animated: Bool) {
        videoTitle.text = videoInfo[0].title
        videoDescription.text = videoInfo[0].description
        //print(videoInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playButton(_ sender: UIButton) {
        let urlString = "https://www.floatplane.com/api/video/url?guid=" + videoInfo[0].guid! + "&quality=1080"
        getVideoUrl(videoUrl: urlString)
        
        //playVideo(url: url)
    }
    
    func getVideoUrl(videoUrl: String) {
        print("[Hydravion] GETing video stream url...")
        let session = URLSession.shared
        guard let url = URL(string: videoUrl) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    var str = String(decoding: data!, as: UTF8.self)
                    str = str.replacingOccurrences(of: "\"", with: "")
                    DispatchQueue.main.async {
                        let url = URL(string: str)
                        self.playVideo(url: url!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
}
