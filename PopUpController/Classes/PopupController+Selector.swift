//
//  PopUpController+Selector.swift
//  PopUpController
//

import Foundation
import UIKit
import Extensions

public enum PopUpControllerSelectorType {
    case single
    case multiple
    case popup
}

extension PopUpController {
    private struct CustomProperties {
        static var selectorView: SelectorView!
        static var selectorViewStyle: SelectorViewStyle?
    }
    
    //
    public var selectorViewStyle: SelectorViewStyle {
        get {
            return getAssociatedObject(&CustomProperties.selectorViewStyle, defaultValue: CustomProperties.selectorViewStyle) ?? SelectorViewStyleDefault()
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.selectorViewStyle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //
    public var selectorView: SelectorView! {
        get {
            return getAssociatedObject(&CustomProperties.selectorView, defaultValue: CustomProperties.selectorView)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.selectorView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: - Presenter
    
    public func presentSelector(title: String,
                                type: PopUpControllerSelectorType,
                                mode: PopUpPresentMode = .centered,
                                dataSource: DataSource<DataSourceBaseItem>,
                                completeHandler: @escaping PopUpControllerCompleteHandler) {
        
        let onComplete: PopUpControllerCompleteHandler = { type, answer in
            switch type {
                case .accept:
                    self.hide {
                        completeHandler(type, answer)
                    }
                    break
                case .cancel:
                    self.hide {
                        completeHandler(type, answer)
                    }
                    break
                default :
                    break
            }
        }
        let selectedIds = dataSource.selectedIds
        self.didHidePopup = { type, answer in
            dataSource.selectedIds = selectedIds
            onComplete(type, answer)
        }
        self.style = selectorViewStyle as PopUpControllerStyle
        selectorView = SelectorView(dataSource: dataSource,
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
    }
}
