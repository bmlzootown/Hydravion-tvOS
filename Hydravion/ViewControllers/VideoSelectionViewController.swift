//
//  VideoSelectionViewController.swift
//  Hydravion
//
//  Created by bmlzootown on 2/9/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import RegEx

class VideoSelectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var videoCollection: UICollectionView!
    var creatorName = String()
    var videos:[Video] = []
    var videoInfo:[VideoInfo] = []
    var player:AVPlayer!
    var vc:AVPlayerViewController!
    @IBOutlet weak var playButtonView: UIView!
    fileprivate var myContext = 0
    
    //350,200
    let defaultSize = CGSize(width: 350, height: 200)
    let focusSize = CGSize(width: 385, height: 220)
    
    override func viewWillAppear(_ animated: Bool) {
        creator.text = creatorName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoCollection.delegate = self
        videoCollection.dataSource = self
        
        let playRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePlay(gesture:)))
        playRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        self.view.addGestureRecognizer(playRecognizer)
        
        playButtonView.layer.cornerRadius = 8.0
        playButtonView.clipsToBounds = true
    }
    
    deinit {
        self.removeObserver()
    }
    
    //Live button clicked, ask if user wants to try and stream
    @objc func handlePlay(gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Live Stream", message: "Attempt to play live stream?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Attempt to play live stream."), style: .default, handler: { _ in
            print(self.videos[0].creator!)
            self.getLiveUrlStream(creatorGUID: self.videos[0].creator!)
            NSLog("The \"OK\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Go back to video selection view."), style: .default, handler: { _ in
            NSLog("The \"Cancel\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "videoInfoSegue" {
            let destination = segue.destination as? VideoInfoViewController
            destination?.videoInfo = self.videoInfo
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = videoCollection.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
            let video = videos[indexPath.row]
            cell.configureCell(video: video)
            cell.layer.cornerRadius = 8
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let prev = context.previouslyFocusedView as? CollectionViewCell {
            UIView.animate(withDuration: 0.1) {
                prev.layer.backgroundColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.0)
            }
        }
        
        if let next = context.nextFocusedView as? CollectionViewCell {
            UIView.animate(withDuration: 0.1) {
                next.layer.backgroundColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
            }
        }
    }
    
    //Video Selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("[Hydravion] GETing video info...")
        let video = videos[indexPath.row]
        let session = URLSession.shared
        let urlString = "https://www.floatplane.com/api/video/info?videoGUID=" + video.guid!
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                var videosInfo:[VideoInfo] = []
                let videoInfo = try decoder.decode(VideoInfo.self, from: data!)
                //let videoInfo = try decoder.decode([VideoInfo].self, from: data!)
                videosInfo.append(videoInfo)
                DispatchQueue.main.async {
                    self.videoInfo = videosInfo
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "videoInfoSegue", sender: self)
                    }
                }
            } catch { print(error) }
        }
        task.resume()
    }
    
    func getLiveUrlStream(creatorGUID: String) {
        print("[Hydravion] GETing live stream url...")
        let session = URLSession.shared
        let urlString = "https://www.floatplane.com/api/cdn/delivery?type=live&creator=" + creatorGUID
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                let decoder = JSONDecoder()
                let liveInfo = try decoder.decode(LiveCDN.self, from: data!)
                var streamUrl = ""
                let cdn = liveInfo.cdn
                var uri = liveInfo.resource?.uri
                if liveInfo.resource?.resourceData != nil {
                    //let regex = try RegEx(pattern: "\\{(.*?)\\}")
                    let regex = try RegEx(pattern: "(?<=\\{).+?(?=\\})")
                    let matches = regex.matches(in: uri!)
                    matches.forEach { match in
                        let id = "{" + match.values[0]! + "}"
                        let with:String = (liveInfo.resource?.resourceData![String(id)])!
                        uri = uri!.replacingOccurrences(of: id, with: with)
                    }
                }
                streamUrl = cdn! + uri!
                //print (streamUrl)
                DispatchQueue.main.async {
                    let url = URL(string: streamUrl)
                    self.playVideo(url: url!)
                }
            } catch { print(error) }
        }
        task.resume()
    }
    
    func playVideo(url: URL) {
        player = AVPlayer(url: url)
        vc = AVPlayerViewController()
        //self.addObserver()
        vc.player = player
        self.present(vc, animated: true) { self.vc.player?.play() }
    }
    
    func addObserver() {
        if let aPlayerItem = self.player {
            NotificationCenter.default.addObserver(self,
                selector: #selector(self.itemDidFailedPlayingToEnd(_:)),
                name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
                object: aPlayerItem)
            
            NotificationCenter.default.addObserver(self,
                selector: #selector(self.itemDidStall(_:)),
                name: NSNotification.Name.AVPlayerItemPlaybackStalled,
                object: aPlayerItem)
        }
        
        if let aPlayer = self.player {
            aPlayer.addObserver(self, forKeyPath: "rate", options: .new, context: &myContext)
            aPlayer.addObserver(self, forKeyPath: "status", options: .new, context: &myContext)
        }
        
    }
    
    func removeObserver() {
        if let aPlayer = self.player {
            //aPlayer.removeObserver(self,forKeyPath:"rate")
            //aPlayer.removeObserver(self,forKeyPath:"status")
            //NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func itemDidFailedPlayingToEnd(_ notification: Notification) {
        print("AVPlayer failed playing to the end stream")
    }
    
    @objc func itemDidStall(_ notification: Notification) {
        print("AVPlayer got stalled stream url")
    }
    

}
