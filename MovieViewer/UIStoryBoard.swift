//
//  UIStoryBoard.swift
//  MovieViewer
//
//  Created by hvmark on 7/10/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard! {
        guard let mainStoryboardName = NSBundle.mainBundle().infoDictionary?["UIMainStoryboardFile"] as? String else {
            assertionFailure("No UIMainStoryboardFile found in main bundle")
            return nil
        }
        
        return UIStoryboard(name: mainStoryboardName, bundle: NSBundle.mainBundle())
    }
}
