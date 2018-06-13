//
//  PickerViewStyle.swift
//  PopUpController
//

import UIKit

public protocol PickerViewStyle: PopUpControllerStyle {
    var locale: Locale? { get set }
    var topBarStyle: SelectorViewTopBarStyle { get set }
}

public struct PickerViewStyleDefault: PickerViewStyle {
    public let backgroundColor: UIColor = UIColor(white: 0.1, alpha: 0.3)
    public let popupBackgroundColor = UIColor.white
    public var cornerRadius: CGFloat = 5.0
    
    public var locale: Locale? = Locale.current
    public var topBarStyle: SelectorViewTopBarStyle = SelectorViewTopBarStyleDefault()
    
    public init(){}
}
