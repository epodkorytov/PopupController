//
//  PinViewStyle.swift
//  PopUpController
//
import UIKit

public protocol PinViewStyle: PopUpControllerStyle {
    // COLOR PALLETE
    var buttonBGColor           : UIColor { get set }
    var buttonBGColorHigh       : UIColor { get set }
    var buttonBorderColor       : UIColor { get set }
    var buttonTextColor         : UIColor { get set }
    var buttonTextColorHigh     : UIColor { get set }
    var titleTextColor          : UIColor { get set }
    var errorTextColor          : UIColor { get set }
    var dotColor                : UIColor { get set }
    
    // FRAME VALUE ATTRIBUTES
    var buttonSize              : CGSize { get set }
    var dotSize                 : CGSize { get set }
    var buttonBorderWidth       : CGFloat { get set }
    var horizontalSpacing       : CGFloat { get set }
    var verticalSpacing         : CGFloat { get set }
    
    // FONTS
    var buttonNumberFont        : UIFont { get set }
    var titleLabelFont          : UIFont { get set }
    var errorLabelFont          : UIFont { get set }
    
    // CONDITIONS & VALUES
    var passcodeLength          : Int { get set }
}


public struct PinViewStyleDefault: PinViewStyle {
    public let backgroundColor: UIColor = .white
    public let popupBackgroundColor: UIColor = .white
    public var cornerRadius: CGFloat = 5.0
    
    public var buttonBGColor: UIColor        = .clear
    public var buttonBGColorHigh: UIColor    = #colorLiteral(red: 0.8235294118, green: 0.01568627451, blue: 0.3568627451, alpha: 1)
    public var buttonBorderColor: UIColor    = #colorLiteral(red: 0.7176470588, green: 0.8039215686, blue: 0.8705882353, alpha: 1)
    public var buttonTextColor: UIColor      = #colorLiteral(red: 0.1921568627, green: 0.2705882353, blue: 0.3215686275, alpha: 1)
    public var buttonTextColorHigh: UIColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var titleTextColor: UIColor       = #colorLiteral(red: 0.1921568627, green: 0.2705882353, blue: 0.3215686275, alpha: 1)
    public var errorTextColor: UIColor       = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    public var dotColor: UIColor             = #colorLiteral(red: 0.7176470588, green: 0.8039215686, blue: 0.8705882353, alpha: 1)
    
    public var buttonSize: CGSize           = CGSize(width: 66.0, height: 66.0)
    public var dotSize: CGSize              = CGSize(width: 11.0, height: 11.0)
    public var horizontalSpacing: CGFloat   = 25.0
    public var verticalSpacing: CGFloat     = 12.5
    public var buttonBorderWidth: CGFloat   = 1.0
    
    public var buttonNumberFont: UIFont = .systemFont(ofSize: 66.0 / 2.0)
    public var titleLabelFont: UIFont   = .boldSystemFont(ofSize: 18.0)
    public var errorLabelFont: UIFont   = .systemFont(ofSize: 18.0)
    
    public var passcodeLength: Int = 4
    
    public init(){}
}

