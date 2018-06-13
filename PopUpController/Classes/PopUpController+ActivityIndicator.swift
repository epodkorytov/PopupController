//
//  PopUpController+ActivityIndicator.swift
//  PopUpController
//
import Foundation
import UIKit
import Indicator

extension PopUpController {

//    MARK: - Enums
    
    public enum CircularIndicatorType {
        case infinit
        case progress
    }
    
    public enum IndicatorType {
        case slight
        case circular(type: CircularIndicatorType)
        case circularExtended(type: CircularIndicatorType, style: IndicatorStyleProtocol?)
    }
    
    //typealias T = ActivityIndicatorStyle
    
    private struct CustomProperties {
        static var activityIndicatorStyle: ActivityIndicatorStyle! = ActivityIndicatorStyleDefault()
        static var circularIndicator: Indicator?
    }
    
    public var activityIndicatorStyle: ActivityIndicatorStyle! {
        get {
            return getAssociatedObject(&CustomProperties.activityIndicatorStyle, defaultValue: CustomProperties.activityIndicatorStyle)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.activityIndicatorStyle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var circularIndicator: Indicator? {
        get {
            return getAssociatedObject(&CustomProperties.circularIndicator, defaultValue: nil)
        }
        set {
            return objc_setAssociatedObject(self, &CustomProperties.circularIndicator, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func presentIndicator(_ type: IndicatorType, _ cancelOnTap : Bool = false)
    {
        let circularIndicator: (CircularIndicatorType, IndicatorStyleProtocol?) -> UIView =
        { [weak weakSelf = self] (indicatorType, indicatorStyle) in
            var finalStyle = indicatorStyle ?? IndicatorStyleDefault()
            if indicatorType == .progress {
                finalStyle.progress = 0.1
            }
            let indicator = Indicator(style: finalStyle)
                indicator.startAnimating()
            let backgroundView = UIView()
            let margin = finalStyle.strokeWidth / 2.0
            backgroundView.frame = CGRect(origin: CGPoint(x:margin, y: margin),
                                          size: CGSize(width: finalStyle.size.width + margin * 2.0,
                                                       height: finalStyle.size.height + margin * 2.0))
            indicator.center = backgroundView.center
            backgroundView.addSubview(indicator)
            weakSelf?.circularIndicator = indicator
            return backgroundView
        }
        
        self.style = activityIndicatorStyle
        switch type {
        case .slight:
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                activityIndicator.color = activityIndicatorStyle.indicatorColor
                activityIndicator.frame = CGRect(origin: CGPoint.zero, size: activityIndicatorStyle.popupBackgroundSize)
                activityIndicator.startAnimating()
            self.present(activityIndicator, hideOnTouch: cancelOnTap)
        case .circular(let indicatorType):
            let style = IndicatorStyleDefault(strokeWidth: 2.0)
            self.present(circularIndicator(indicatorType, style), hideOnTouch: true)
        case .circularExtended(let indicatorType, let indicatorStyle):
            self.present(circularIndicator(indicatorType, indicatorStyle), hideOnTouch: true)
        }
        
    }
    
    public static func indicator(setProgress progress: CGFloat) {
        PopUpController.sharedInstance.circularIndicator?.progress = progress
    }
    
    public static func presentIndicator(type: IndicatorType = .slight, cancelOnTap : Bool = false) {
        PopUpController.sharedInstance.presentIndicator(type, cancelOnTap)
    }
}
