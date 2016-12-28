//
//  ImageViewController.swift
//  Schwifty Chat
//
//  Created by louie on 12/23/16.
//  Copyright © 2016 louie. All rights reserved.
//

import UIKit
import Firebase

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

    @IBAction func backbutton(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
    }
    
    private func fetchImage() {
        if let url = imageURL?.absoluteString {
            spinner?.startAnimating()
            DispatchQueue.global().async(group: DispatchGroup.init(), qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags(rawValue: 0)) {
                
                if url.hasPrefix("gs://") {
                    FIRStorage.storage().reference(forURL: url).data(withMaxSize: INT64_MAX){ (data, error) in
                        if let error = error {
                            print("Error downloading: \(error)")
                            return
                        }
                        self.image = UIImage.init(data: data!)
                        
                    }
                } else if let URL = URL(string: url), let data = try? Data(contentsOf: URL) {
                    self.image = UIImage.init(data: data)
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
    
    public var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            //scrollView?.contentSize = imageView.frame.size
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


