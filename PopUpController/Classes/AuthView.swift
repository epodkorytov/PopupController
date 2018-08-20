//
//  AuthView.swift
//  PopUpController
//

import UIKit
import OCTextInput

struct TwoVariablesStruct {
    var firstVariable: String = ""
    var secondVariable: String = ""
    
    init(firstVariable: String, secondVariable: String) {
        self.firstVariable = firstVariable
        self.secondVariable = secondVariable
    }
    
    subscript(index: Int) -> String {
        if index == 0 {
            return firstVariable
        } else {
            return secondVariable
        }
    }
}

public class AuthView: UIImageView, OCTextInputDelegate {
    
//    MARK: - Constants
    
    private let BUTTON_ADDITIONS: CGFloat = 14.0
    
//    MARK: - Variables
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var bottomLabelText: TwoVariablesStruct? {
        didSet {
            bottomLabel.text = bottomLabelText?[0]
        }
    }
    
    var recoveryInfoLabelText: String? {
        didSet {
            recoveryInfoLabel.setTitle(recoveryInfoLabelText, withLineSpacing: BUTTON_ADDITIONS / 2.0)
        }
    }
    
    var registerButtonTitle: TwoVariablesStruct? {
        didSet {
            registerButton.setTitleUnderlined(registerButtonTitle?[0], for: .normal, style: style.smallButtonStyle)
        }
    }
    
    var privacyRulesLabelsText: TwoVariablesStruct? {
        didSet {
            privacyRulesLabel.text = privacyRulesLabelsText?[0]
            privacyRulesLabel2.text = privacyRulesLabelsText?[1]
        }
    }
    
    var privacyRulesButtonsText: TwoVariablesStruct? {
        didSet {
            rulesButton.setTitleUnderlined(privacyRulesButtonsText?[0], for: .normal, style: style.smallButtonStyle)
            privacyButton.setTitleUnderlined(privacyRulesButtonsText?[1], for: .normal, style: style.smallButtonStyle)
        }
    }
    
    var signInButtonTitle: String? {
        didSet {
            signInButton.setTitle(signInButtonTitle?.uppercased(), for: .normal)
        }
    }
    
    var guestButtonTitle: String? {
        didSet {
            guestButton.setTitle(guestButtonTitle?.uppercased(), for: .normal)
        }
    }
    
    var forgotPasswordButtonTitle: String? {
        didSet {
            forgotPasswordButton.setTitleUnderlined(forgotPasswordButtonTitle, for: .normal, style: style.smallButtonStyle)
        }
    }
    
    var loginInputPlaceholder: TwoVariablesStruct? {
        didSet {
            loginInput.placeHolderText = (loginInputPlaceholder?[0])!
        }
    }
    
    var passwordInputPlaceholder: String? {
        didSet {
            passwordInput.placeHolderText = passwordInputPlaceholder!
        }
    }
    
    var codeInputPlaceholder: String? {
        didSet {
            codeInput.placeHolderText = codeInputPlaceholder!
        }
    }
    
    private var horizontalSpacing: CGFloat {
        get {
            return style.horizontalSpacingRatio * (Constants.screenHeight / 667.0)
        }
    }
    
    private var inputsStackViewHorizontalSpacing: CGFloat {
        get {
            return horizontalSpacing / 2.0
        }
    }

    private var horizontalSpacingTakesAdditions: CGFloat {
        return horizontalSpacing - BUTTON_ADDITIONS / 2.0
    }
    
    public var continueButtonTitle: String?
    public var sendButtonTitle: String?
    
    
//    MARK: - Views & variables
    
    let imageView = UIImageView()
    
    var signInUpSceneStackView: UIStackView!
    var inputStackView        : UIStackView!
    var oldPassStackView      : UIStackView!
    var newPassStackView      : UIStackView!
    var logoStackView         : UIStackView!
    let privacyRulesStackView = UIStackView(withStackViewType: .vertical)
    
    var titleLabel           : UILabel!
    var bottomLabel          : UILabel!
    var privacyRulesLabel    : UILabel!
    var privacyRulesLabel2   : UILabel!
    var recoveryInfoLabel    : UILabel!
    var messageLabel         : UILabel!
    
    var rulesButton          : UIButton!
    var privacyButton        : UIButton!
    var registerButton       : UIButton!
    var signInButton         : UIButton!
    var guestButton          : UIButton!
    var forgotPasswordButton : UIButton!
    var closeTextViewButton  : UIButton!
    
    let loginInput = OCTextInput()
    let passwordInput = OCTextInput()
    let codeInput = OCTextInput()
    let loginInput2 = OCTextInput()
    let oldPassInput = OCTextInput()
    let newPassInput = OCTextInput()
    let confirmPassInput = OCTextInput()
    
    private var inputsCenterConstraint  : NSLayoutConstraint!
    private var logoSVBottomConstraint  : NSLayoutConstraint!
    
    private var additionalSceneViews: [UIView] = []
    private var buttonWithActivity: UIButton? = nil
    
    private let textView = UITextView()
    
    var associatedViewConstraint: [UIView : [NSLayoutConstraint]] = [:]
    
    
//    MARK: - Private variables
    private var _type: AlertViewType = .signIn
    fileprivate var type: AlertViewType! {
        set {
            _type = newValue
            if ((_type == .signUp || _type == .signIn)
                || (type == .recovery || type == .smsCode))
                || type == .newPassword
            {
                setModeForce(_type)
                if _type == .newPassword {
                    oldPassInput.becomeFirstResponder()
                }
            }            
        }
        get {
            return _type
        }
    }
    public var style: AuthViewStyle! {
        didSet {
            setupStyle()
        }
    }
    public var content: AuthViewContentProtocol! {
        didSet {
            configureContent()
        }
    }
    
    
    fileprivate var didCreate : ((_ view: UIView) -> Void)!
    fileprivate var completeHandler: PopUpControllerAnswer? = nil
    
    
//    MARK: - Instance initialization
    
    public init(bgImage: UIImage?,
                logoImage: UIImage,
                type: AlertViewType,
                content: AuthViewContentProtocol,
                style: AuthViewStyle,
                login: String? = nil,
                completeHandler: @escaping (PopUpControllerAnswer),
                didCreate: @escaping (_ view: UIView) -> Void)
    {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        //
        self.style = style
        self.content = content
        self.didCreate = didCreate
        self.completeHandler = completeHandler
        
        //
        setupUI()
        configureContent()
        image = bgImage
        imageView.image = logoImage
        loginInput2.text = login
        
        self.type = type
        
        self.didCreate(self)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    MARK: - Private methods
    
    fileprivate func setupUI() {
        let tapGR = UITapGestureRecognizer(target: self, action: .viewTapped)
        addGestureRecognizer(tapGR)
        
        // INPUTs
        loginInput.type = .email
        loginInput.delegate = self

        passwordInput.returnKeyType = .next
        passwordInput.delegate = self
        passwordInput.type = .password
        
        codeInput.delegate = self
        codeInput.isHidden = true
        codeInput.type = .numeric
        additionalSceneViews.append(codeInput)
        
        loginInput2.type = .email
        loginInput2.isUserInteractionEnabled = false
        
        oldPassInput.type = .password
        oldPassInput.delegate = self
        
        newPassInput.type = .password
        newPassInput.delegate = self
        
        confirmPassInput.type = .password
        confirmPassInput.delegate = self
        
        // LABELS
        titleLabel = UILabel(style: style.titleLabelStyle)
        bottomLabel = UILabel(style: style.smallLabelStyle)
        privacyRulesLabel = UILabel(style: style.smallLabelStyle)
        privacyRulesLabel2 = UILabel(style: style.smallLabelStyle)
        recoveryInfoLabel = UILabel(style: style.smallLabelStyle)
        messageLabel = UILabel(style: style.messageLabelStyle)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true
        additionalSceneViews.append(messageLabel)
        
        // BUTTONS
        rulesButton = UIButton(withStyle: style.smallButtonStyle)
        privacyButton = UIButton(withStyle: style.smallButtonStyle)
        registerButton = UIButton(withStyle: style.smallButtonStyle)
        signInButton = UIButton(withStyle: style.primaryButtonStyle)
        guestButton = UIButton(withStyle: style.secondaryButtonStyle)
        closeTextViewButton = UIButton(withStyle: style.secondaryButtonStyle)
        closeTextViewButton.alpha = 0.0
        forgotPasswordButton = UIButton(withStyle: style.smallButtonStyle)
        
        // IMAGEVIEWS
        imageView.contentMode = .center
        
        // BUTTONS
        registerButton.addTarget(self, action: .registerTapped, for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: .forgotTapped, for: .touchUpInside)
        closeTextViewButton.addTarget(self, action: .closeTextView, for: .touchUpInside)
        
        // TEXTVIEWs
        textView.isEditable = false
        textView.alpha = 0.0
        textView.style = style.textViewStyle
        
        // STACKVIEWS
        signInUpSceneStackView = UIStackView(withStackViewType: .vertical, spacing: horizontalSpacing)
        
        let bottomStackView = UIStackView(withStackViewType: .horizontal, spacing: 4.0)
            bottomStackView.addArrangedSubview(bottomLabel)
            bottomStackView.addArrangedSubview(registerButton)
        
        logoStackView = UIStackView(withStackViewType: .vertical, spacing: horizontalSpacing)
        logoStackView.addArrangedSubview(imageView)
        logoStackView.addArrangedSubview(titleLabel)
        
        inputStackView = UIStackView(withStackViewType: .vertical, spacing: inputsStackViewHorizontalSpacing)
        inputStackView.addArrangedSubview(loginInput)
        inputStackView.addArrangedSubview(passwordInput)
        
        oldPassStackView = UIStackView(withStackViewType: .vertical, spacing: inputsStackViewHorizontalSpacing)
        oldPassStackView.addArrangedSubview(loginInput2)
        oldPassStackView.addArrangedSubview(oldPassInput)
        oldPassStackView.isHidden = true
        additionalSceneViews.append(oldPassStackView)
        
        newPassStackView = UIStackView(withStackViewType: .vertical, spacing: inputsStackViewHorizontalSpacing)
        newPassStackView.addArrangedSubview(newPassInput)
        newPassStackView.addArrangedSubview(confirmPassInput)
        
        loginInput.style       = style.inputStyle
        passwordInput.style    = style.inputStyle
        codeInput.style        = style.inputStyle
        loginInput2.style      = style.inputStyle
        oldPassInput.style     = style.inputStyle
        newPassInput.style     = style.inputStyle
        confirmPassInput.style = style.inputStyle
        
        
        addSubview(logoStackView)
        addSubview(inputStackView)
        addSubview(textView)
        addSubview(oldPassStackView)
        addSubview(newPassStackView)
        addSubview(messageLabel)
        addSubview(codeInput)
        addSubview(forgotPasswordButton)
        addSubview(setupSignInUpStackView())
        addSubview(bottomStackView)
        addSubview(closeTextViewButton)
        
        // CONSTRAINTS
        _ = Constants.constraintFor(imageView, attribute: .width, value: style.logoImageSize.width)
        _ = Constants.constraintFor(imageView, attribute: .height, value: style.logoImageSize.height)
        
        logoSVBottomConstraint = Constants.constraintFor(logoStackView, attribute: .bottom, value: -(computeSpacingFor(.logoStackView)), toView: self, attribute2: .bottom)
        _ = Constants.constraintFor(logoStackView, attribute: .centerX, toView: self)
        
        _ = Constants.constraintFor(forgotPasswordButton, attribute: .bottom, value: -(horizontalSpacingTakesAdditions), toView: signInUpSceneStackView, attribute2: .top)
        _ = Constants.constraintFor(forgotPasswordButton, attribute: .centerX, toView: self)
        
        _ = Constants.constraintFor(textView, attribute: .top, value: 10.0,
                                    toView: imageView, attribute2: .bottom)
        _ = Constants.constraintFor(textView, attribute: .bottom, value: -(10.0),
                                    toView: closeTextViewButton, attribute2: .top)
        _ = Constants.constraintFor(textView, attribute: .leading, value: 5.0, toView: self)
        _ = Constants.constraintFor(textView, attribute: .trailing, value: -5.0, toView: self)
//        _ = Constants.constraintFor(textView, attribute: .width, toView: loginInput)
//        _ = Constants.constraintFor(textView, attribute: .centerX, toView: self)
        
        _ = Constants.constraintFor(closeTextViewButton, attribute: .bottom, toView: bottomStackView)
        _ = Constants.constraintFor(closeTextViewButton, attribute: .width, toView: loginInput)
        _ = Constants.constraintFor(closeTextViewButton, attribute: .height, toView: signInButton)
        _ = Constants.constraintFor(closeTextViewButton, attribute: .centerX, toView: self)
        
        inputsCenterConstraint = Constants.constraintFor(inputStackView, attribute: .centerX, toView: self)
        _ = Constants.constraintFor(inputStackView, attribute: .bottom, value: -(computeSpacingFor(.inputsStackView)), toView: self, attribute2: .bottom)
        
        _ = Constants.constraintFor(messageLabel, attribute: .top, toView: loginInput)
        _ = Constants.constraintFor(messageLabel, attribute: .width, toView: loginInput)
        _ = Constants.constraintFor(messageLabel, attribute: .leading,
                                    value: style.containerViewVerticalSpacing * 2.0,
                                    toView: inputStackView,
                                    attribute2: .trailing)
        
        _ = Constants.constraintFor(codeInput, attribute: .top, toView: loginInput)
        _ = Constants.constraintFor(codeInput, attribute: .width, toView: loginInput)
        _ = Constants.constraintFor(codeInput, attribute: .leading, toView: messageLabel)
        
        _ = Constants.constraintFor(oldPassStackView, attribute: .top, toView: messageLabel)
        _ = Constants.constraintFor(oldPassStackView, attribute: .leading, toView: messageLabel)
        
        _ = Constants.constraintFor(newPassStackView, attribute: .top, toView: messageLabel)
        _ = Constants.constraintFor(newPassStackView, attribute: .leading,
                                    value: style.containerViewVerticalSpacing * 2.0,
                                    toView: oldPassStackView,
                                    attribute2: .trailing)

        associatedViewConstraint[loginInput] = [setupInputConstraint(loginInput).1]
        associatedViewConstraint[passwordInput] = [setupInputConstraint(passwordInput).1]
        _ = setupInputConstraint(loginInput2)
        _ = setupInputConstraint(oldPassInput)
        _ = setupInputConstraint(newPassInput)
        _ = setupInputConstraint(confirmPassInput)
        
        _ = Constants.constraintFor(signInUpSceneStackView, attribute: .bottom, value: -(horizontalSpacingTakesAdditions), toView: bottomStackView, attribute2: .top)
        _ = Constants.constraintFor(signInUpSceneStackView, attribute: .centerX, toView: self)
        
        _ = Constants.constraintFor(bottomStackView, attribute: .bottom, value: -(horizontalSpacingTakesAdditions), toView: self)
        _ = Constants.constraintFor(bottomStackView, attribute: .centerX, toView: self)
    }
    
    
    fileprivate func setupStyle() {
        titleLabel.setStyle(style.titleLabelStyle)
        bottomLabel.setStyle(style.smallLabelStyle)
        privacyRulesLabel.setStyle(style.smallLabelStyle)
        privacyRulesLabel2.setStyle(style.smallLabelStyle)
        recoveryInfoLabel.setStyle(style.smallLabelStyle)
        messageLabel.setStyle(style.messageLabelStyle)
        
        rulesButton.setStyle(style.smallButtonStyle)
        privacyButton.setStyle(style.smallButtonStyle)
        registerButton.setStyle(style.smallButtonStyle)
        signInButton.setStyle(style.primaryButtonStyle)
        guestButton.setStyle(style.secondaryButtonStyle)
        closeTextViewButton.setStyle(style.secondaryButtonStyle)
        forgotPasswordButton.setStyle(style.smallButtonStyle)
        
        textView.style = style.textViewStyle
        
        loginInput.style       = style.inputStyle
        passwordInput.style    = style.inputStyle
        codeInput.style        = style.inputStyle
        loginInput2.style      = style.inputStyle
        oldPassInput.style     = style.inputStyle
        newPassInput.style     = style.inputStyle
        confirmPassInput.style = style.inputStyle
    }
    
    fileprivate func configureContent() {
        titleText = content.titleText
        bottomLabelText = TwoVariablesStruct(firstVariable: content.bottomLabelTextSignUp,
                                             secondVariable: content.bottomLabelTextSignIn)
        registerButtonTitle = TwoVariablesStruct(firstVariable: content.registerButtonTitleSignUp,
                                                 secondVariable: content.registerButtonTitleSignIn)
        signInButtonTitle = content.signInButtonTitle
        guestButtonTitle = content.guestButtonTitle
        forgotPasswordButtonTitle = content.forgotPasswordButtonTitle
        loginInputPlaceholder = TwoVariablesStruct(firstVariable: content.loginInputPlaceholderSignUp,
                                                   secondVariable: content.loginInputPlaceholderSignUp)
        passwordInputPlaceholder = content.passwordInputPlaceholder
        codeInputPlaceholder = content.codeInputPlaceholder
        continueButtonTitle = content.continueButtonTitle
        sendButtonTitle = content.sendButtonTitle
        privacyRulesLabelsText = TwoVariablesStruct(firstVariable: content.privacyRulesLabelText,
                                                    secondVariable: content.privacyRulesLabelTextAmp)
        privacyRulesButtonsText = TwoVariablesStruct(firstVariable: content.rulesButtonText,
                                                     secondVariable: content.privacyButtonText)
        recoveryInfoLabelText = content.recoveryInfoLabelText
        
        loginInput2.placeHolderText = content.loginInput2Placeholder
        oldPassInput.placeHolderText = content.oldPassPlaceholder
        newPassInput.placeHolderText = content.newPassPlaceholder
        confirmPassInput.placeHolderText = content.confirmNewPassPlaceholder
        
        closeTextViewButton.setTitle(content.closeTextViewButtonTitle.uppercased(), for: .normal)
    }
    
    
    fileprivate func computeSpacingFor(_ blockType: BlockElementsType) -> CGFloat {
        let horizontalSpacing = style.horizontalSpacingRatio * (Constants.screenHeight / 667.0)
        var result: CGFloat = 0.0
        // space
        result += horizontalSpacing
        
        // signIn/signUp small
        result += style.smallLabelStyle.textFont.pointSize
        
        // space
        result += horizontalSpacing
        
        // 2 big buttons with internal space block
        result += style.primaryButtonStyle.buttonHeight + horizontalSpacing + style.primaryButtonStyle.buttonHeight
        
        // space
        result += horizontalSpacing
        
        // forgot pass
        result += style.smallLabelStyle.textFont.pointSize
        
        // space
        result += horizontalSpacing
        
        if blockType == .logoStackView {
            // inputs block
            result += style.inputStyle.inputHeight + inputsStackViewHorizontalSpacing + style.inputStyle.inputHeight
            
            let logoBlockHeight = style.logoImageSize.height + horizontalSpacing + style.titleLabelStyle.textFont.pointSize
            let freeSpace = (Constants.screenHeight - 20.0) - result
            let gap = freeSpace - logoBlockHeight
            if (gap / 2.0) < logoBlockHeight {
                result += gap / 2.0
            } else {
                result += (freeSpace - (freeSpace / 1.618) - (logoBlockHeight / 2.0))
            }
            
        }
        
        return result
    }
    
    
    fileprivate func setupSignInUpStackView() -> UIStackView {
        recoveryInfoLabel.numberOfLines = 0
        recoveryInfoLabel.textAlignment = .center
        _ = Constants.constraintFor(recoveryInfoLabel, attribute: .width, value: Constants.screenWidth - (style.containerViewVerticalSpacing * 2))
        
        // BUTTONS
        rulesButton.addTarget(self, action: .actionTapped, for: .touchUpInside)
        privacyButton.addTarget(self, action: .actionTapped, for: .touchUpInside)
        signInButton.addTarget(self, action: .actionTapped, for: .touchUpInside)
        guestButton.addTarget(self, action: .actionTapped, for: .touchUpInside)
        signInButton.tag = AuthKitButtonType.signIn.rawValue
        guestButton.tag = AuthKitButtonType.guest.rawValue
        rulesButton.tag = AuthKitButtonType.rules.rawValue
        privacyButton.tag = AuthKitButtonType.privacy.rawValue
        
        // STACKVIEWS
        privacyRulesStackView.addArrangedSubview(stackView(withViewsAddedHorizontaly: [privacyRulesLabel, rulesButton]))
        privacyRulesStackView.addArrangedSubview(stackView(withViewsAddedHorizontaly: [privacyRulesLabel2, privacyButton]))
        
        signInUpSceneStackView.addArrangedSubview(recoveryInfoLabel)
        signInUpSceneStackView.addArrangedSubview(privacyRulesStackView)
        signInUpSceneStackView.addArrangedSubview(signInButton)
        signInUpSceneStackView.addArrangedSubview(guestButton)
        
        associatedViewConstraint[signInButton] = [setupButtonConstraint(signInButton).1]
        associatedViewConstraint[guestButton] = [setupButtonConstraint(guestButton).1]
        _ = transitionFor(privacyRulesStackView, withAnimation: false)
        _ = transitionFor(recoveryInfoLabel, withAnimation: false)
        
        return signInUpSceneStackView
    }
    
    
    fileprivate func stackView(withViewsAddedHorizontaly views:Array<UIView>) -> UIStackView {
        let result = UIStackView(withStackViewType: .horizontal, spacing: 4.0)
        for view in views {
            result.addArrangedSubview(view)
        }
        return result
    }
    
    
    fileprivate func setupViewConstraint(_ subview: UIView, constraint value: CGFloat) -> (NSLayoutConstraint, NSLayoutConstraint) {
        subview.isHidden = false
        let widthConstraint = Constants.constraintFor(subview, attribute: .width, value: Constants.screenWidth - (style.containerViewVerticalSpacing * 2))
        let heightConstraint = Constants.constraintFor(subview, attribute: .height, value: value)
        return (widthConstraint, heightConstraint)
    }
    
    
    fileprivate func setupButtonConstraint(_ subview: UIView) -> (NSLayoutConstraint, NSLayoutConstraint) {
        return setupViewConstraint(subview, constraint: style.primaryButtonStyle.buttonHeight)
    }
    
    
    fileprivate func setupInputConstraint(_ subview: UIView) -> (NSLayoutConstraint, NSLayoutConstraint) {
        return setupViewConstraint(subview, constraint: style.inputStyle.inputHeight)
    }
    
    
    fileprivate func clearInputs() {
        passwordInput.text = nil
    }
    
    fileprivate func checkInputsIsFilled() -> Bool {
        var result = true
        
        if loginInput.text?.count == 0 {
            loginInput.becomeFirstResponder()
            result = false
        } else if (passwordInput.text?.count == 0 && passwordInput.alpha > 0.0) {
            passwordInput.becomeFirstResponder()
            result = false
        }
        return result
    }
    
    
    fileprivate func makeAdditionalViewVisible(view: UIView?, visible: Bool = true) {
        for item in additionalSceneViews {
            item.isHidden = true
        }
        view?.isHidden = !visible
    }
    
    
    fileprivate func transitionViewIfNeeded(_ target: UIView, _ hide: Bool, _ animated: Bool) {
        if target.isHidden != hide {
            _ = transitionFor(target, withAnimation: animated)
        }
    }
    
    
    fileprivate func madeTransitionToAdditionalScene(targetScene: UIView, completion: ((Bool) -> Void)? = nil) {
        titleText = content.titleText
        makeAdditionalViewVisible(view: targetScene)
        inputsCenterConstraint.constant = -(Constants.screenWidth)
        
        let hide = true
        var animated = false
        transitionViewIfNeeded(forgotPasswordButton, hide, animated)
        transitionViewIfNeeded(signInButton, hide, animated)
        transitionViewIfNeeded(privacyRulesStackView, hide, animated)
        transitionViewIfNeeded(guestButton, !hide, animated)
        transitionViewIfNeeded(registerButton, !hide, animated)
        
        animated = true
        UIView.animate(withDuration: animated ? AuthView.ANIMATION_DURATION : 0, animations: {
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    
    fileprivate func blockAllContent(_ block: Bool) {
        for item in subviews {
            item.isUserInteractionEnabled = !block
        }
    }
    
    
    fileprivate func showHugeText(_ text: String) {
        textView.text = text
        let newConstraint = frame.height - (UIApplication.shared.statusBarFrame.height + style.containerViewVerticalSpacing + logoStackView.frame.height)
        logoSVBottomConstraint.constant = -newConstraint
        UIView.animate(withDuration: AuthView.ANIMATION_DURATION) { [weak weakSelf = self] in
            weakSelf?.titleLabel.alpha      = 0.0
            weakSelf?.inputStackView.alpha  = 0.0
            weakSelf?.bottomLabel.alpha     = 0.0
            weakSelf?.registerButton.alpha  = 0.0
            weakSelf?.signInUpSceneStackView.alpha = 0.0
            
            weakSelf?.textView.alpha            = 1.0
            weakSelf?.closeTextViewButton.alpha = 1.0
            
            weakSelf?.layoutIfNeeded()
        }
    }
    
    
//    MARK: - Action methods
    
    
    @objc func handleTapGesture(_ gesture: UIGestureRecognizer) {
        titleText = content.titleText
        endEditing(true)
    }
    
    @objc func registerButtonDidTapped(_ sender: UIButton!) {
        titleText = content.titleText
        if inputsCenterConstraint.constant != 0.0 {
            loginInput.text = nil
            passwordInput.text = nil
            messageLabel.text = ""
            inputsCenterConstraint.constant = 0.0
            transitionViewIfNeeded(signInButton, false, false)
            signInButton.setTitle(content.signInButtonTitle.uppercased(), for: .normal)
            signInButton.tag = AuthKitButtonType.signIn.rawValue
            transitionViewIfNeeded(forgotPasswordButton, false, false)
            bottomLabel.text = bottomLabelText?[0]
            registerButton.setTitleUnderlined(registerButtonTitle?[0], for: .normal, style: style.smallButtonStyle)
            UIView.animate(withDuration: AuthView.ANIMATION_DURATION) { [weak weakSelf = self] in
                weakSelf?.layoutIfNeeded()
            }
        } else {
            let flag = transitionFor(guestButton)
            clearInputs()
            endEditing(true)
            bottomLabel.text = bottomLabelText?[Int(truncating: NSNumber(value:flag))]
            loginInput.placeHolderText = (loginInputPlaceholder?[Int(truncating: NSNumber(value:flag))])!
            registerButton.setTitleUnderlined(registerButtonTitle?[Int(truncating: NSNumber(value:flag))], for: .normal, style: style.smallButtonStyle)
            signInButton.setTitle(flag ? continueButtonTitle?.uppercased() : signInButtonTitle?.uppercased(), for: .normal)
            if !recoveryInfoLabel.isHidden {
                signInButton.tag = AuthKitButtonType.signIn.rawValue
                _ = transitionFor(recoveryInfoLabel, withAnimation: false)
                _ = transitionFor(forgotPasswordButton, withAnimation: false)
                passwordInput.alpha = 1.0
            } else {
                signInButton.tag = signInButton.tag == AuthKitButtonType.signUp.rawValue ? AuthKitButtonType.signIn.rawValue : AuthKitButtonType.signUp.rawValue
                _ = transitionFor(privacyRulesStackView, withAnimation: false)
                _ = transitionFor(forgotPasswordButton, withAnimation: false)
            }
        }
    }
    
    
    @objc func forgotButtonDidTapped(_ sender: UIButton!) {
        titleText = content.titleText
        let flag = transitionFor(guestButton)
        endEditing(true)
        clearInputs()
        bottomLabel.text = bottomLabelText?[Int(truncating: NSNumber(value:flag))]
        registerButton.setTitleUnderlined(registerButtonTitle?[Int(truncating: NSNumber(value:flag))], for: .normal, style: style.smallButtonStyle)
        signInButton.setTitle(flag ? sendButtonTitle?.uppercased() : signInButtonTitle?.uppercased(), for: .normal)
        signInButton.tag = AuthKitButtonType.forgotPassword.rawValue
        passwordInput.alpha = 0.0
        _ = transitionFor(recoveryInfoLabel, withAnimation: false)
        _ = transitionFor(forgotPasswordButton, withAnimation: false)
    }
    
    
    @objc func actionButtonDidTapped(_ sender: UIButton!) {
        titleText = content.titleText
        endEditing(true)
        
        let showButtonActivity: () -> Void = { [weak weakSelf = self] in
            weakSelf?.buttonWithActivity = sender
            weakSelf?.buttonWithActivity?.showButtonActivity()
            weakSelf?.blockAllContent(true)
        }
        
        let isLoginValidate: (String) -> Bool = { [weak weakSelf = self] login in
            let validation = weakSelf?.validateLogin(for: weakSelf?.loginInput.text ?? "")
            if validation == .unknown {
                weakSelf?.wrongLogin(message: weakSelf?.content.wrongLoginText ?? "")
                return false
            } else {
                showButtonActivity()
                return true
            }
        }
        
        if let buttonType = AuthKitButtonType(rawValue: sender.tag) {
            switch buttonType {
            case .forgotPassword:
                if checkInputsIsFilled() {
                    if isLoginValidate(loginInput.text ?? "") {
                        completeHandler?(.recovery(login: loginInput.text ?? ""))
                        showButtonActivity()
                    }
                }
            case .signIn:
                if checkInputsIsFilled() {
                    if isLoginValidate(loginInput.text ?? "") {
                        completeHandler?(.signIn(login: loginInput.text ?? "",
                                                 pass: passwordInput.text ?? ""))
                        showButtonActivity()
                    }
                }
            case .signUp:
                if checkInputsIsFilled() {
                    if isLoginValidate(loginInput.text ?? "") {
                        completeHandler?(.signUp(login: loginInput.text ?? "",
                                                 pass: passwordInput.text ?? ""))
                        showButtonActivity()
                    }
                }
            case .guest:
                completeHandler?(.guest)
            case .rules:
//                completeHandler?(.rules)
                showHugeText(content.rulesText)
            case .privacy:
//                completeHandler?(.privacy)
                showHugeText(content.privacyText)
            case .cancel:
                completeHandler?(.cancel)
            case .next:
                if oldPassInput.text?.count != 0 {
                    completeHandler?(.checkPassword(password: oldPassInput.text!, forLogin: loginInput2.text!))
                } else {
                    oldPassInput.becomeFirstResponder()
                }
            case .confirm:
                if newPassInput.text?.count == 0 {
                    newPassInput.becomeFirstResponder()
                } else if confirmPassInput.text?.count == 0 {
                    confirmPassInput.becomeFirstResponder()
                } else if newPassInput.text == confirmPassInput.text {
                    completeHandler?(.newPassword(password: newPassInput.text!))
                } else {
                    newPassInput.text = nil
                    confirmPassInput.text = nil
                    newPassInput.becomeFirstResponder()
                    titleText = content.newPassesDontMatch
                }
            }
        }
    }
    
    
    @objc func closeTextViewButtonDidTapped(_ sender: UIButton) {
        titleText = content.titleText
        logoSVBottomConstraint.constant = -(computeSpacingFor(.logoStackView))
        UIView.animate(withDuration: AuthView.ANIMATION_DURATION, animations: { [weak weakSelf = self] in
            weakSelf?.titleLabel.alpha      = 1.0
            weakSelf?.inputStackView.alpha  = 1.0
            weakSelf?.bottomLabel.alpha     = 1.0
            weakSelf?.registerButton.alpha  = 1.0
            weakSelf?.signInUpSceneStackView.alpha = 1.0
            
            weakSelf?.textView.alpha            = 0.0
            weakSelf?.closeTextViewButton.alpha = 0.0
            
            weakSelf?.layoutIfNeeded()
        }) { [weak weakSelf = self] (success) in
            weakSelf?.textView.setContentOffset(.zero, animated: false)
        }
    }
    
    
//    MARK: - Interface methods
    
    public enum LoginType {
        case email
        case phone
        case unknown
    }
    public func validateLogin(for target: String) -> LoginType {
        let isPhoneNumber: (String) -> Bool = { target in
            do {
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                let matches = detector.matches(in: target, options: [], range: NSMakeRange(0, target.count))
                if let res = matches.first {
                    return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == target.count
                } else {
                    return false
                }
            } catch {
                return false
            }
        }
        
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", AuthView.PHONE_REGEX)
        let emailTest = NSPredicate(format:"SELF MATCHES %@", AuthView.EMAIL_REGEX)
        return isPhoneNumber(target) ? .phone : emailTest.evaluate(with: target) ? .email : .unknown
    }
    
    
    public func showMessage(_ message: String) {
        titleText = content.titleText
        buttonWithActivity?.hideButtonActivity()
        blockAllContent(false)
        messageLabel.text = message
        bottomLabel.text = bottomLabelText?[1]
        registerButton.setTitleUnderlined(registerButtonTitle?[1], for: .normal, style: style.smallButtonStyle)
        
        madeTransitionToAdditionalScene(targetScene: messageLabel)
    }
    
    
    public func showCodeInput() {
        titleText = content.titleText
        buttonWithActivity?.hideButtonActivity()
        blockAllContent(false)
        signInButton.setTitle(content.sendButtonTitle, for: .normal)
        bottomLabel.text = bottomLabelText?[1]
        registerButton.setTitleUnderlined(registerButtonTitle?[1], for: .normal, style: style.smallButtonStyle)
        
        madeTransitionToAdditionalScene(targetScene: codeInput)
        codeInput.becomeFirstResponder()
    }
    
    
    public func showNewPassScene() {
        titleText = content.titleText
        signInButton.setTitle(content.confirmNewPassPlaceholder, for: .normal)
        signInButton.tag = AuthKitButtonType.confirm.rawValue
        inputsCenterConstraint.constant = -(frame.width * 2.0)
        UIView.animate(withDuration: AuthView.ANIMATION_DURATION, animations: { [weak weakSelf = self] in
            weakSelf?.layoutIfNeeded()
            }, completion: {  [weak weakSelf = self] (success) in
                weakSelf?.newPassInput.becomeFirstResponder()
        })
    }
    
    
    public func wrongLogin(message: String) {
        blockAllContent(false)
        titleText = message
        loginInput.text = nil
        loginInput.becomeFirstResponder()
    }
    
    
    public func wrongCode(message: String) {
        blockAllContent(false)
        titleText = message
        codeInput.text = nil
        codeInput.becomeFirstResponder()
    }
    
    
    public func wrongOldPassword(message: String) {
        blockAllContent(false)
        titleText = message
        oldPassInput.text = nil
        oldPassInput.becomeFirstResponder()
    }

    
    public func setModeForce(_ mode: AlertViewType) {
        let allViewShouldHideExcept: ([UIView]) -> Void = { [unowned self] exceptArr in
            let animated = false
            let isHideView: (UIView) -> Void = { targetView in
                if targetView == self.passwordInput {
                    targetView.alpha = exceptArr.contains(targetView) ? 1.0 : 0.0
                } else {
                    if exceptArr.contains(targetView) {
                        self.transitionViewIfNeeded(targetView, false, animated)
                    } else {
                        self.transitionViewIfNeeded(targetView, true, animated)
                    }
                }
            }
            
            self.endEditing(true)
            self.titleText = self.content.titleText
            self.loginInput.text = nil
            self.passwordInput.text = nil
            self.messageLabel.text = ""
            self.codeInput.text = nil
            isHideView(self.loginInput)
            isHideView(self.passwordInput)
            isHideView(self.forgotPasswordButton)
            isHideView(self.recoveryInfoLabel)
            isHideView(self.signInButton)
            isHideView(self.guestButton)
            isHideView(self.bottomLabel)
            isHideView(self.registerButton)
            isHideView(self.privacyRulesStackView)
            isHideView(self.codeInput)
            isHideView(self.messageLabel)
            isHideView(self.oldPassStackView)
        }
        
        switch mode {
        case .signIn:
            allViewShouldHideExcept([loginInput, passwordInput, forgotPasswordButton, signInButton, guestButton, bottomLabel, registerButton])
            signInButton.tag = AuthKitButtonType.signIn.rawValue
            guestButton.tag = AuthKitButtonType.guest.rawValue
            self.inputsCenterConstraint.constant = 0.0
            bottomLabel.text = content.bottomLabelTextSignUp
            registerButton.setTitleUnderlined(content.registerButtonTitleSignUp, for: .normal, style: style.smallButtonStyle)
            signInButton.setTitle(content.signInButtonTitle.uppercased(), for: .normal)
        case .signUp:
            allViewShouldHideExcept([loginInput, passwordInput, privacyRulesStackView, signInButton, bottomLabel, registerButton])
            signInButton.tag = AuthKitButtonType.signUp.rawValue
            self.inputsCenterConstraint.constant = 0.0
            bottomLabel.text = content.bottomLabelTextSignIn
            registerButton.setTitleUnderlined(content.registerButtonTitleSignIn, for: .normal, style: style.smallButtonStyle)
            signInButton.setTitle(content.continueButtonTitle.uppercased(), for: .normal)
        case .recovery:
            allViewShouldHideExcept([loginInput, recoveryInfoLabel, signInButton, bottomLabel, registerButton])
            signInButton.tag = AuthKitButtonType.forgotPassword.rawValue
            self.inputsCenterConstraint.constant = 0.0
            bottomLabel.text = content.bottomLabelTextSignIn
            registerButton.setTitleUnderlined(content.registerButtonTitleSignIn, for: .normal, style: style.smallButtonStyle)
            signInButton.setTitle(content.sendButtonTitle.uppercased(), for: .normal)
        case .smsCode:
            allViewShouldHideExcept([loginInput, passwordInput, codeInput, guestButton, bottomLabel, registerButton])
            self.inputsCenterConstraint.constant = -(Constants.screenWidth)
            guestButton.tag = AuthKitButtonType.guest.rawValue
            bottomLabel.text = content.bottomLabelTextSignIn
            registerButton.setTitleUnderlined(content.registerButtonTitleSignIn, for: .normal, style: style.smallButtonStyle)
        case .newPassword:
            allViewShouldHideExcept([loginInput, passwordInput, oldPassStackView, signInButton, guestButton])
            self.inputsCenterConstraint.constant = -(Constants.screenWidth)
            signInButton.setTitle(content.continueButtonTitle.uppercased(), for: .normal)
            guestButton.setTitle(content.cancelButtonTitle.uppercased(), for: .normal)
            signInButton.tag = AuthKitButtonType.next.rawValue
            guestButton.tag = AuthKitButtonType.cancel.rawValue
        default:
            break
        }
    }
    
    
//    MARK: - Delegated methods
    
//    MARK: OCTextInputDelegate
    
    public func OCTextInputShouldReturn(_ OCTextInput: OCTextInput) -> Bool {
        if OCTextInput == loginInput || OCTextInput == passwordInput {
            if OCTextInput == loginInput && (passwordInput.alpha > 0.0 && passwordInput.text?.count == 0) {
                passwordInput.becomeFirstResponder()
            } else if OCTextInput == passwordInput && loginInput.text?.count == 0 {
                loginInput.becomeFirstResponder()
            } else {
                if (loginInput.text?.count != 0 && passwordInput.alpha == 0.0) ||
                    !(loginInput.text?.count == 0 || passwordInput.text?.count == 0)
                {
                    _ = OCTextInput.resignFirstResponder()
                    actionButtonDidTapped(signInButton)
                }
            }
        } else if OCTextInput == oldPassInput && oldPassInput.text?.count != 0 {
            actionButtonDidTapped(signInButton)
        } else if OCTextInput == newPassInput && newPassInput.text?.count != 0 {
            actionButtonDidTapped(signInButton)
        } else if OCTextInput == confirmPassInput && confirmPassInput.text?.count != 0 {
            actionButtonDidTapped(signInButton)
        }
        return false
    }
    
    
    public func OCTextInputDidChange(_ OCTextInput: OCTextInput) {
        if OCTextInput == codeInput {
            if OCTextInput.text?.count == AuthView.SMS_CODE_LENGTH {
                completeHandler?(.smsCode(code: OCTextInput.text!))
            }
        }
    }
    
}
