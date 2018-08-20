//
//  SelectorDataSource.swift
//  PopUpController
//


import Foundation
import Extensions

public extension DataSource {
    
    
    public convenience init(with range: Range<Int>, selectedValue: Int? = nil) {
        self.init()
        self.items = Array<T>()
        var selectedIds: [Int] = []
        if let selectedValue = selectedValue {
            let selectedIndex = selectedValue - range.lowerBound
            selectedIds.append(selectedIndex)
        }
        
        for (idx, element) in Array(range.lowerBound...range.upperBound).enumerated() {
            self.items.append(T.self(id: element, title: String(element), selected: selectedIds.contains(idx)))
        }
    }
}
