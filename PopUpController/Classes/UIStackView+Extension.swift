//
//  UIStackView+Extension.swift
//  PopUpController
//

import UIKit

extension UIStackView {
    
    enum StackViewType {
        case horizontal
        case vertical
    }
    
    convenience init(withStackViewType type: StackViewType, spacing: CGFloat = 0.0) {
        self.init()
        switch type {
        case .horizontal:
            axis = .horizontal
        case .vertical:
            axis = .vertical
        }
        self.spacing = spacing
        distribution = .equalSpacing
        alignment = .center
    }
    
}
