//
//  PinViewContent.swift
//  PopUpController
//

import Foundation

public protocol PinViewContentProtocol {
    var titleText       : String { get set }
    var retypeMessage   : String { get set }
    var errorMessage    : String { get set }
}


public struct PinViewContentDefault: PinViewContentProtocol {
    public var titleText: String = "Введите код доступа"
    public var retypeMessage: String = "Повторите ввод"
    public var errorMessage: String = "Код не правильный"
    
    public init() {}
}
