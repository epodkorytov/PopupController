//
//  PopUpController+ActivityIndicatorStyle.swift
//  PopUpController
//

import UIKit

public protocol ActivityIndicatorStyle: PopUpControllerStyle {
    var popupBackgroundSize: CGSize { get }
    var indicatorColor: UIColor { get }
}

public struct ActivityIndicatorStyleDefault: ActivityIndicatorStyle {
    public let backgroundColor = UIColor(white: 0.1, alpha: 0.3)
    public let popupBackgroundColor = UIColor.clear
    public var cornerRadius: CGFloat = 5.0
    
    public let popupBackgroundSize: CGSize = CGSize(width: 120.0, height: 120.0)
    public let indicatorColor: UIColor = .darkGray
    
    public init() {}
}
