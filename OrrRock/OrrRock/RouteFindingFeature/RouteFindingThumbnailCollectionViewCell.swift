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

class RouteFindingThumbnailCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "RouteFindingThumbnailCollectionViewCell"
    
    var delegate: RouteFindingThumbnailCollectionViewCellDelegate?
    var indexPathOfCell: IndexPath!
    
    lazy var pageImage: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var selectedBar: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setGestureRecognizer()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        contentView.addSubview(pageImage)
        pageImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(selectedBar)
        selectedBar.snp.makeConstraints {
            $0.width.equalTo(62)
            $0.height.equalTo(5)
            
            $0.top.equalTo(pageImage.snp.bottom).offset(2)
        }
    }
    
    func setGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressDeleteButton(_:)))

        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.allowableMovement = 40

        contentView.addGestureRecognizer(longPressGesture)
    }
    
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
    
    override func prepareForReuse() {
        selectedBar.backgroundColor = .clear
    }
    
    @objc func pressDeleteButton(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.enterDeletePageMode(indexPath: indexPathOfCell)
        }
    }
}

protocol RouteFindingThumbnailCollectionViewAddCellDelegate {
    func tapAddPageButton()
}

class RouteFindingThumbnailCollectionViewAddCell: UICollectionViewCell {
    static let identifier: String = "RouteFindingThumbnailCollectionViewAddCell"
    
    var delegate: RouteFindingThumbnailCollectionViewAddCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        button.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
        return button
    }()
    
    func setUpLayout() {
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func tapAddButton(_ sender: UIButton) {
        delegate?.tapAddPageButton()
    }
}
