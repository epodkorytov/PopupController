//
//  ContentPickerView.swift
//  PopUpController
//
import UIKit
import Extensions

public class ContentPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    public typealias T = DataSourceBaseItem
    
    public var title: String
    public var completeHandler: PopUpControllerCompleteHandlerGeneric<T>?
    
    fileprivate let topBar = SelectorTopBar()
    fileprivate let picker = UIPickerView()
    fileprivate var dataSource: DataSource<T>
    fileprivate var style: PickerViewStyle = PickerViewStyleDefault()  {
        didSet {
            configureStyle()
        }
    }
    fileprivate var didCreate : ((_ view: UIView) -> Void)!
    
    //MARK: - Object lifecycle
    init(title: String,
         style: PickerViewStyle,
         dataSource: DataSource<T>,
         completeHandler: @escaping PopUpControllerCompleteHandlerGeneric<T>,
         didCreate: @escaping (_ view: UIView) -> Void)
    {
        self.title = title
        self.style = style
        self.didCreate = didCreate
        self.completeHandler = completeHandler
        self.dataSource = dataSource
        self.dataSource.multiselectable = false
        
        super.init(frame: .zero)
        
        addSubviews()
        setupConstraints()
        configureNestedComponents()
        layoutIfNeeded()
        configureDataSource()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configurators
    private func addSubviews() {
        addSubview(topBar)
        addSubview(picker)
    }
    
    fileprivate func configureStyle() {
        topBar.style = style.topBarStyle
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [topBar, picker].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        
        topBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topBar.bottomAnchor.constraint(equalTo: picker.topAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
    private func configureNestedComponents() {
        configureTopBar()
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
                self.completeHandler?(type, self.dataSource.selectedItems.first)
                break
            default: break
            }
        }
    }
    
    //MARK: - DataSource
    
    fileprivate func configureDataSource() {
        picker.delegate = self
        picker.dataSource = self
        
        if let idx = dataSource.selectedIndexes?.first {
            picker.selectRow(idx, inComponent: 0, animated: false)
        }
        
        picker.reloadData {
            self.didCreate(self)
        }
    }
    
    //MARK: - UIPickerView
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let item = dataSource.items[row]
        
        let view = SelectorCell(frame: .zero)
            view.hideAccessory = true
            view.content = item
        return view
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = dataSource.items[row]
            item.selected = true
    }
}

