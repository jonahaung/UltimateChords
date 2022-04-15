//
//  ChordsInputView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/4/22.
//

import UIKit
import SwiftyChords

class ChordsInputView: UIView {
    
    weak var textView: UITextView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureHierarchy()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    private let keys = Chords.Key.allCases
    private let suffixs = Chords.Suffix.allCases
    private let controls = ControlKind.allCases
    
    
    
}

extension ChordsInputView {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        self.addSubview(collectionView)
    }
    /// - Tag: Grid
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionLayoutKind = Section(rawValue: sectionIndex) else { return nil }
            let rows = sectionLayoutKind.rowsCount
            
            // The group auto-calculates the actual item width to make
            // the requested number of columns fit, so this widthDimension is ignored.
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
            
            let groupSize = NSCollectionLayoutSize(widthDimension: sectionLayoutKind == .control ? .estimated(UIScreen.main.bounds.width/CGFloat(self.controls.count) - 5) : sectionLayoutKind == .key ? .estimated(40) : .estimated(60),
                                                   heightDimension: sectionLayoutKind == .suffix ? .fractionalWidth(0.4) : .estimated(40))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: rows)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0)
            return section
        }
        return layout
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ChordInputCell, String> { [self] (cell, indexPath, identifier) in
            let section = Section(rawValue: indexPath.section)
            cell.configure(text: identifier, section: section ?? .key)
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            switch section {
            case .key:
                snapshot.appendItems(keys.map{$0.rawValue}, toSection: section)
            case .suffix:
                snapshot.appendItems(suffixs.map{ $0.rawValue}, toSection: section)
            case .control:
                snapshot.appendItems(controls.map{$0.rawValue}, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func selectedKey() -> Chords.Key? {
        if let indexPath = collectionView.indexPathsForSelectedItems?.filter({ $0.section == Section.key.rawValue }).first {
            return keys[indexPath.item]
        }
        return nil
    }
    
    private func selectedSuffix() -> Chords.Suffix? {
        if let indexPath = collectionView.indexPathsForSelectedItems?.filter({ $0.section == Section.suffix.rawValue }).first {
            return suffixs[indexPath.item]
        }
        return nil
    }
    
    private func updateTextView() {
        guard let textView = textView else { return }
        if let key = selectedKey() {
            let suffix = selectedSuffix()
            let text = (key.rawValue + (suffix?.rawValue.replacingOccurrences(of: "minor", with: "m") ?? "")).bracked
            textView.setMarkedText(text, selectedRange: textView.selectedRange)
            
        } else {
            textView.selectedRange = textView.selectedRange
        }
    }
    
    private func reloadControls() {
        var snapshop = dataSource.snapshot()
        snapshop.reloadSections([.control])
        dataSource.apply(snapshop, animatingDifferences: true)
    }
    private func deselectAll() {
        collectionView.indexPathsForSelectedItems?.compactMap{ $0 }.forEach {
            collectionView.deselectItem(at: $0, animated: true)
        }
        reloadControls()
    }
}

extension ChordsInputView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = Section(rawValue: indexPath.section)
        switch section {
        case .control:
            
            let control = controls[indexPath.item]
            switch control {
            case .Back:
                textView?.deleteBackward()
                deselectAll()
            case .Add:
                if let textView = self.textView, let range = textView.markedTextRange, let markedText = textView.text(in: range) {
                    textView.insertText(markedText)
                }
                deselectAll()
            case .Done:
                textView?.inputView = nil
                textView?.reloadInputViews()
            }
            
        case .key:
            collectionView.indexPathsForSelectedItems?.filter{ $0.section == section?.rawValue && $0.item != indexPath.item }.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }
        case .suffix:
            collectionView.indexPathsForSelectedItems?.filter{ $0.section == section?.rawValue && $0.item != indexPath.item }.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }
        case .none:
            break
        }
        updateTextView()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) == true {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        }
        let section = Section(rawValue: indexPath.section)
        switch section {
        case .suffix:
            let keyIndexPaths = collectionView.indexPathsForSelectedItems?.filter{ $0.section == Section.key.rawValue }
            return keyIndexPaths.isNilOrEmpty ? false : true
        default:
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        switch section {
        case .key:
            deselectAll()
            updateTextView()
        default:
            break
        }
    }
}
// Enums
extension ChordsInputView {
    enum Section: Int, CaseIterable {
        case key, suffix, control
        var rowsCount: Int {
            switch self {
            case .key:
                return 1
            case .suffix:
                return 5
            case .control:
                return 1
            }
        }
        var labelFont: UIFont {
            switch self {
            case .control:
                return UIFont.preferredFont(forTextStyle: .headline)
            case .key:
                return .init(name: "NotoSansMonoExtraCondensed-SemiBold", size: UIFont.labelFontSize)!
            case .suffix:
                return .init(name: "NotoSansMonoExtraCondensed-Medium", size: UIFont.systemFontSize)!
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .control:
                return .tintColor
            case .key:
                return .tintColor
            case .suffix:
                return .label
            }
        }
    }
    
    enum ControlKind: String, CaseIterable {
        case Back, Add, Done
    }
}
extension String {
    
    var bracked: String {
        "[\(self)]"
    }
}
class ChordInputCell: UICollectionViewCell {
    
    private let label = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.tintColor : UIColor.systemBackground
            label.textColor = isSelected ? .white : textColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            label.isHidden = isHighlighted
        }
    }
    
    private var textColor = UIColor.label {
        didSet {
            label.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    }
    
    func configure(text: String, section: ChordsInputView.Section) {
        label.text = text
        label.font = section.labelFont
        textColor = section.textColor
    }
}
