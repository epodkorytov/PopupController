//
//  PopUpController+SelectorIntegerNumbers.swift
//  PopUpController
//


import UIKit
import Extensions

extension PopUpController {
    public func presentSelectorIntegerNumbers(title: String,
                                              type: PopUpControllerSelectorType = .single,
                                              mode: PopUpPresentMode = .centered,
                                              range: Range<Int>,
                                              selectedValue: Int? = nil,
                                              completeHandler: @escaping PopUpControllerCompleteHandler) -> SelectorView {
        let onComplete: PopUpControllerCompleteHandler = { type, answer in
            switch type {
                case .accept:
                    self.hide {
                        guard let selectedIndex = (answer as? [Int])?.first else {
                            fatalError()
                        }
                        let minValue = range.lowerBound
                        let newSelectedValue = minValue + selectedIndex
                        completeHandler(type, newSelectedValue)
                    }
                    break
                case .cancel:
                    self.hide {}
                    break
                default : break
            }
        }
        
        
        
        
        self.style = selectorViewStyle
        selectorView = SelectorView(dataSource: DataSource(with: range, selectedValue: selectedValue),
                                    presentationMode: mode,
                                    style: selectorViewStyle,
                                    completeHandler: onComplete)
        { view in
            self.present(view,
                         mode: mode,
                         hideOnTouch: true)
        }
        
        selectorView.title = title
        selectorView.type = type
        
        return selectorView
    }
}
