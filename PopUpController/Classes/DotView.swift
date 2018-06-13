//
//  DotView.swift
//  PopUpController
//
import UIKit

public class DotView: UIView {
    
    //    MARK: Variables
    
    public var isFilled: Bool = false {
        didSet {
            backgroundColor = isFilled ? dotColor : .clear
            layer.borderWidth = 1.0
            layer.borderColor = dotColor.cgColor
        }
    }
    
    private var dotColor: UIColor!
    
    //    MARK: - Overriden methods
    
    public init(dotColor: UIColor) {
        super.init(frame: .zero)
        self.dotColor = dotColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
