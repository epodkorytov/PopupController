//
//  ButtonStyle.swift
//  PopUpController
//

import UIKit

public enum ButtonType {
    case primary
    case secondary
    case small
}

public protocol ButtonStyleProtocol {
    var type            : ButtonType { get set }
    
    var backgroundColor : UIColor { get set }
    var borderColor     : UIColor? { get set }
    var textColor       : UIColor { get set }
    
    var textFont        : UIFont { get set }
    
    var cornerRadius    : CGFloat { get set }
    var buttonHeight    : CGFloat { get set }
    var borderWidth     : CGFloat { get set }
}

