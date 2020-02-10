//
//  CollectionViewCell.swift
//  Hydravion
//
//  Created by bmlzootown on 2/9/20.
//  Copyright © 2020 bmlzootown. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    var path:String = ""
    var guid:String = ""
    
    func configureCell(video: Video) {
        if let title = video.title {
            videoTitle.text = title
        }
        if let thumbnail = video.thumbnail?.childImages![0].path {
            let url = URL(string: thumbnail)!
            DispatchQueue.main.async {
                let data = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    let img = UIImage(data: data! as Data)
                    self.thumbnail.image = img
                    self.thumbnail.layer.cornerRadius = 8.0
                    self.clipsToBounds = true
                }
            }
        }
        if let guid = video.guid {
            let url = "https://www.floatplane.com/api/video/url?guid=" + guid + "&quality=1080"
            self.path = url
            self.guid = guid
        }
    }
}
