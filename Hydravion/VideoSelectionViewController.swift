//
//  VideoSelectionViewController.swift
//  Hydravion
//
//  Created by bmlzootown on 2/9/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit

class VideoSelectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var videoCollection: UICollectionView!
    var creatorName = String()
    var videos:[Video] = []
    var videoInfo:[VideoInfo] = []
    
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
        //videoCollection.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
}
