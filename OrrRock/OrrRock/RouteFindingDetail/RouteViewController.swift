//
//  RoutePageView.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/29.
//

import UIKit

import SnapKit
import Then

class RouteViewController: UIViewController {
    
    // MARK: Variables
    
    var pageInfo: PageInfo
    var backgroundImage: UIImage?
    
    // MARK: View Components
    
    private lazy var backgroundView: UIImageView = .init().then {
        $0.image = backgroundImage
    }
    
    private lazy var placeholderView: UIView = .init().then {
        let warningLabel = UILabel()
        warningLabel.text = "앨범에서 사진이 삭제되어\n해당 사진을 불러올 수 없습니다."
        warningLabel.textColor = .orrGray400
        warningLabel.textAlignment = .center
        warningLabel.numberOfLines = 2
        warningLabel.backgroundColor = .white
        $0.addSubview(warningLabel)
        warningLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    lazy var pageView: UIView = {
        convertPageInfoToPageView(from: pageInfo)
    }()
    
    // MARK: Life Cycle Functions
    
    init(pageInfo: PageInfo, backgroundImage: UIImage?) {
        self.pageInfo = pageInfo
        self.backgroundImage = backgroundImage
        
        super.init(nibName: nil, bundle: nil)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Functions
    
    private func convertPageInfoToPageView(from pageInfo: PageInfo) -> UIView {
        let view = UIView()
        
        pageInfo.points.forEach { pointInfo in
            let button = pointInfo.footOrHand == .hand ? RouteFindingFeatureHandButton() : RouteFindingFeatureFootButton()
            button.isUserInteractionEnabled = false
            
            view.addSubview(button)
            button.snp.makeConstraints{
                $0.centerX.equalTo(pointInfo.position.x)
                $0.centerY.equalTo(pointInfo.position.y)
            }
        }
        
        return view
    }
    
    // MARK: @objc Functions
    
    
}

extension RouteViewController {
    
    // MARK: Set Up Functions
    
    func setUpLayout() {
        // AVPlayerLayer의 뒤에 위치할 뷰
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if backgroundImage == nil {
            view.addSubview(placeholderView)
            placeholderView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            view.addSubview(pageView)
            pageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
