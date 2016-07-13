//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import SteviaLayout
import MGSwipeTableCell

class MovieCell: MGSwipeTableCell {
    
    var titleLabel = UILabel()
    var overviewLabel = UILabel()
    var posterView = UIImageView()
    var rightView = UIView()
    var favImage = UIImageView()
    
    var movie: Movie? = nil
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sv(
            posterView,
            rightView.sv(
                favImage,
                titleLabel,
                overviewLabel
            )
        )
        
        favImage.size(20)

        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .Left
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        
        overviewLabel.numberOfLines = 0
        overviewLabel.sizeToFit()
        overviewLabel.textAlignment = .Left
        overviewLabel.font = overviewLabel.font.fontWithSize(15)
        overviewLabel.height(100)
        
        posterView.layer.cornerRadius = 5
        posterView.clipsToBounds = true
        
        layout(
            10,
            |-10-posterView-5-rightView-|
        )
        
        rightView.layout(
            0,
            |-favImage|,
            |-5-titleLabel-|,
            |-5-overviewLabel-|,
            5
        )
        
        posterView.width(100).height(130)
        posterView.contentMode = .ScaleAspectFill
    }
  
    override func awakeFromNib() {
        print("awake from nib")
        super.awakeFromNib()
    }
    
    func injected() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.injected()
    }
    
    func loadContentFromMovieData() {
        if let movie = movie {
            titleLabel.text = movie.title!
            overviewLabel.text = movie.overview
            
            guard (movie.posterPath != nil) else { return }
            
            let posterUrl = NSURL(string: TMDBClient.BaseImageW154Url + movie.posterPath!)
            let request = NSURLRequest(URL: posterUrl!)
            posterView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
                
                // image come frome cache
                if response == nil {
                    self.posterView.image = image
                    // image come frome network
                } else {
                    self.posterView.setImageWithFadeIn(image)
                }
                }, failure: { (request, response, error) in
                    debugPrint(error.localizedDescription)
            })
            
            setupRightButtons()
        }
    }
    
    func setupFavorite() {
        if movie != nil && movie!.isFavorited {
            favImage.image = UIImage(named: "favorited")
        } else {
            favImage.image = UIImage(named: "favorite")
        }
    }
    
    func setupRightButtons() {
        rightButtons.removeAll()
        
        let shareButton = MGSwipeButton(title: "Share",backgroundColor: UIColor.lightGrayColor())
        shareButton.accessibilityIdentifier = "Share"
        rightButtons = [shareButton]
        
        if movie!.isFavorited == false {
            let favButton = MGSwipeButton(title: "Favorite", backgroundColor: UIColor.redColor())
            favButton.accessibilityIdentifier = "Favorite"
            rightButtons.append(favButton)
        }
        
        rightSwipeSettings.transition = MGSwipeTransition.Static
    }
    
    func setData(movie: Movie) {
        self.movie = movie
        loadContentFromMovieData()
        setTheme()
    }
    
    func setTheme() { 
        titleLabel.textColor = UIColor.whiteColor()
        overviewLabel.textColor = UIColor.whiteColor()
        
        // clear cell background to get rid of WHITE background by default
        backgroundColor = UIColor.clearColor()
        // config cell selected background
        let customSelectionView = UIView(frame: frame)
        customSelectionView.backgroundColor = themeColor
        selectedBackgroundView = customSelectionView
    }
    
    func didFavorite() {
        movie?.isFavorited = true
        favImage.image = UIImage(named: "favorited")
    }
}
