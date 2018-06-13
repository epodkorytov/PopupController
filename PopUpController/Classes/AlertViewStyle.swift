//
//  PopUpController+AlertViewStyle.swift
//  PopUpController
//

import UIKit

public protocol AlertViewStyle: PopUpControllerStyle {
    var borderColor: UIColor { get }
    
    var padding: UIEdgeInsets { get }
    
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    
    var textFont: UIFont { get }
    var textColor: UIColor { get }
    
    var buttonFont: UIFont { get }
    var buttonColor: UIColor { get }
    
    var buttonDefaultFont: UIFont { get }
    var buttonDefaultColor: UIColor { get }
    
    var width: CGFloat { get }
    var minHieght: CGFloat { get }
    var maxHieght: CGFloat { get }
    
    var imageSize: CGFloat { get }
    
    var splashTime: TimeInterval { get }
}

public struct AlertViewStyleDefault: AlertViewStyle {
    public let backgroundColor = UIColor(white: 0.1, alpha: 0.3)
    public let popupBackgroundColor = UIColor.white
    public var cornerRadius: CGFloat = 5.0
    
    public let borderColor: UIColor = .clear
    
    public let padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 12, bottom: -16, right: -12)
    
    public let titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
    public let titleColor: UIColor = .blue
    
    public let textFont: UIFont = UIFont.systemFont(ofSize: 16)
    public let textColor: UIColor = .black
    
    public let buttonFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
    public let buttonColor: UIColor = .darkGray
    public let buttonDefaultFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
    public let buttonDefaultColor: UIColor = .red
    
    public let width: CGFloat = 280.0
    public let minHieght: CGFloat = 44.0
    public let maxHieght: CGFloat = 380.0
    
    public let imageSize: CGFloat = 44.0
    
    public let splashTime: TimeInterval = 3.0
    
    public init(){}
}
