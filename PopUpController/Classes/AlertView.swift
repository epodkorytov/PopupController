//
//  AlertView.swift
//  PopUpController
//

import UIKit

public class AlertView: UIView {
    //MARK: - Private
    fileprivate lazy var lbTitle: UILabel = {
        let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.backgroundColor = .clear
        return label
    }()
    
    fileprivate lazy var image: UIImageView = {
        let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.backgroundColor = .clear
        return image
    }()
    
    fileprivate let lbText: UITextView = {
        let label = UITextView()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .clear
            label.isEditable = false
            label.isUserInteractionEnabled = false
        return label
    }()
    fileprivate var buttonsView: UIStackView? = nil
    
    fileprivate var didCreate : ((_ view: UIView) -> Void)!
    
    fileprivate var img: UIImage?
    fileprivate var title: String! = ""
    fileprivate var text: String! = ""
    fileprivate var buttons: [AlertViewButtonProtocol]?
    fileprivate var completeHandler: PopUpControllerAnswer? = nil
    fileprivate var type: AlertViewType = .messageBox
    fileprivate var style: AlertViewStyle = AlertViewStyleDefault()
    
    //MARK: - Lifecycle
    public init(image: UIImage?,
                title: String?,
                text: String,
                buttons: [AlertViewButtonProtocol]?,
                type: AlertViewType,
                style: AlertViewStyle,
                completeHandler: @escaping (PopUpControllerAnswer),
                didCreate: @escaping (_ view: UIView) -> Void) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        //
        self.img = image
        self.title = title
        self.text = text
        self.type = type
        self.style = style
        self.buttons = buttons
        self.didCreate = didCreate
        self.completeHandler = completeHandler
        
        //
        setupUI()
        configureConstraints()
        configureContent()
        
        calculateFrame()
        self.didCreate(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    fileprivate func setupUI() {
        
        if let _ = img {
            addSubview(image)
        }
        
        if title.count > 0 {
            addSubview(lbTitle)
        }
        
        addSubview(lbText)
        
        if let buttons = buttons {
            if buttons.count > 0 {
                
                var buttonsControl = [UIButton]()
                buttons.forEach({ button in
                    let btn = UIButton()
                    btn.backgroundColor = .clear
                    btn.type = button
                    if button.isDefault {
                        btn.setTitleColor(style.buttonDefaultColor, for: .normal)
                        btn.titleLabel?.font = style.buttonDefaultFont
                    } else {
                        btn.setTitleColor(style.buttonColor, for: .normal)
                        btn.titleLabel?.font = style.buttonFont
                    }
                    
                    btn.translatesAutoresizingMaskIntoConstraints = false
                    btn.action = {
                        guard let answerType = btn.type?.answerType else { return }
                        
                        self.completeHandler?(answerType)
                    }
                    buttonsControl.append(btn)
                })
                
                buttonsView = UIStackView(arrangedSubviews: buttonsControl)
                buttonsView?.axis = .horizontal
                buttonsView?.distribution = .fillEqually
                buttonsView?.alignment = .fill
                buttonsView?.spacing = 8
                buttonsView?.translatesAutoresizingMaskIntoConstraints = false
                addSubview(buttonsView!)
            }
        }
        
    }
    
    fileprivate func configureConstraints() {
        
        let hasImage: Bool = image.superview != nil
        let hasTitle: Bool = lbTitle.superview != nil
        
        if hasImage == true {
            image.topAnchor.constraint(equalTo: topAnchor, constant: style.padding.top).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            image.widthAnchor.constraint(equalToConstant: style.imageSize).isActive = true
            image.heightAnchor.constraint(equalToConstant: style.imageSize).isActive = true
            
            if hasTitle == true {
                lbTitle.topAnchor.constraint(equalTo: image.bottomAnchor, constant: style.padding.top).isActive = true
                lbText.topAnchor.constraint(equalTo: lbTitle.bottomAnchor, constant: style.padding.top).isActive = true
            }
        } else {
            if hasTitle == true {
                lbTitle.topAnchor.constraint(equalTo: topAnchor, constant: style.padding.top).isActive = true
                lbText.topAnchor.constraint(equalTo: lbTitle.bottomAnchor, constant: style.padding.top).isActive = true
            } else {
                lbText.topAnchor.constraint(equalTo: topAnchor, constant: style.padding.top).isActive = true
            }
        }
        
        if hasTitle == true {
            lbTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.padding.left).isActive = true
            lbTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: style.padding.right).isActive = true
        }
        
        lbText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.padding.left).isActive = true
        lbText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: style.padding.right).isActive = true
        
        guard let buttonsView = buttonsView else {
            lbText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: style.padding.bottom).isActive = true
            return
        }
        // add Constraints to buttonsView
        buttonsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: style.padding.bottom).isActive = true
        buttonsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.padding.left).isActive = true
        buttonsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: style.padding.right).isActive = true
        //
        lbText.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: style.padding.bottom).isActive = true
        
    }
    
    //
    fileprivate func configureContent() {
        
        if let img = img {
            image.image = img
        }
        
        if title.count > 0 {
            let titleParagraph = NSMutableParagraphStyle()
                titleParagraph.alignment = .center
            
            let attributedTitle = NSMutableAttributedString(string: title, attributes:[NSAttributedString.Key.font: style.titleFont])
                attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: style.titleColor, range: NSRange(location:0, length: title.count))
                attributedTitle.addAttributes([NSAttributedString.Key.paragraphStyle: titleParagraph], range: NSRange(location:0,length: title.count))
            lbTitle.attributedText = attributedTitle
        }
        
        let paragraph = NSMutableParagraphStyle()
        
        if type == .messageBox {
            paragraph.alignment = .left
        } else {
            paragraph.alignment = .center
        }
        
        let attributedText = NSMutableAttributedString(string: text, attributes:[NSAttributedString.Key.font: style.textFont])
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: style.textColor, range: NSRange(location:0, length: text.count))
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location:0,length: text.count))
        
        lbText.attributedText = attributedText
    }
    
    
    //MARK: - Helpers
    private func calculateFrame() {
        let width = style.width
        let textHieght = lbText.attributedText.boundingRect(with: CGSize(width: width - (abs(style.padding.left) + abs(style.padding.right)),
                                                                         height: style.maxHieght),
                                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                            context: nil).size.height
        
        var titleHieght: CGFloat = 0.0
        
        if title.count > 0 {
            titleHieght = lbTitle.attributedText!.boundingRect(with: CGSize(width: width - (abs(style.padding.left) + abs(style.padding.right)),height: style.maxHieght),
                                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                             context: nil).size.height
        }
        
        var viewHieght: CGFloat = (buttons?.count ?? 0) > 0 ? 44.0 : 0.0
            viewHieght += titleHieght
            viewHieght += textHieght + abs(style.padding.top)*2 + abs(style.padding.bottom)
        let realHieght = viewHieght
            viewHieght = min(max(style.minHieght, viewHieght), style.maxHieght)
        
        lbText.isScrollEnabled = realHieght > viewHieght
        lbText.isUserInteractionEnabled = realHieght > viewHieght
        
        frame = CGRect(origin: .zero, size: CGSize(width: width, height: viewHieght))
    }
}
