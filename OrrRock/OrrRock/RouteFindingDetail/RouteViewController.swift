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

    // MARK: View Components
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
    
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
        let view = UIView()
        
        switch pageInfo.rowOrder {
        case 0: view.backgroundColor = .systemRed
        case 1: view.backgroundColor = .systemYellow
        case 2: view.backgroundColor = .systemBlue
        default: view.backgroundColor = .systemMint
        }
        
        
        return view
    }()
    
    // MARK: Life Cycle Functions
    
    init(pageInfo: PageInfo) {
        self.pageInfo = pageInfo
        
        super.init(nibName: nil, bundle: nil)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: Functions
    
    private func convertPageInfoToPageView(from pageInfo: PageInfo) -> UIView {
        let view = UIView()
        
        // TODO: RouteFindingPageVIew UI 및 뷰 구현방법이 나오면 PageInfo에서 뷰 그리기 구현
        
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
