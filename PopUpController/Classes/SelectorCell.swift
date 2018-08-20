//
//  SelectorCell.swift
//  PopUpController
//
import UIKit
import Extensions
import ImageExtended

public class SelectorCell: UITableViewCell {
    public var hideAccessory: Bool = false
    public var content: DataSourceBaseItem? {
        didSet {
                    setupContent(content)
               }
        }

    fileprivate var style: SelectorCellStyle = SelectorCellStyleDefault()

    //MARK: - Overriden methods

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
        imageView?.image = nil
    }

    deinit {
        content = nil
    }

    //
    fileprivate func setupContent(_ content: DataSourceBaseItem?) {
        guard let content = content else { return }
        
        if let item = content as? DataSourceItem<UIColor> {
            let color = item.value
            
            imageView?.image = UIImage()
            imageView?.backgroundColor = color
            
            if content.selected {
                accessoryType = hideAccessory ? .none : .checkmark
            } else {
                accessoryType = .none
            }
        } else if let item = content as? DataSourceItem<URL> {
            imageView?.image = style.placeholder ?? UIImage()
            if let url = item.value {
                imageView?.image(stringOrURL: url,
                                 placeholderType: .activityIndicator(type: .infinit))
            }
            
            if content.selected {
                accessoryType = hideAccessory ? .none : .checkmark
            } else {
                accessoryType = .none
            }
        } else {
            if content.selected {
                if let imageSelected = style.imageSelected {
                    imageView?.image = imageSelected
                } else {
                    accessoryType = hideAccessory ? .none : .checkmark
                }
            } else {
                if let imageNormal = style.imageNornal {
                    imageView?.image = imageNormal
                } else {
                    accessoryType = .none
                }
            }
        }
        textLabel?.attributedText = NSAttributedString(string: content.title,
                                                       attributes: [NSAttributedString.Key.foregroundColor : style.titleColor, NSAttributedString.Key.font: style.titleFont])
    }
    
    fileprivate func setupUI() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView, let _ = imageView.image else { return }
        let indent: CGFloat = 10.0
        let dimension = frame.height - indent
        let original = CGPoint(x: indent, y: indent/2)
        
        imageView.frame = CGRect(origin: original, size: CGSize(width: dimension, height: dimension))
        imageView.contentMode = .scaleAspectFit
        
        textLabel?.frame.origin = CGPoint(x: imageView.frame.maxX + indent, y: (textLabel?.frame.origin.y)!)
        
        if content is DataSourceItem<UIColor> {
            imageView.layer.cornerRadius = imageView.frame.size.height/2
        } else if content is DataSourceItem<URL> {
            
        }
    }
}
