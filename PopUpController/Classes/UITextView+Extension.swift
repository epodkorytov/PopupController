//
//  UITextView+Extension.swift
//  PopUpController
//


import UIKit

extension UITextView {
    
    private struct AssociatedKeys {
        static var ActionKey = "ActionKey"
        static var style: TextViewStyleProtocol? = nil
    }
    
    var style: TextViewStyleProtocol? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.style, newValue as TextViewStyleProtocol?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                font = newValue.textFont
                textColor = newValue.textColor
                backgroundColor = newValue.textViewBG
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.style) as? TextViewStyleProtocol
        }
    }
    
}
