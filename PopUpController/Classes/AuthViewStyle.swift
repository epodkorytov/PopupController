//
//  AuthViewStyle.swift
//  PopUpController
//

import UIKit
import OCTextInput


public protocol AuthInputStyle: OCTextInputStyle {
    
    var inputHeight : CGFloat { get set }
    
}


public protocol AuthViewStyle: PopUpControllerStyle {
    var logoImageSize               : CGSize { get set }
    var horizontalSpacingRatio      : CGFloat { get set }
    var containerViewVerticalSpacing: CGFloat { get set }
    
    var primaryButtonStyle      : ButtonStyleProtocol { get set }
    var secondaryButtonStyle    : ButtonStyleProtocol { get set }
    var smallButtonStyle        : ButtonStyleProtocol { get set }
    
    var titleLabelStyle         : LabelStyleProtocol { get set }
    var smallLabelStyle         : LabelStyleProtocol { get set }
    var messageLabelStyle       : LabelStyleProtocol { get set }
    
    var textViewStyle           : TextViewStyleProtocol { get set }
    
    var inputStyle              : AuthInputStyle { get set }
}


public struct AuthViewStyleDefault: AuthViewStyle {
    public let backgroundColor = UIColor(white: 0.1, alpha: 0.3)
    public let popupBackgroundColor = UIColor.white
    public var cornerRadius: CGFloat = 0.0
    
    public var logoImageSize: CGSize = CGSize(width: 130.0, height: 40.0)
    public var horizontalSpacingRatio: CGFloat = 25.0
    public var containerViewVerticalSpacing: CGFloat = 20.0
    
    public var primaryButtonStyle: ButtonStyleProtocol = AuthButtonStyleDefault(.primary)
    public var secondaryButtonStyle: ButtonStyleProtocol = AuthButtonStyleDefault(.secondary)
    public var smallButtonStyle: ButtonStyleProtocol = AuthButtonStyleDefault(.small)
    
    public var titleLabelStyle: LabelStyleProtocol = AuthLabelStyleDefault(.title)
    public var smallLabelStyle: LabelStyleProtocol = AuthLabelStyleDefault(.small)
    public var messageLabelStyle: LabelStyleProtocol = AuthLabelStyleDefault(.message)
    
    public var textViewStyle: TextViewStyleProtocol = AuthTextViewStyleDefault()
    
    public var inputStyle: AuthInputStyle = TextInputStyle()
}


// MARK: - Elements styles

public struct AuthLabelStyleDefault: LabelStyleProtocol {
    enum LabelType {
        case small
        case title
        case message
    }

    public var textColor: UIColor
    public var textFont: UIFont
    
    init(_ type: LabelType) {
        switch type {
        case .small:
            textFont  = .systemFont(ofSize: 12.0)
            textColor = #colorLiteral(red: 0.9450980392, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
        case .title:
            textFont  = .systemFont(ofSize: 16.0)
            textColor = #colorLiteral(red: 0.9450980392, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
        case .message:
            textFont  = .systemFont(ofSize: 16.0)
            textColor = #colorLiteral(red: 0.9450980392, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
        }
    }
}


public struct AuthButtonStyleDefault: ButtonStyleProtocol {
    public var type: ButtonType
    
    public var backgroundColor: UIColor
    public var borderColor: UIColor?
    public var textColor: UIColor
    
    public var textFont: UIFont
    
    public var cornerRadius: CGFloat
    public var buttonHeight: CGFloat
    public var borderWidth: CGFloat
    
    
    init(_ type: ButtonType) {
        self.type = type
        
        buttonHeight = 58.0
        cornerRadius = self.buttonHeight / 2.0
        borderColor = nil
        borderWidth = 0.0
        
        switch type {
        case .primary:
            backgroundColor  = #colorLiteral(red: 1, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
            textColor = #colorLiteral(red: 0.8235294118, green: 0.01568627451, blue: 0.3568627451, alpha: 1)
            textFont = .systemFont(ofSize: 14.0)
        case .secondary:
            backgroundColor  = .clear
            textColor = #colorLiteral(red: 0.9058823529, green: 0.9215686275, blue: 0.9490196078, alpha: 1)
            borderColor = #colorLiteral(red: 0.9058823529, green: 0.9215686275, blue: 0.9490196078, alpha: 1)
            borderWidth = 1.0
            textFont = .systemFont(ofSize: 14.0)
        case .small:
            backgroundColor  = .clear
            textColor = #colorLiteral(red: 1, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
            textFont = .systemFont(ofSize: 12.0)
        }
    }
}

public struct AuthTextViewStyleDefault: TextViewStyleProtocol {
    public var textColor: UIColor    = #colorLiteral(red: 0.9450980392, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
    public var textFont: UIFont      = .systemFont(ofSize: 12.0)
    public var textViewBG: UIColor   = .clear
    
    init() {}
}


public struct TextInputStyle: AuthInputStyle {
    public let activeColor = UIColor.white
    public let inactiveColor = UIColor.white.withAlphaComponent(0.5)
    public let invisibleColor = UIColor.clear
    public let lineInactiveColor = UIColor.white.withAlphaComponent(0.2)
    public let errorColor = UIColor.red
    public let textInputFont = UIFont.systemFont(ofSize: 16)
    public let textInputFontColor = UIColor.white
    public let placeholderMinFontSize: CGFloat = 11
    public let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 11)
    public let marginInsets: UIEdgeInsets = UIEdgeInsets(top: 12.0, left: 20.0, bottom: 3.0, right: 0.0)
    public let yHintPositionOffset: CGFloat = 0
    public let yPlaceholderPositionOffset: CGFloat = 0
    public let counterRightMargin: CGFloat = 20
    
    public var inputHeight: CGFloat = 58.0
    
    public init() { }
}
