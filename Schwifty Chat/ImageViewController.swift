//
//  ImageViewController.swift
//  Schwifty Chat
//
//  Created by louie on 12/23/16.
//  Copyright © 2016 louie. All rights reserved.
//

import UIKit

@objc(ImageViewController)
class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global().async(group: DispatchGroup.init(), qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags(rawValue: 0)) {
                let loadedImageData = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = loadedImageData {
                            self.image = UIImage(data: imageData as Data)
                        } else {
                            self.spinner?.stopAnimating()
                        }
                    } else { NSLog("\(Error.downloadImage) + \(url)") }
                }
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private var scrollViewDidScrollOrZoom = false
    
    private func autoScale() {
        if scrollViewDidScrollOrZoom {
            return
        }
        if let sv = scrollView {
            if image != nil {
                sv.zoomScale = max(sv.bounds.size.height / image!.size.height,
                                   sv.bounds.size.width / image!.size.width)
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                                           y: (imageView.frame.size.height - sv.frame.size.height) / 2)
                scrollViewDidScrollOrZoom = false
            }
        }
    }
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            scrollViewDidScrollOrZoom = false
            autoScale()
        }
    }
    
    private struct Error {
        static let downloadImage = "Couldn't get the data from"
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoScale()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDidScrollOrZoom = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
}


