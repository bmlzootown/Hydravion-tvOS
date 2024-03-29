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
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerViewController: AVPlayerViewController!
    
    private var playerItemContext = 0
    
    override func viewWillAppear(_ animated: Bool) {
        videoTitle.text = videoInfo[0].title
        videoDescription.text = videoInfo[0].description
        videoDescription.isUserInteractionEnabled = true
        videoDescription.isScrollEnabled = true
        videoDescription.isSelectable = true
        videoDescription.showsVerticalScrollIndicator = true
        videoDescription.bounces = true
        videoDescription.panGestureRecognizer.allowedTouchTypes = [NSNumber(value:UITouch.TouchType.indirect.rawValue)]
        //print(videoInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePlay(gesture:)))
        playRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        self.view.addGestureRecognizer(playRecognizer)
    }
    
    //Present user with stream quality options
    @objc func handlePlay(gesture: UITapGestureRecognizer) {
        let futureFeature = UIAlertController(title: "Uhoh!", message: "Selecting preferred resolution not currently supported. Currently defaults to 1080", preferredStyle: .alert)
        futureFeature.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: .default, handler: { _ in
            NSLog("Resolution Selection --> Not currently implemented...")
        }))
        
        let alert = UIAlertController(title: "Video Quality", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("1080", comment: ""), style: .default, handler: { _ in
            NSLog("1080 selected")
            self.present(futureFeature, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("720", comment: ""), style: .default, handler: { _ in
            NSLog("720 selected")
            self.present(futureFeature, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
                    NSLog(str)
                    DispatchQueue.main.async {
                        let url = URL(string: str)
                        self.playVideo(url: url!)
                    }
                }
            }
        }
        task.resume()
    }
    
    func closeVideo() {
        playerViewController.dismiss(animated: true, completion: nil)
    }
    
    func playVideo(url: URL) {
        playerItem = AVPlayerItem(url: url)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        player = AVPlayer(playerItem: playerItem)
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) { self.playerViewController.player?.play() }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
            // Player item is ready to play.
                return
            case .failed:
            // Player item failed. See error.
                print("[Hydravion] " + playerItem.error.debugDescription)
                closeVideo()
                return
            case .unknown:
                // Player item is not yet ready.
                return
            @unknown default:
                return
            }
        }
    }
}
