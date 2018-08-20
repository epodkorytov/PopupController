//
//  PopUpController+PinView.swift
//  PopUpController
//


import UIKit
import LocalAuthentication


extension PopUpController {
    
    private struct CustomProperties {
        static var pinView: PinView!
        static var pinViewStyle: PinViewStyle = PinViewStyleDefault()
        static var pinViewContent: PinViewContentProtocol = PinViewContentDefault()
    }
    
    //
    public var pinViewStyle: PinViewStyle {
        get {
            return getAssociatedObject(&CustomProperties.pinViewStyle, defaultValue: CustomProperties.pinViewStyle)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.pinViewStyle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //
    public var pinViewContent: PinViewContentProtocol {
        get {
            return getAssociatedObject(&CustomProperties.pinViewContent, defaultValue: CustomProperties.pinViewContent)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.pinViewContent, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //
    public var pinView: PinView! {
        get {
            return getAssociatedObject(&CustomProperties.pinView, defaultValue: CustomProperties.pinView)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.pinView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    //MARK: - Presenter
    
    public func presentPinView(touchIDType: TouchIDType? = .visible,
                               style: PinViewStyle = PinViewStyleDefault(),
                               content: PinViewContentProtocol = PinViewContentDefault(),
                               completeHandler: @escaping PopUpControllerAnswer)
    {
        pinViewStyle = style
        pinViewContent = content
        
        func showTouchIDPopup(_ completeHandler: @escaping PopUpControllerAnswer){
            LAContext().evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.pinViewContent.titleText) { [weak self] (success, error) in
                guard success else {
                    DispatchQueue.main.async {
                        // show something here to block the user from continuing
                        self?.showPopupView(size: (self?.pinView.calculatedSize)!)
                        completeHandler(.touchID)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    // do something here to continue loading your app, e.g. call a delegate method
                    PopUpController.dismiss {
                        completeHandler(.touchID)
                    }
                }
            }
        }
        
        var touchIDType = touchIDType
        self.style = pinViewStyle
        
        let onComplete: PopUpControllerAnswer = { answer in
            switch answer {
                case .touchID:
                    self.hidePopupView()
                    showTouchIDPopup(completeHandler)
                    completeHandler(answer)
                    break
                default:
                    completeHandler(answer)
                    break
            }
            
        }
        
        let context = LAContext()
        var error: NSError? = nil
        let availebleTouchID = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error)
        
        if !availebleTouchID {
            touchIDType = TouchIDType.none
        }
        
        pinView = PinView(touchIDType: touchIDType,
                          style: pinViewStyle,
                          completeHandler: onComplete,
                          didCreate: { view in
                            
                            if touchIDType == TouchIDType.immediate {
                                self.present(UIView(), mode: .centered, hideOnTouch: false)
                                showTouchIDPopup({ answer in
                                    self.present(view, mode: .centered, hideOnTouch: false)
                                })
                            } else {
                                self.present(view, mode: .centered, hideOnTouch: false)
                            }
                            
        })
        
    }
    
    public func presentInputPinView(completeHandler: @escaping PopUpControllerAnswer){
        self.style = pinViewStyle
        var masterPassCode: String = ""
        
        let onComplete: PopUpControllerAnswer = { answer in
            switch answer {
            case .passcode(let passcode):
                if masterPassCode.isEmpty {
                    masterPassCode = passcode
                    self.pinView.retypeCode()
                } else if masterPassCode == passcode {
                    PopUpController.dismiss {
                        completeHandler(answer)
                    }
                } else {
                    self.pinView.isPasscodeValid?(false)
                }
                
                
                break
            default:
                completeHandler(answer)
                break
            }
            
        }
        
        pinView = PinView(touchIDType: TouchIDType.none,
                          style: pinViewStyle,
                          completeHandler: onComplete,
                          didCreate: { view in
                            self.present(view, mode: .centered, hideOnTouch: false)
        })
    }
}
