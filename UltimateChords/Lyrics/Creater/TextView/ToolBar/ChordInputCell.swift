//
//  ChordInputCell.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/4/22.
//

import UIKit

class ChordInputCell: UICollectionViewCell {
    
    private let label = UILabel()
    private let imageView = UIImageView()
    
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .white : textColor
            contentView.backgroundColor = isSelected ? UIColor.tintColor : UIColor.systemBackground
        }
    }
    
    private var textColor = UIColor.label {
        didSet {
            isSelected = isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        imageView.image = nil
        label.text = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds.insetBy(dx: 5, dy: 5)
        label.frame = bounds.insetBy(dx: 3, dy: 3)
    }
}

extension ChordInputCell {
    private func commonInit() {
        contentView.backgroundColor = UIColor.systemBackground
        label.adjustsFontSizeToFitWidth = true
        contentView.layer.cornerRadius = 10
        label.textAlignment = .center
        label.font = .init(name: "NotoSansMonoExtraCondensed-SemiBold", size: UIFont.labelFontSize - 1)!
        contentView.addSubview(label)
        
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration.init(pointSize: 22, weight: .regular, scale: .large)
        contentView.addSubview(imageView)
    }
    
    func configure(text: String, section: ChordsInputView.Section) {
        if section == .control {
            if let control = ChordsInputView.ControlKind(rawValue: text) {
                imageView.image = UIImage(systemName: control.iconName.systemName)
            }
        } else {
            label.text = text
            label.font = section.labelFont
            textColor = section.textColor
        }
    }
}

