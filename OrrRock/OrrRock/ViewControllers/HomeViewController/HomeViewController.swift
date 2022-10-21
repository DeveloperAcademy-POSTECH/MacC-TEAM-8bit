//
//  HomeCollectionViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/10/19.
//

// MARK: TODO
// QuickAction 동작 구현
// Toolbar의 myPageButton의 action으로 마이페이지로 이동하는 동작 구현
// Toolbar의 addVideoButton의 action으로 영상 추가로 이동하는 동작 구현
// 색상 확정나면 지정해주기

import PhotosUI
import UIKit

import NVActivityIndicatorView
import SnapKit

final class HomeViewController : UIViewController {
    
    // MARK: UI Components
    // CollectionView의 좌우 여백을 이용해 동적으로 UI 그리기 위한 변수
    let HorizontalPaddingSize: CGFloat = 16
    var isCardView: Bool = false {
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    //인디게이터 사용을 위한 선언
    private let indicator : NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150),
                                           type: .lineSpinFadeLoader,
                                           color: .lightGray,
                                           padding: 50)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layoutIfNeeded()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    //인디게이터가 돌 때 다른 동작을 못하게 하기위한 뷰
    private lazy var blockTouchView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var headerView: UIView = {
        let view = UIView()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints {
            $0.edges.equalTo(view.snp.edges)
        }
        
        return view
    }()
    
    private lazy var logoView: UILabel = {
        // 앱 로고와 타이틀 디자인이 확정나면 이 컴포넌트를 활용해 그려주기
        let view = UILabel()
        view.text = "오르락 로고"
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    private lazy var quickActionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.stack"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(switchViewStyle), for: .touchUpInside)
        return button
    }()

    private lazy var toolbarView: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .systemGray5
        
        var items: [UIBarButtonItem] = []
        
        let myPageButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle"), style: .plain, target: self, action: nil)
        let addVideoButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: self, action: #selector(videoButtonPressed))
        // toolbar 내 Spacer() 역할
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: HomeViewController.self, action: nil)
        
        items.append(myPageButton)
        items.append(flexibleSpace)
        items.append(addVideoButton)
        
        items.forEach { (item) in
            item.tintColor = .systemBlue
        }
        
        view.setItems(items, animated: true)
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        
        // CollectionView에서 사용할 Cell 등록
        view.register(HomeCollectionViewCardCell.classForCoder(),
                      forCellWithReuseIdentifier: HomeCollectionViewCardCell.identifier)
        view.register(HomeCollectionViewListCell.classForCoder(),
                      forCellWithReuseIdentifier: HomeCollectionViewListCell.identifier)
        view.register(HomeCollectionViewHeaderCell.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: HomeCollectionViewHeaderCell.identifier)
        view.register(HomeCollectionViewFooterCell.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier: HomeCollectionViewFooterCell.identifier)
        
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    // MARK: Components
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy년 M월 d일"
        return df
    }()

    // MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray5
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: quickActionButton)

        setUpLayout()
        setUICollectionViewDelegate()
    }
    
    // MARK: Layout Function
    private func setUpLayout() {
        self.view.addSubview(toolbarView)
        toolbarView.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(toolbarView.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(HorizontalPaddingSize)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(HorizontalPaddingSize)
        }
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }

        // 인디게이터 위치 추가
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }

    //이친구는 반복적으로 추가되고 삭제 되어야해서 따로 만들었습니다.
    func addBlockTouchView() {
        self.view.addSubview(blockTouchView)
        blockTouchView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.trailing.equalTo(view.snp.trailing)
            $0.leading.equalTo(view.snp.leading)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func setUICollectionViewDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func switchViewStyle() {
        self.isCardView.toggle()
    }
}

extension HomeViewController {

    @objc func videoButtonPressed(sender: UIButton!) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        //인디게이터 도는거 보고 싶으면 아랫줄을 주석 처리해주세요.
        configuration.preferredAssetRepresentationMode = .current
        configuration.filter = .any(of: [.videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    //터치를 제한하는 뷰를 추가하고 인디게이터를 실행 시킵니다.
    func startIndicator() {
        addBlockTouchView()
        indicator.startAnimating()
    }

    func stopIndicator() {
        self.indicator.stopAnimating()
        blockTouchView.removeFromSuperview()
    }
}

extension HomeViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var videoUrlArray: [URL] = []
        var errorCount = 0
        //인디케이트를 소환합니다.
        startIndicator()

        //사용자가 영상을 선택 하지 않은 상태일 때
        if results.count == 0 {
            //인디게이터 종료
            stopIndicator()
        }

        //선택된 영상에서 URL을 뽑아내는 로직입니다.
        for i in 0..<results.count {
            results[i].itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, err in
                if url == nil {
                    NSLog("Orr_HomeViewController_Err1:\(String(describing: err))\n")
                    errorCount += 1
                } else {
                    videoUrlArray.append(url!)
                    if results.count == videoUrlArray.count + errorCount {
                        DispatchQueue.main.sync {
                            //인디케이터 종료
                            self.stopIndicator()
                            let nextVC = UpoadTestNextViewController()
                            nextVC.viewUrlArray = videoUrlArray
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }
                }
            }
        }
    }
}
