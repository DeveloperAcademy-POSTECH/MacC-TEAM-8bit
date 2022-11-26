//
//  RouteFindingThumbnailCollectionView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/25.
//

import UIKit

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
    
    lazy var pageImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var selectedBar: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.backgroundColor = .clear
        return view
    }()
    
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
            $0.height.equalTo(5)
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
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: collectionViewCellSize, height: collectionViewCellSize))
        button.setImage(UIImage(systemName: "plus.circle.fill")?.resized(to: CGSize(width: 24, height: 24)).withTintColor(.orrWhite!, renderingMode: .alwaysTemplate), for: .normal)
        button.tintColor = .orrWhite
        button.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
        return button
    }()
    
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
            $0.center.equalToSuperview()
        }
    }
}
