//
//  PopUpController+AlertView.swift
//  PopUpController
//

import UIKit

public enum AlertViewType {
    case splash
    case messageBox
    case signIn, signUp, recovery, smsCode, newPassword
}

public protocol AlertViewButtonProtocol: UIButtonTypeProtocol {
    var isDefault: Bool { get set }
}

public class AlertViewButton: AlertViewButtonProtocol {
    public var title: String
    public var answerType : UIButtonAnswerType
    public var isDefault: Bool
    
    public init(title: String, answerType : UIButtonAnswerType, isDefault: Bool = false) {
        self.title = title
        self.answerType = answerType
        self.isDefault = isDefault
    }
}

extension PopUpController {
    
    private struct CustomProperties {
        static var alertView: AlertView!
        static var alertViewStyle: AlertViewStyle = AlertViewStyleDefault()
    }
    
    //
    public var alertViewStyle: AlertViewStyle {
        get {
            return getAssociatedObject(&CustomProperties.alertViewStyle, defaultValue: CustomProperties.alertViewStyle)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.alertViewStyle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //
    public var alertView: AlertView! {
        get {
            return getAssociatedObject(&CustomProperties.alertView, defaultValue: CustomProperties.alertView)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.alertView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: - Presenter
    public func presentAlertView(image: UIImage?,
                                 title: String?,
                                 text: String!,
                                 buttons: [AlertViewButtonProtocol],
                                 completeHandler: @escaping PopUpControllerAnswer) {
        let onComplete: PopUpControllerAnswer = { type in
            self.hide {
                completeHandler(type)
            }
        }
        self.style = alertViewStyle
        alertView = AlertView( image: image,
                               title: title,
                                text: text,
                                buttons: buttons,
                                type: .messageBox,
                                style: alertViewStyle,
                                completeHandler: onComplete,
                                didCreate: { view in
                                    self.present(view, mode: .centered, hideOnTouch: true)
        })
        
    }
    
    public func presentSplashMessage( text: String! ) {
        self.style = alertViewStyle
        alertView = AlertView( image: nil,
                               title: "",
                                text: text,
                                buttons: nil,
                                type: .splash,
                                style: alertViewStyle,
                                completeHandler: { _ in },
                                didCreate: { view in
                                    self.present(view, mode: .centered, hideOnTouch: true)
                                    self.hide(self.alertViewStyle.splashTime, { })
        })
    }
}
