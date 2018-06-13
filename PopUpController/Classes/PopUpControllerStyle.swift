//
//  PopUpControllerStyle.swift
//  PopUpController
//

import UIKit

public protocol PopUpControllerStyle {
    var backgroundColor: UIColor { get }
    var popupBackgroundColor: UIColor { get }
    var cornerRadius: CGFloat { get }
}

public struct PopUpControllerStyleDefault: PopUpControllerStyle {
    public let backgroundColor = UIColor(white: 0.1, alpha: 0.3)
    public let popupBackgroundColor = UIColor(white: 0.98, alpha: 1.0)
    public var cornerRadius: CGFloat = 5.0
}

