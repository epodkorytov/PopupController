//
//  PopUpController+Picker.swift
//  PopUpController
//

import UIKit
import Extensions

extension PopUpController {
    private struct AssociatedKeys {
        static var picker: UInt8 = 0
        static var pickerViewStyle: PickerViewStyle! = PickerViewStyleDefault()
    }
    
    //
    public var pickerViewStyle: PickerViewStyle! {
        get {
            return getAssociatedObject(&AssociatedKeys.pickerViewStyle, defaultValue: AssociatedKeys.pickerViewStyle)
        }
        set {
            return objc_setAssociatedObject(self, &AssociatedKeys.pickerViewStyle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var picker: PickerView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.picker) as? PickerView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.picker,
                                         newValue,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var contentPicker: ContentPickerView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.picker) as? ContentPickerView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.picker,
                                         newValue,
                                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    // MARK: - DatePicker
    public func presentTimePicker(title: String,
                                  selectedDate: Date? = nil,
                                  completeHandler: @escaping PopUpControllerCompleteHandlerGeneric<Date>) {
        
        self.style = pickerViewStyle
        
        picker = PickerView(title: title, style: pickerViewStyle, selectedDate: selectedDate,
                            completeHandler: { answerType, answerObject in
                                self.hide { completeHandler(answerType, answerObject) }
        },
                            didCreate: { view in
                                self.present(view, hideOnTouch: true)
        })
    }
    
    public func presentDatePicker(title: String,
                                  selectedDate: Date? = nil,
                                  startDate: Date? = nil,
                                  endDate: Date? = nil,
                                  completeHandler: @escaping PopUpControllerCompleteHandlerGeneric<Date>) {
        
        self.style = pickerViewStyle
        
        picker = PickerView(title: title, datePickerMode: .date, style: pickerViewStyle,
                            selectedDate: selectedDate,
                            startDate: startDate,
                            endDate: endDate,
                            completeHandler: { answerType, answerObject in
                                self.hide { completeHandler(answerType, answerObject) }
        },
                            didCreate: { view in
                                self.present(view, hideOnTouch: true)
        })
    }
    
    // MARK: - PickerView
    
    public func presentPicker(title: String,
                              dataSource: DataSource<DataSourceBaseItem>,
                              completeHandler: @escaping PopUpControllerCompleteHandlerGeneric<DataSourceBaseItem>) {
        self.style = pickerViewStyle
        
        contentPicker = ContentPickerView(title: title, style: pickerViewStyle, dataSource: dataSource, completeHandler: { answerType, answerObject in
            self.hide { completeHandler(answerType, answerObject) }
        }, didCreate: { view in
            self.present(view, hideOnTouch: true)
        })
    }
    
}
