//
//  UILabel+Extension.swift
//  PopUpController
//

import UIKit

extension UILabel {
    
    convenience init(style: LabelStyleProtocol) {
        self.init()
        
        setStyle(style)
    }

    
    func setStyle(_ style: LabelStyleProtocol) {
        font = style.textFont
        textColor = style.textColor
    }

    
    func setTitle(_ title: String?, withLineSpacing spacing:CGFloat) {
        let stringValue = title ?? ""
        let attrString = NSMutableAttributedString(string: stringValue)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style,
                                range: NSRange(location: 0, length: stringValue.count))
        attributedText = attrString
    }
    
}
