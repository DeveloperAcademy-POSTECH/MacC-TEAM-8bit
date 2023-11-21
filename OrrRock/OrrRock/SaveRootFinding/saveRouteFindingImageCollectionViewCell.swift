//
//  SaveRouteFindingImageCollectionViewCell.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/27.
//

import UIKit
import SnapKit
import Then

class SaveRouteFindingImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static let identifier: String = "SaveRouteFindingImageCollectionViewCell"
    
    var indexPathOfCell: IndexPath!
    
    let collectionViewCellwidth: Int = 58
    
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: View Components
    
    lazy var pageImage: UIImageView = .init().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
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
    
    // MARK: Set Up Functions
    
    func setUpLayout() {
        contentView.addSubview(pageImage)
        pageImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        if screenHeight > 800 {
            contentView.addSubview(selectedBar)
            selectedBar.snp.makeConstraints {
                $0.width.equalTo(collectionViewCellwidth)
                $0.height.equalTo(4)
                $0.top.equalTo(pageImage.snp.bottom).offset(OrrPd.pd8.rawValue)
            }
        }
    }
}
