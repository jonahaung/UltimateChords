//
//  ChordsInputView.swift
//  UltimateChords
//
//  Created by Aung Ko Min on 15/4/22.
//

import UIKit
import SwiftyChords

class ChordsInputView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureHierarchy()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var textView: UITextView?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: UICollectionView! = nil
    private let keys = Instrument.guitar.keys
    private let suffixs = Instrument.guitar.suffixes
    private let controls = ControlKind.allCases
}

extension ChordsInputView {
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
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
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionItem = Section(rawValue: sectionIndex) else { return nil }
            let rows = sectionItem.rowsCount
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = Constants.itemInsets
            
            let groupSize = NSCollectionLayoutSize(widthDimension: sectionItem.widthDimention, heightDimension: sectionItem.heightDimention)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: rows)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = Constants.sectionInsets
            
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ChordInputCell, String> { [self] (cell, indexPath, identifier) in
            guard let section = Section(rawValue: indexPath.section) else { return }
            cell.configure(text: identifier, section: section)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            switch section {
            case .key:
                snapshot.appendItems(keys.map{ $0 }, toSection: section)
            case .suffix:
                snapshot.appendItems(suffixs.map{ $0.localisedSuffix }, toSection: section)
            case .control:
                snapshot.appendItems(controls.map{$0.rawValue }, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ChordsInputView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .control:
            
            let control = controls[indexPath.item]
            switch control {
            case .Back:
                if textView?.markedTextRange != nil {
                    textView?.removeMarkedText()
                } else {
                    textView?.deleteBackward()
                }
            case .Space:
                textView?.insertSpace()
            case .Undo:
                textView?.undo()
            }
            if textView?.markedTextRange == nil {
                collectionView.deselectAll()
            } else {
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        case .key:
            collectionView.indexPathsForSelectedItems?.filter{ $0.section == section.rawValue && $0.item != indexPath.item }.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }
        case .suffix:
            collectionView.indexPathsForSelectedItems?.filter{ $0.section == section.rawValue && $0.item != indexPath.item }.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }
        }
        updateTextView()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let section = Section(rawValue: indexPath.section) else { return false }
        
        if section == .suffix {
            return selectedKey() != nil
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        if section == .key {
            collectionView.deselectAll()
        }
        updateTextView()
    }
    
    private func selectedKey() -> String? {
        if let indexPath = collectionView.indexPathsForSelectedItems?.filter({ $0.section == Section.key.rawValue }).first {
            return keys[indexPath.item]
        }
        return nil
    }
    
    private func selectedSuffix() -> String? {
        if let indexPath = collectionView.indexPathsForSelectedItems?.filter({ $0.section == Section.suffix.rawValue }).first {
            return suffixs[indexPath.item]
        }
        return nil
    }
    
    private func updateTextView() {
        if let key = selectedKey() {
            let suffix = selectedSuffix()?.localisedSuffix ?? String()
            let text = (key + suffix).bracked
            textView?.setMarkedText(text)
        } else {
            textView?.removeMarkedText()
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
        
        var widthDimention: NSCollectionLayoutDimension {
            switch self {
            case .key:
                return .estimated(40)
            case .suffix:
                return .estimated(60)
            case .control:
                return .estimated((UIScreen.main.bounds.width / CGFloat(ControlKind.allCases.count)) - Constants.sectionInsets.leading + Constants.itemInsets.leading)
            }
        }
        
        var heightDimention: NSCollectionLayoutDimension {
            switch self {
            case .key:
                return .estimated(40)
            case .suffix:
                return .fractionalWidth(0.4)
            case .control:
                return .estimated(40)
            }
        }
        
    }
    
    enum ControlKind: String, CaseIterable {
        case Undo, Space, Back
        
        var iconName: XIcon.Icon {
            switch self {
            case .Back:
                return .delete_left_fill
            case .Undo:
                return .gobackward
            case .Space:
                return .empty
            
            }
        }
    }
    
    struct Constants {
        static let itemInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        static let sectionInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0)
    }
}


