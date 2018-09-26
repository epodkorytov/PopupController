//
//  SelectorView.swift
//  PopUpController
//

import UIKit
import Extensions

public class SelectorView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    public typealias T = DataSourceBaseItem
    
    open var topBar: SelectorTopBar? = nil
    open var title: String? {
        didSet {
            configureTitle()
        }
    }
    open var completeHandler: PopUpControllerCompleteHandler?
    open var type: PopUpControllerSelectorType = .single {
        didSet {
            configureType()
        }
    }
    
    open var style: SelectorViewStyle = SelectorViewStyleDefault() {
        didSet {
            configureStyle()
        }
    }
    
    open var dataSource: DataSource<T>! {
        didSet {
            configureDataSource()
        }
    }
    
    open var forceSelect: Bool = false
    //
    fileprivate var didCreate : ((_ view: UIView) -> Void)!
    fileprivate var table: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.estimatedRowHeight    = 48.0
        table.tableHeaderView       = nil
        table.tableFooterView       = UIView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.registerCell(SelectorCell.self)
        
        return table
    }()
    fileprivate let presentationMode: PopUpPresentMode
    //MARK: Lifecycle
    public init(dataSource: DataSource<T>,
                presentationMode: PopUpPresentMode,
                style: SelectorViewStyle,
                completeHandler: @escaping (PopUpControllerCompleteHandler),
                didCreate: @escaping (_ view: UIView) -> Void) {
        self.presentationMode = presentationMode
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        //
        self.style = style
        
        self.dataSource = dataSource
        self.dataSource.multiselectable = type == .multiple
        
        self.didCreate = didCreate
        self.completeHandler = completeHandler
        
        //
        setupUI()
        configureConstraints()
        configureStyle()
        configureDataSource()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    fileprivate func setupUI() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        switch type {
            case .single:
                setupTopBar()
                addSubview(topBar!)
                
                break
            case .multiple:
                setupTopBar()
                addSubview(topBar!)
                break
            case .popup:
                topBar = nil
                break
        }
        
        addSubview(table)
    }
    
    //
    fileprivate func setupTopBar(){
        topBar = SelectorTopBar()
        topBar?.type = type
        topBar?.title = title
        topBar?.answerHandler = { type in
            switch type {
            case .cancel:
                self.completeHandler?(type, nil)
                break
            case .accept:
                self.completeHandler?(type, self.dataSource.selectedIds)
                break
            default : break
            }
        }
    }
    
    //
    fileprivate func configureConstraints() {
        removeConstraints(constraints)
        
        table.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        table.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        if let topBar = topBar {
            topBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
            topBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            topBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            table.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        } else {
            table.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }
    
    fileprivate func configureType() {
        self.dataSource.multiselectable = type == .multiple
        switch type {
            case .popup:
                topBar?.removeFromSuperview()
                topBar = nil
                configureConstraints()
                break
            default:
                topBar?.type = type
                break
        }
    }
    
    //
    fileprivate func configureTitle() {
        topBar?.title = title
    }
    //
    fileprivate func configureStyle() {
        table.separatorStyle        = style.separatorStyle
        table.separatorColor        = style.separatorColor
        table.separatorInset        = style.separatorInset
        
        topBar?.style = style.topBarStyle
    }
    //MARK:DataSource
    
    fileprivate func configureDataSource() {
        table.delegate = self
        table.dataSource = self
        
        table.reloadData {
            self.calculateFrame()
            self.didCreate(self)
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.items.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(SelectorCell.self)
            cell?.style = style.cellStyle
            cell?.content = item
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.items[indexPath.row]
            item.selected = !item.selected
        
        switch type {
            case .single:
                completeHandler?(.accept, dataSource.selectedIds)
                break
            case .multiple:
                tableView.reloadRows(at: [indexPath], with: .fade)
                break
            case .popup:
                completeHandler?(.accept, dataSource.selectedIds)
                break
        }
    }
    
    //MARK: - Helpers
    private func calculateFrame() {
        switch presentationMode {
        case .cellAligned(_):
            let viewHieght = table.contentSize.height - 11 + (type == .popup ? 0: style.topBarStyle.topBarHieght)
            
            var maxContentSizeWidth: CGFloat = style.width
            
            let maxString = dataSource.items.max{ $0.title.count < $1.title.count }?.title
            
            
            if let maxString = maxString {
                let stringAttributes = [NSAttributedString.Key.foregroundColor : style.cellStyle.titleColor,
                                        NSAttributedString.Key.font: style.cellStyle.titleFont] as [NSAttributedString.Key : Any]
                
                maxContentSizeWidth = NSAttributedString(string: maxString,
                                                         attributes: stringAttributes).size().width
            }
            let viewWidth = maxContentSizeWidth + 16 + 8
            frame = CGRect(origin: .zero, size: CGSize(width: viewWidth, height: viewHieght))
            
        default:
            var viewHieght = table.contentSize.height - 11 + (type == .popup ? 0: style.topBarStyle.topBarHieght)
            table.isScrollEnabled = viewHieght > style.maxHieght
            viewHieght = max(min(viewHieght, style.maxHieght), style.minHieght)
            frame = CGRect(origin: .zero, size: CGSize(width: style.width, height: viewHieght))
        }
    }
}
