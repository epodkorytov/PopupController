//
//  PopUpController+AuthView.swift
//  PopUpController
//

import UIKit

extension PopUpController {
    
    private struct CustomProperties {
        static var authView: AuthView!
        static var authViewStyle: AuthViewStyle = AuthViewStyleDefault()
        static var authViewContent: AuthViewContentProtocol = AuthViewContentDefault()
    }
    
    //
    public var authViewStyle: AuthViewStyle {
        get {
            return getAssociatedObject(&CustomProperties.authViewStyle, defaultValue: CustomProperties.authViewStyle)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.authViewStyle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //
    public var authViewContent: AuthViewContentProtocol {
        get {
            return getAssociatedObject(&CustomProperties.authViewContent, defaultValue: CustomProperties.authViewContent)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.authViewContent, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //
    public var authView: AuthView! {
        get {
            return getAssociatedObject(&CustomProperties.authView, defaultValue: CustomProperties.authView)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.authView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    //MARK: - Presenter
    public func presentAuthView(backgroundImage: UIImage?,
                                logoImage: UIImage,
                                type: AlertViewType,
                                login: String? = nil,
                                completeHandler: @escaping PopUpControllerAnswer) {
        authView = AuthView(bgImage: backgroundImage,
                            logoImage: logoImage,
                            type: type,
                            content: authViewContent,
                            style: authViewStyle,
                            login: login,
                            completeHandler: completeHandler)
        { view in
            self.present(view,
                         mode: .fullScreen,
                         hideOnTouch: false)
        }
    }
    
    
    public func authView(showMessage message: String) {
        authView.showMessage(message)
    }
}
