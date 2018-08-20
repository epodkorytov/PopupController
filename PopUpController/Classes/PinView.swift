//
//  PinView.swift
//  PopUpController
//
import UIKit
import ImageExtended

public enum TouchIDType {
    case none
    case visible
    case immediate
}

public class PinView: UIView {
    
    //    MARK: Variables
    
    public var isPasscodeValid: ((Bool) -> Void)?
    fileprivate var touchIDType: TouchIDType!
    
    fileprivate var didCreate : ((_ view: UIView) -> Void)!
    fileprivate var completeHandler: PopUpControllerAnswer? = nil
    
    fileprivate var style: PinViewStyle!
    fileprivate var content: PinViewContentProtocol!
    
    public var calculatedSize: CGSize {
        let width: CGFloat = style.buttonSize.width * 3.0 + style.horizontalSpacing * 2.0
        
        var height: CGFloat = style.titleLabelFont.pointSize + style.verticalSpacing
            height += style.dotSize.height + style.verticalSpacing
            height += style.errorLabelFont.pointSize + style.verticalSpacing
            height += style.buttonSize.width * 4.0 + style.verticalSpacing * 3.0
        return CGSize(width: width, height: height)
    }
    
    //MARK: - Lifecycle
    public init(touchIDType: TouchIDType!,
                style: PinViewStyle = PinViewStyleDefault(),
                content: PinViewContentProtocol = PinViewContentDefault(),
                completeHandler: @escaping (PopUpControllerAnswer),
                didCreate: @escaping (_ view: UIView) -> Void)
    {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        //
        self.touchIDType = touchIDType
        self.style = style
        self.content = content
        self.didCreate = didCreate
        self.completeHandler = completeHandler
        
        configureStyle()
        setupContent()
        //
        
        self.frame.size = self.calculatedSize
        
        self.didCreate(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    private enum AdditionalButton: Int {
        case touchID = 10
        case eraseAll = 11
    }
    
    private let emptyValue = 99
    private var enteredPasscode: String {
        var result: String = ""
        dotViews.forEach( { result += String($0.tag) } )
        return result
    }
    
    private var pinsStackView = UIStackView()
    private var dotViews: Array<DotView> = []
    private let errorLabel = UILabel()
    private let titleLabel = UILabel()
    
    //    MARK: - Private methods
    
    private func configureStyle() {
        let containerStackView = stackView(withAxis: .vertical)
        
        titleLabel.font = style.titleLabelFont
        titleLabel.textColor = style.titleTextColor
        containerStackView.addArrangedSubview(titleLabel)
        
        pinsStackView = stackView(withAxis: .horizontal)
        for _ in 0..<style.passcodeLength {
            let newDotView = DotView(dotColor: style.dotColor)
            
            dotView(newDotView, setNewTag: emptyValue)
            newDotView.layer.cornerRadius = style.dotSize.width / 2.0
            
            _ = Constants.constraintFor(newDotView, attribute: .width, value: style.dotSize.width)
            _ = Constants.constraintFor(newDotView, attribute: .height, value: style.dotSize.height)
            
            dotViews.append(newDotView)
            pinsStackView.addArrangedSubview(newDotView)
        }
        containerStackView.addArrangedSubview(pinsStackView)
        _ = Constants.constraintFor(pinsStackView, attribute: .leading, value: style.buttonSize.width, toView: containerStackView)
        _ = Constants.constraintFor(pinsStackView, attribute: .trailing, value: -style.buttonSize.width, toView: containerStackView)
        
        errorLabel.font = style.errorLabelFont
        errorLabel.textColor = style.errorTextColor
        errorLabel.alpha = 0.0
        isPasscodeValid = { [weak weakSelf = self] result in
            weakSelf?.errorLabel.alpha = result ? 0.0 : 1.0
            if !result {
                weakSelf?.invalidAnimation(for: (weakSelf?.pinsStackView)!, initialFrame: (weakSelf?.pinsStackView.frame)!, step: 60.0)
            }
        }
        containerStackView.addArrangedSubview(errorLabel)
        
        var tmpStackView = stackView(withAxis: .horizontal)
        for i in 1...12 {
            tmpStackView.addArrangedSubview(button(withTag: i))
            if i%3 == 0 {
                containerStackView.addArrangedSubview(tmpStackView)
                _ = Constants.constraintFor(tmpStackView, attribute: .leading, toView: containerStackView)
                _ = Constants.constraintFor(tmpStackView, attribute: .trailing, toView: containerStackView)
                tmpStackView = stackView(withAxis: .horizontal)
            }
        }
        
        addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        _ = Constants.constraintFor(containerStackView, attribute: .leading, toView: self)
        _ = Constants.constraintFor(containerStackView, attribute: .trailing, toView: self)
        _ = Constants.constraintFor(containerStackView, attribute: .top, toView: self)
        _ = Constants.constraintFor(containerStackView, attribute: .bottom, toView: self)
        
    }
    
    
    private func setupContent() {
        titleLabel.text = content.titleText
        errorLabel.text = content.errorMessage
    }
    
    
    private func stackView(withAxis axis: NSLayoutConstraint.Axis) -> UIStackView {
        let result = UIStackView()
            result.alignment = .center
            result.distribution = .equalSpacing
            result.axis = axis
        return result
    }
    
    
    private func attributedStyle(for text: String, font: UIFont, color: UIColor) -> NSMutableAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center
            paragraphStyle.lineSpacing = 0
        
        return NSMutableAttributedString(string: String(text),
                                         attributes: [NSAttributedString.Key.font: font,
                                                      NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                      NSAttributedString.Key.foregroundColor: color])
    }
    
    
    private func button(withTag tag: Int) -> UIButton {
        var finalTag = tag
        switch tag {
            case 11: finalTag = 0
            case 12: finalTag = 11
            default: break
        }
        
        let result = UIButton()
            result.tag = finalTag
            result.clipsToBounds = true
            result.backgroundColor = style.buttonBGColor
            result.setBackgroundColor(color: style.buttonBGColorHigh, forState: .highlighted)
            result.layer.cornerRadius = style.buttonSize.width / 2.0
            result.layer.borderColor = style.buttonBorderColor.cgColor
            result.layer.borderWidth = style.buttonBorderWidth
            result.setTitleColor(style.buttonTextColor, for: .normal)
            result.setTitleColor(style.buttonTextColorHigh, for: .highlighted)
            result.titleLabel?.font = style.buttonNumberFont
            result.titleLabel?.textAlignment = .center
            result.titleLabel?.lineBreakMode = .byWordWrapping
            result.addTarget(self, action: #selector(unhighlightBorder(_:)), for: .touchDown)
        
        if let buttonTitle = 0...9 ~= finalTag ? String(finalTag) : nil {
            result.setTitle(buttonTitle, for: .normal)
            result.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        }  else if finalTag == 10 {
            if touchIDType != TouchIDType.none {
                let img = UIImage(named: "touchID", in: Bundle(for: type(of: self)), compatibleWith: nil)
                
                result.setImage(img?.tintPictogram(with: style.buttonTextColor), for: .normal)
                result.setImage(img?.tintPictogram(with: style.buttonTextColorHigh), for: .highlighted)
                result.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
                
            } else {
                result.layer.borderWidth = 0.0
                result.backgroundColor = .clear
                result.setBackgroundColor(color: .clear, forState: .highlighted)
            }
        } else if finalTag == 11 {
            let img = UIImage(named: "delete", in: Bundle(for: type(of: self)), compatibleWith: nil)
            result.setImage(img?.tintPictogram(with: style.buttonTextColor), for: .normal)
            result.setImage(img?.tintPictogram(with: style.buttonTextColorHigh), for: .highlighted)
            result.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        }
        
        //Set Constraints
        _ = Constants.constraintFor(result, attribute: .width, value: style.buttonSize.width)
        _ = Constants.constraintFor(result, attribute: .height, value: style.buttonSize.height)
        
        return result
    }
    
    private func dotView(_ target: DotView, setNewTag tag: Int) {
        target.tag = tag
        target.isFilled = tag != emptyValue
    }
    
    private func cleanInputs() {
        dotViews.forEach( { dotView($0, setNewTag: emptyValue) })
    }
    
    private func invalidAnimation(for subview: UIView, initialFrame: CGRect, step: CGFloat) {
        if step != 0.0 {
            UIView.animate(withDuration: 0.075, animations: {
                var newFrame = initialFrame
                newFrame.origin.x -= step
                subview.frame = newFrame
            }) { (Success) in
                UIView.animate(withDuration: 0.075, animations: {
                    var newFrame = initialFrame
                    newFrame.origin.x += step
                    subview.frame = newFrame
                }) { [weak weakSelf = self] (Success) in
                    weakSelf?.invalidAnimation(for: subview, initialFrame: initialFrame, step: step-30.0)
                }
            }
        } else {
            subview.frame = initialFrame
            cleanInputs()
        }
        
    }
    
    public func retypeCode() {
        cleanInputs()
        titleLabel.text = content.retypeMessage
    }
    
    
//    MARK: - Action methods
    
    @objc private func buttonDidTapped(_ sender: UIButton) {
        sender.layer.borderColor = style.buttonBorderColor.cgColor
        errorLabel.alpha = 0.0
        switch sender.tag {
        case 0...9:
            for i in 0..<dotViews.count {
                if dotViews[i].tag == emptyValue {
                    dotView(dotViews[i], setNewTag: sender.tag)
                    if i == dotViews.count - 1 {
                        completeHandler?(.passcode(enteredPasscode))
                    }
                    break
                }
            }
        case AdditionalButton.touchID.rawValue:
            completeHandler?(.touchID)
        case AdditionalButton.eraseAll.rawValue:
            cleanInputs()
        default:
            break
        }
    }
    
    @objc private func unhighlightBorder(_ sender: UIButton) {
        sender.layer.borderColor = UIColor.clear.cgColor
    }
}
