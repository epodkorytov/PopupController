//
//  PickerView.swift
//  PopUpController
//

import UIKit

public class PickerView: UIView {
    open var title: String
    open var completeHandler: PopUpControllerCompleteHandlerGeneric<Date>?
    open var selectedDate: Date? {
        didSet {
            if let selectedDate = selectedDate {
                timePicker.date = selectedDate
            }
        }
    }
    private let topBar = SelectorTopBar()
    
    fileprivate let timePicker = UIDatePicker()
    
    fileprivate var style: PickerViewStyle = PickerViewStyleDefault()  {
        didSet {
            configureStyle()
        }
    }
    fileprivate var didCreate : ((_ view: UIView) -> Void)!
    
    //MARK: - Object lifecycle
    init(title: String,
         datePickerMode: UIDatePickerMode = .time,
         style: PickerViewStyle,
         selectedDate: Date? = nil,
         startDate: Date? = nil,
         endDate: Date? = nil,
         completeHandler: @escaping PopUpControllerCompleteHandlerGeneric<Date>,
         didCreate: @escaping (_ view: UIView) -> Void)
    {
        self.title = title
        self.style = style
        self.didCreate = didCreate
        self.timePicker.datePickerMode = datePickerMode
        self.timePicker.minimumDate = startDate
        self.timePicker.maximumDate = endDate
        
        super.init(frame: .zero)
        
        self.selectedDate = selectedDate
        self.completeHandler = completeHandler
        
        addSubviews()
        setupConstraints()
        configureNestedComponents()
        layoutIfNeeded()
        
        self.didCreate(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configurators
    private func addSubviews() {
        addSubview(topBar)
        addSubview(timePicker)
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [topBar, timePicker].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        
        topBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topBar.bottomAnchor.constraint(equalTo: timePicker.topAnchor).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    fileprivate func configureStyle() {
        topBar.style = style.topBarStyle
    }
    
    private func configureNestedComponents() {
        configureTopBar()
        configureTimePicker()
    }
    
    fileprivate func configureTopBar(){
        topBar.type = .multiple
        topBar.title = title
        topBar.style = style.topBarStyle
        
        topBar.answerHandler = { type in
            switch type {
                case .cancel:
                    self.completeHandler?(type, nil)
                    break
                case .accept:
                    self.completeHandler?(type, self.selectedDate)
                    break
                default: break 
            }
        }
    }
    
    private func configureTimePicker() {
        timePicker.locale = style.locale
        timePicker.addTarget(self,
                             action: #selector(timePickerValueDidChanged),
                             for: .valueChanged)
    }
    
    //MARK: - User action handlers
    @objc func timePickerValueDidChanged() {
        selectedDate = timePicker.date
    }
}
