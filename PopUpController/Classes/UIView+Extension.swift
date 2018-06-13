//
//  UIView+Extension.swift
//  PopUpController
//


import UIKit

extension UIView {
    
    static let ACTIVITY_VIEW_CODE = 123
    
    func showActivityIndicator() {
        if let activity = viewWithTag(UIView.ACTIVITY_VIEW_CODE) as? UIActivityIndicatorView {
            activity.startAnimating()
        } else {
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activity.hidesWhenStopped = true
            activity.startAnimating()
            activity.tag = UIButton.ACTIVITY_VIEW_CODE
            addSubview(activity)
            _ = Constants.constraintFor(activity, attribute: .centerX, toView: self)
            _ = Constants.constraintFor(activity, attribute: .centerY, toView: self)
        }
    }
    
    
    func hideActivityIndicator() {
        if let activity = viewWithTag(UIButton.ACTIVITY_VIEW_CODE) as? UIActivityIndicatorView {
            activity.stopAnimating()
        }
    }
}
