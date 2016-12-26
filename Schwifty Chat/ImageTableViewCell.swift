//
//  ImageTableViewCell.swift
//  Schwifty Chat
//
//  Created by louie on 12/26/16.
//  Copyright © 2016 louie. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageUrl: NSURL? { didSet {updateUI() } }
    
    private func updateUI() {
        if let url = imageUrl {
            spinner?.startAnimating()
            
            // NSData(contentsOfURL:) blocks the thread it is called from when invoked with a network url.
            // Thus we cannot call it from the main thread.
            DispatchQueue.global().async(group: DispatchGroup.init(), qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags(rawValue: 0)) {
                let loadedImageData = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if url == self.imageUrl {
                        if let imageData = loadedImageData {
                            self.tweetImage?.image = UIImage(data: imageData as Data)
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
}


