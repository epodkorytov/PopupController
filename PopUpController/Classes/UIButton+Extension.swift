//
//   UIButton+Extension.swift
//  PopUpController
//

import UIKit

public typealias OCButtonAction = () -> Void

public enum UIButtonAnswerType {
    case accept
    case cancel
    case passcode(String)
    case touchID
    case signIn(login: String, pass: String)
    case signUp(login: String, pass: String)
    case recovery(login: String)
    case smsCode(code: String)
    case newPassword(password: String)
    case checkPassword(password: String, forLogin: String)
    case guest
    case rules
    case privacy
}

public protocol UIButtonTypeProtocol {
    var title: String { get set }
    var answerType : UIButtonAnswerType { get set }
}

public struct UIButtonType: UIButtonTypeProtocol {
    public var title: String
    public var answerType : UIButtonAnswerType
    
    init (title: String, answerType : UIButtonAnswerType) {
        self.title = title
        self.answerType = answerType
    }
}

public extension UIButton
{
    
    private struct AssociatedKeys
    {
        static var ActionKey = "ActionKey"
        static var type   : UIButtonTypeProtocol? = nil
    }
    
    private class ActionWrapper
    {
        let action: OCButtonAction
        init(action: @escaping OCButtonAction)
        {
            self.action = action
        }
    }
    
    public var action: OCButtonAction? {
        set(newValue)
        {
            removeTarget(self, action: #selector(performAction), for: UIControl.Event.touchUpInside)
            
            var wrapper: ActionWrapper?
            
            if let newValue = newValue
            {
                wrapper = ActionWrapper(action: newValue)
                addTarget(self, action: #selector(performAction), for: UIControl.Event.touchUpInside)
            }
            
            objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get
        {
            guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ActionWrapper else {
                return nil
            }
            
            return wrapper.action
        }
    }
    
    @objc func performAction()
    {
        if let a = action
        {
            a()
        }
    }
    //
    
    var type   : UIButtonTypeProtocol?
    {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.type) as? UIButtonTypeProtocol
        }
        set {
            if let newValue = newValue
            {
                objc_setAssociatedObject(self, &AssociatedKeys.type, newValue as UIButtonTypeProtocol?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.setTitle(newValue.title, for: UIControl.State.normal)
            }
        }
    }
    
    //
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

public extension UIButton {
    
    convenience init(withStyle style: ButtonStyleProtocol) {
        self.init()
        
        setStyle(style)
    }
    
    
    public func setStyle(_ style: ButtonStyleProtocol) {
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
        titleLabel?.font = style.textFont
        
        layer.borderWidth = style.borderWidth
        layer.borderColor = style.borderColor?.cgColor
        
        customizeButtonShape(forStyle: style)
    }
    
    
    public func setTitleUnderlined(_ title: String?, for state: UIControl.State, style: ButtonStyleProtocol) {
        if let titleStr = title {
            let attrs = [ NSAttributedString.Key.font : style.textFont,
                          NSAttributedString.Key.foregroundColor : style.textColor,
                          NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
            
            let attributedString = NSMutableAttributedString(string: "")
            let buttonTitleStr = NSMutableAttributedString(string:titleStr, attributes:attrs)
                attributedString.append(buttonTitleStr)
            
            setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    
    public func customizeButtonShape(forStyle style: ButtonStyleProtocol) {
        switch style.type {
        case .primary, .secondary:
            layer.cornerRadius = style.cornerRadius
            
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.35
            layer.shadowRadius = 4.0
            
        default:
            break
        }
    }
    
    public func showButtonActivity() {
        titleLabel?.alpha = 0.0
        showActivityIndicator()
    }
    
    
    public func hideButtonActivity() {
        titleLabel?.alpha = 1.0
        hideActivityIndicator()
    }
    
}
