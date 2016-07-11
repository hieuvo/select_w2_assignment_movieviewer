//
//  UICollectionViewCell.swift
//  MovieViewer
//
//  Created by hvmark on 7/11/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var cellIdentifier: String {
        let classString = NSStringFromClass(self)
        let components = classString.componentsSeparatedByString(".")
        assert(components.count > 0, "Failed extract class name from \(classString)")
        return components.last!
    }
    
    class func dequeueReusableCellFromCollectionView(collectionView: UICollectionView, forIndexPath indexPath: NSIndexPath) -> Self {
        return dequeueReusableCellFromCollectionView(collectionView, forIndexPath: indexPath, type: self)
    }
    
    private class func dequeueReusableCellFromCollectionView<T: UICollectionViewCell>(collectionView: UICollectionView, forIndexPath indexPath: NSIndexPath, type: T.Type) -> T {
        return collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! T
    }
}
