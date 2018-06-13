//
//  SelectorTopBar.swift
//  PopUpController
//

import Foundation
import UIKit

public class SelectorTopBar: UIView {
    //MARK:Private
    //Cancel
    fileprivate let btnCancel: UIButton = {
        let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear

        let bundle = Bundle(identifier: "com.OverC.OCPopUpController")
        
        let normalImage = UIImage(named: "ic_close", in: bundle, compatibleWith: nil)
        button.setImage(normalImage, for: .normal)
        return button
    }()
    
    //Accept
    fileprivate var btnAccept: UIButton? = nil
    
    //Title
    fileprivate var lbTitle     : UILabel = {
        let label = UILabel()
        label.textAlignment   = NSTextAlignment.center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //
    fileprivate let paragraphStyle = NSMutableParagraphStyle()
    fileprivate var titleAttributes = [NSAttributedStringKey: Any]()
    fileprivate var titleButtonAttributes = [NSAttributedStringKey: Any]()
    //
    open var answerHandler: PopUpControllerAnswer!
    open var type: PopUpControllerSelectorType = .single {
        didSet {
            configureType()
        }
    }
    
    open var title: String? {
        didSet {
            configureTitle()
        }
    }
    open var style: SelectorViewTopBarStyle = SelectorViewTopBarStyleDefault() {
        didSet {
            configureStyle()
        }
    }

    //MARK: Lifecycle
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        paragraphStyle.alignment = .center
        
        setupUI()
        configureConstraints()
        configureStyle()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    fileprivate func setupUI() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        btnCancel.addTarget(self, action: #selector(btnCancelTap), for: .touchUpInside)
        
        addSubview(btnCancel)
        addSubview(lbTitle)
        
        switch type {
            case .single:
                btnAccept = nil
                break
            case .multiple:
                btnAccept = getAcceptButton()
                configureButtonTitle()
                addSubview(btnAccept!)
                break
        case .popup:
            btnAccept = nil
            break
        }
    }
    //
    fileprivate func getAcceptButton() -> UIButton {
        let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(btnDoneTap), for: .touchUpInside)
        return button
    }
    //
    fileprivate func configureConstraints() {
        subviews.forEach { (view) in
            view.removeConstraints(view.constraints)
        }
        
        btnCancel.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        btnCancel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        btnCancel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        lbTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lbTitle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lbTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lbTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/3)
        lbTitle.heightAnchor.constraint(equalToConstant: style.topBarHieght).isActive = true
        
        switch type {
            case .single:
                break
            case .multiple:
                btnAccept?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                btnAccept?.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
                break
        default:
            break
        }
    }
    //
    fileprivate func configureStyle() {
        backgroundColor = style.backgroundColor
        configureTitle()
        configureButtonTitle()
        configureConstraints()
    }
    //
    fileprivate func configureTitle() {
        titleAttributes = [NSAttributedStringKey.foregroundColor : style.titleColor, NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: style.titleFont]
        if let string = title {
            lbTitle.attributedText = NSAttributedString(string: string, attributes: titleAttributes)
        } else {
            lbTitle.attributedText = nil
        }
    }
    //
    fileprivate func configureButtonTitle(){
        titleButtonAttributes = [NSAttributedStringKey.foregroundColor : style.titleButtonColor, NSAttributedStringKey.font: style.titleButtonFont]
        if let btnAccept = btnAccept {
            let btnAcceptTitle = NSAttributedString(string: style.titleButton, attributes: titleButtonAttributes)
            btnAccept.setAttributedTitle(btnAcceptTitle, for: .normal)
        }
    }
    //
    fileprivate func configureType() {
        setupUI()
        configureConstraints()
    }
    
    //
    @objc fileprivate func btnCancelTap() {
        answerHandler(.cancel)
    }
    
    //
    @objc fileprivate func btnDoneTap() {
        answerHandler(.accept)
    }
    
}
