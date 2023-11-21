//
//  RouteFindingThumbnailCollectionView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/25.
//

import UIKit
import Then
protocol RouteFindingThumbnailCollectionViewCellDelegate {
    func enterDeletePageMode(indexPath: IndexPath)
}

final class RouteFindingThumbnailCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static let identifier: String = "RouteFindingThumbnailCollectionViewCell"
    
    var delegate: RouteFindingThumbnailCollectionViewCellDelegate?
    var indexPathOfCell: IndexPath!
    
    private let collectionViewCellSize: Int = 62
    
    // MARK: View Components
    
    lazy var pageImage: UIImageView = .init().then {
        $0.backgroundColor = .white
    }
    
    private lazy var selectedBar: UIView = .init().then {
        $0.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
    }
    
    // MARK: Life Cycle Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setGestureRecognizer()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        selectedBar.backgroundColor = .clear
    }
    
    // MARK: Functions
    
    func showSelectedBar() {
        UIView.animate(withDuration: 0.2) {
            self.selectedBar.backgroundColor = .orrUPBlue
        }
    }
    
    func hideSelectedBar() {
        UIView.animate(withDuration: 0.2) {
            self.selectedBar.backgroundColor = .clear
        }
    }
    
    // MARK: @objc Functions
    
    @objc func pressDeleteButton(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.enterDeletePageMode(indexPath: indexPathOfCell)
        }
    }
    
    // MARK: Set Up Functions
    
    private func setUpLayout() {
        contentView.addSubview(pageImage)
        pageImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(selectedBar)
        selectedBar.snp.makeConstraints {
            $0.width.equalTo(collectionViewCellSize)
            $0.height.equalTo(4)
            $0.top.equalTo(pageImage.snp.bottom).offset(2)
        }
    }
    
    private func setGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressDeleteButton(_:)))
        
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.allowableMovement = 40
        
        contentView.addGestureRecognizer(longPressGesture)
    }
}

protocol RouteFindingThumbnailCollectionViewAddCellDelegate {
    func tapAddPageButton()
}

class RouteFindingThumbnailCollectionViewAddCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static let identifier: String = "RouteFindingThumbnailCollectionViewAddCell"
    
    var delegate: RouteFindingThumbnailCollectionViewAddCellDelegate?
    
    private let collectionViewCellSize: Int = 62
    
    // MARK: View Components
    
    private lazy var button: UIButton = .init().then {
        $0.frame = CGRect(x: 0, y: 0, width: collectionViewCellSize, height: collectionViewCellSize)
        $0.setImage(UIImage(systemName: "plus.circle.fill")?.resized(to: CGSize(width: 24, height: 24)).withTintColor(.orrWhite!, renderingMode: .alwaysTemplate), for: .normal)
        $0.tintColor = .orrWhite
        $0.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
    }
    
    // MARK: Life Cycle Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .orrGray600
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: @objc Functions
    
    @objc func tapAddButton(_ sender: UIButton) {
        delegate?.tapAddPageButton()
    }
    
    // MARK: Set Up Functions
    
    private func setUpLayout() {
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
