//
//  UITableViewCell.swift
//  MovieViewer
//
//  Created by hvmark on 7/11/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var cellIdentifier: String {
        let classString = NSStringFromClass(self)
        let components = classString.componentsSeparatedByString(".")
        assert(components.count > 0, "Failed extract class name from \(classString)")
        return components.last!
    }
    
    class func dequeueReusableCellFromTableView(tableView: UITableView, forIndexPath indexPath: NSIndexPath) -> Self {
        return dequeueReusableCellFromTableView(tableView, forIndexPath: indexPath, type: self)
    }
    
    private class func dequeueReusableCellFromTableView<T: UITableViewCell>(tableView: UITableView, forIndexPath indexPath: NSIndexPath, type: T.Type) -> T {
        return tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! T
    }
}
