//
//  PopUpController+SelectorStyle.swift
//  PopUpController
//

import Foundation
import UIKit

public protocol SelectorViewTopBarStyle: PopUpControllerStyle {
    var backgroundColor: UIColor { get set }
    
    var titleFont: UIFont { get set }
    var titleColor: UIColor { get set }
    
    var titleButtonFont: UIFont { get set }
    var titleButtonColor: UIColor { get set }
    
    var titleButton: String { get set }
    var topBarHieght: CGFloat { get set }
}

public protocol SelectorCellStyle {
    var titleFont: UIFont { get set }
    var titleColor: UIColor { get set }
    
    var imageNornal: UIImage? { get set }
    var imageSelected: UIImage? { get set }
    var placeholder: UIImage? { get set }
}

public protocol SelectorViewStyle: PopUpControllerStyle {
    var width: CGFloat { get set }
    var minHieght: CGFloat { get set }
    var maxHieght: CGFloat { get set }
    
    var topBarStyle: SelectorViewTopBarStyle { get set }
    
    //table settings
    var separatorStyle: UITableViewCell.SeparatorStyle { get set }
    var separatorColor: UIColor { get set }
    var separatorInset: UIEdgeInsets { get set }
    var cellStyle: SelectorCellStyle { get set }
}

//MARK:Default style
public struct SelectorViewTopBarStyleDefault: SelectorViewTopBarStyle {
    public var popupBackgroundColor = UIColor.white
    public var cornerRadius: CGFloat = 5.0
    public var backgroundColor: UIColor = .blue
    
    public var titleFont: UIFont  = UIFont.boldSystemFont(ofSize: 16)
    public var titleColor: UIColor = .white
    
    public var titleButtonFont: UIFont  = UIFont.systemFont(ofSize: 14)
    public var titleButtonColor: UIColor = .white
    public var titleButton: String = "Select"
    public var topBarHieght: CGFloat = 44.0
    
    public init() { }
}

public struct SelectorCellStyleDefault: SelectorCellStyle {
    public var titleFont: UIFont  = UIFont.systemFont(ofSize: 16)
    public var titleColor: UIColor = .black
    
    public var imageNornal: UIImage? = nil
    public var imageSelected: UIImage? = nil
    public var placeholder: UIImage? = nil
}

public struct SelectorViewStyleDefault: SelectorViewStyle {
    public var cellStyle: SelectorCellStyle = SelectorCellStyleDefault()
    public var backgroundColor = UIColor(white: 0.1, alpha: 0.3)
    public var popupBackgroundColor = UIColor.white
    public var cornerRadius: CGFloat = 5.0
    
    public var width: CGFloat = 300.0
    public var minHieght: CGFloat = 2*44.0
    public var maxHieght: CGFloat = 380.0
    
    public var topBarStyle: SelectorViewTopBarStyle = SelectorViewTopBarStyleDefault()
    
    public var separatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    public var separatorColor: UIColor = .red
    public var separatorInset: UIEdgeInsets = UIEdgeInsets.zero
    
}
