//
//  PopUpController.swift
//  PopUpController
//

import Foundation
import UIKit

//
protocol PropertyStoring {
    
    //associatedtype T
    
    func getAssociatedObject<T>(_ key: UnsafeRawPointer!, defaultValue: T) -> T
}

extension PropertyStoring {
    func getAssociatedObject<T>(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
}
//
public enum PopUpPresentMode {
    case fullScreen
    case centered
    case frame(insets: UIEdgeInsets)
    case cellAligned(cell: UIView)
}

//

//MARK: typealias
public typealias PopUpControllerAnswer = (_ type : UIButtonAnswerType) -> Void
public typealias PopUpControllerCompleteHandler = (_ type : UIButtonAnswerType, _ answer: Any?) -> Void
public typealias PopUpControllerCompleteHandlerGeneric<T> = (_ type : UIButtonAnswerType, _ answer: T?) -> Void

open class PopUpController: UIControl, UIGestureRecognizerDelegate, PropertyStoring {
    
    fileprivate let ground      : UIControl = {
        let ground = UIControl()
            ground.translatesAutoresizingMaskIntoConstraints = false
        return ground
    }()
    
    public let owner : UIWindow = UIApplication.shared.keyWindow!
    
    fileprivate let popupView : UIView = {
        let view = UIView()
            view.isUserInteractionEnabled = true
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //
    open var style: PopUpControllerStyle = PopUpControllerStyleDefault() {
        didSet {
            configureStyle()
        }
    }
    //
    open var didHidePopup: PopUpControllerCompleteHandler?
    //
    struct Static
    {
        static var instance: PopUpController?
    }
    
    open class var sharedInstance: PopUpController
    {
        if Static.instance == nil
        {
            Static.instance = PopUpController()
        }
        
        return Static.instance!
    }
    
    //MARK: Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonElements()
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCommonElements()
        setupConstraints()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func dispose()
    {
        PopUpController.Static.instance = nil
        print("Disposed Singleton instance, token set by 0")
    }
    
    //
    fileprivate func setupCommonElements() {
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.0
        
        ground.addSubview(popupView)
        
        addSubview(ground)
        
        owner.addSubview(self)
        
        configureStyle()
    }
    
    fileprivate func configureStyle() {
        ground.backgroundColor = style.backgroundColor
        
        popupView.backgroundColor = style.popupBackgroundColor
        popupView.layer.cornerRadius = style.cornerRadius
        
    }
    
    // MARK: Constraints
    fileprivate func setupConstraints() {
        
        [.left, .right, .top, .bottom].forEach(
            { owner.addConstraint(NSLayoutConstraint( item: self,
                                                      attribute: $0,
                                                      relatedBy: .equal,
                                                      toItem: owner,
                                                      attribute: $0,
                                                      multiplier: 1.0,
                                                      constant: 0))
        })
        
        [.left, .right, .top, .bottom].forEach(
            {
                self.addConstraint(NSLayoutConstraint( item: ground,
                                                       attribute: $0,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: $0,
                                                       multiplier: 1.0,
                                                       constant: 0))
        })
    }
    
    // MARK: Show
    private func show(hideOnTouch: Bool)
    {
        if  hideOnTouch {
            let groundTouch  = UITapGestureRecognizer(target: self, action: #selector(didGroundTouch(sender:)))
                groundTouch.numberOfTapsRequired = 1
                groundTouch.delegate = self
            
            ground.addGestureRecognizer(groundTouch)
        } else {
            ground.gestureRecognizers = []
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1.0
        }) { (finished) in
            
            super.updateConstraints()
            self.layoutIfNeeded()
        }
        
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: Hide
    func hide(_ delay:TimeInterval? = 0, _ completion: @escaping((() -> Void)))
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay!)
        {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.alpha = 0.0
            }) { (finished) in
                self.removeFromSuperview()
                completion()
                self.dispose()
            }
        }
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    //
    
    // MARK: gestureRecognizer Delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if popupView.superview != nil
        {
            if touch.view!.isDescendant(of: popupView)
            {
                //allow touch only for ground
                return false
            }
        }
        return true
    }
    
    @objc fileprivate func didGroundTouch(sender: UITapGestureRecognizer? = nil) {
        hide {
            self.didHidePopup?(UIButtonAnswerType.cancel, nil)
        }
    }
    //
    fileprivate func clearPopup() {
        ground.removeConstraints(ground.constraints)
        popupView.removeConstraints(popupView.constraints)
        popupView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    //
    open func hidePopupView() {
        self.popupView.alpha = 0.0
        
    }
    
    open func showPopupView(size: CGSize) {
        UIView.animate(withDuration: 0.15, animations: {
            self.popupView.alpha = 1.0
        })
    }
    //
    open func present(_ view : UIView,
                      mode: PopUpPresentMode = .centered,
                      hideOnTouch: Bool) {
        
        //prepare popupView
        clearPopup()
        
        //prepare presented view
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        popupView.clipsToBounds = true
        popupView.addSubview(view)
        
        configureStyle()
        
        //
        var margin: CGFloat = 0
        var contentSize = CGSize.zero
        let cornerRadius = style.cornerRadius
        
        switch mode {
            case .centered, .cellAligned(_):
                contentSize = CGSize( width: view.frame.width + 2*cornerRadius, height: view.frame.height + 2*cornerRadius)
                margin = 0.0//cornerRadius
            case .fullScreen:
                popupView.layer.cornerRadius = 0.0
            default: break
        }
        
        //Add Constraints
        view.topAnchor.constraint(equalTo: popupView.topAnchor, constant: margin).isActive = true
        view.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -margin).isActive = true
        view.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: margin).isActive = true
        view.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -margin).isActive = true
        
        guard let parent = popupView.superview else { return }
        
        switch mode {
            case .fullScreen:
                popupView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
                popupView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
                popupView.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
                popupView.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
            
            case .centered:
                popupView.widthAnchor.constraint(equalToConstant: contentSize.width).isActive = true
                popupView.heightAnchor.constraint(equalToConstant: contentSize.height).isActive = true
                popupView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
                popupView.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            
            case .frame(let edgeInsets):
                popupView.topAnchor.constraint(equalTo: parent.topAnchor, constant: edgeInsets.top).isActive = true
                popupView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -edgeInsets.bottom).isActive = true
                popupView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: edgeInsets.left).isActive = true
                popupView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -edgeInsets.right).isActive = true
            
            case .cellAligned(let cell):
                let cellFrame = owner.convert(cell.frame, from: cell.superview)
                
                //vertical layout
                let freeSpaceUnderCell = owner.frame.height - cellFrame.maxY
                let freeSpaceAboveCell = cellFrame.minY
                let isUnderCellPlaced =  freeSpaceUnderCell > freeSpaceAboveCell
                if isUnderCellPlaced {
                    popupView.topAnchor.constraint(equalTo: parent.topAnchor, constant: cellFrame.maxY).isActive = true
                    if (freeSpaceUnderCell - margin) > contentSize.height {
                        popupView.heightAnchor.constraint(equalToConstant: contentSize.height).isActive = true
                    } else {
                        popupView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: margin).isActive = true
                    }
                }
                else {
                    popupView.bottomAnchor.constraint(equalTo: parent.topAnchor, constant: cellFrame.minY).isActive = true
                    
                    let statusBarHeight: CGFloat = 20
                    if (freeSpaceAboveCell - statusBarHeight) > contentSize.height {
                        popupView.heightAnchor.constraint(equalToConstant: contentSize.height).isActive = true
                    } else {
                        popupView.topAnchor.constraint(equalTo: parent.topAnchor, constant: statusBarHeight).isActive = true
                    }
                }
                
                //horizontal alingment
                let freeSpaceWithLeftAlignmentToCell = owner.frame.width - cellFrame.minX
                if (freeSpaceWithLeftAlignmentToCell - margin) > contentSize.width {
                    popupView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: cellFrame.minX).isActive = true
                } else {
                    popupView.trailingAnchor.constraint(equalTo: parent.leadingAnchor, constant: cellFrame.maxX).isActive = true
                }
                popupView.widthAnchor.constraint(equalToConstant: contentSize.width).isActive = true
            }
        
        show(hideOnTouch: hideOnTouch)
    }
    
    //
    public static func dismiss(completion: @escaping((() -> Void))) {
        PopUpController.sharedInstance.hide {
            completion()
        }
    }
}

