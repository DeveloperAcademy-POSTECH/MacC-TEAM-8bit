//
//  RoutePageView.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/29.
//

import UIKit

import SnapKit

class RouteViewController: UIViewController {
    
    // MARK: Variables
    
    var pageInfo: PageInfo
    var backgroundImage: UIImage
    
    // MARK: View Components
    
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = backgroundImage
        
        return view
    }()
    
    private lazy var placeholderView: UIView = {
        let view = UIView()
        
        let warningLabel = UILabel()
        warningLabel.text = "앨범에서 영상이 삭제되어\n해당 영상을 재생할 수 없습니다."
        warningLabel.textColor = .orrGray600
        warningLabel.textAlignment = .center
        warningLabel.numberOfLines = 2
        
        view.addSubview(warningLabel)
        warningLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var pageView: UIView = {
        convertPageInfoToPageView(from: pageInfo)
    }()
    
    // MARK: Life Cycle Functions
    
    init(pageInfo: PageInfo, backgroundImage: UIImage) {
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
        
        view.addSubview(pageView)
        pageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
