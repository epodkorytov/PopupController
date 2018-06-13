//
//  AuthViewConstants.swift
//  PopUpController
//

import UIKit


extension Selector {
    static let actionTapped = #selector(AuthView.actionButtonDidTapped(_:))
    static let registerTapped = #selector(AuthView.registerButtonDidTapped(_:))
    static let forgotTapped = #selector(AuthView.forgotButtonDidTapped(_:))
    static let viewTapped = #selector(AuthView.handleTapGesture(_:))
    static let closeTextView = #selector(AuthView.closeTextViewButtonDidTapped(_:))
}


extension AuthView {
    
    static let SMS_CODE_LENGTH = 4
    static let ANIMATION_DURATION = 0.25
    
    static let EMAIL_REGEX = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    static let PHONE_REGEX = "^09[0-9'@s]{9,9}$"
    
    enum BlockElementsType {
        case inputsStackView
        case logoStackView
    }
    
    enum AuthKitButtonType: Int {
        case forgotPassword = 1, rules, privacy, signIn, signUp, guest, next, confirm, cancel
    }
    
}
