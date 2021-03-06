//
//  MovieDetailViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var detailViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstrain: NSLayoutConstraint!
    
    var movie: Movie?
    
    // Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie!.title
        overviewLabel.text = movie!.overview
        releaseDateLabel.text = movie!.releaseDate
        
        let thumbnail = TMDBClient.BaseImageW154Url + movie!.posterPath!
        let poster = TMDBClient.BaseImageWOriginalUrl + movie!.posterPath!
        posterView.setImageWithThumbnail(thumbnail, imageLink: poster)
        
        setScrollViewContentSize()
    }
    
    func setScrollViewContentSize() {
        
        overviewLabel.sizeToFit()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let detailViewHeight = overviewLabel.frame.origin.y + overviewLabel.bounds.height
        let contentViewHeight = screenSize.height + detailViewHeight - 200
        
//        detailViewHeightConstrain.constant = detailViewHeight
        contentViewHeightConstrain.constant = contentViewHeight
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        setScrollViewContentSize()
    }
}
