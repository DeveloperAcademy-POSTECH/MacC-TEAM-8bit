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

    // MARK: variables
    // Quick Action 기능을 위한 조건 변수와 함수 호출 설정
    var isCardView: Bool = true {
        // 앨범형 : 목록형
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            quickActionButton.setImage(UIImage(systemName: isCardView ? "rectangle.stack" : "list.bullet"), for: .normal)
        }
    }
    var isSortedByDate: Bool = true {
        // 날짜 기준 : 암장 기준
        didSet {
            isSortedByDate ? sortByDate() : sortByGym()
        }
    }
    var isAscending: Bool = true {
        // 오름차순  : 내림차순
        didSet {
            isAscending ? sortToAscending() : sortToDescending()
        }
    }
    var selectedVideoFilterEnum: VideoFilterEnum = .whole {
        // 필터링 기준
        didSet {
            switch selectedVideoFilterEnum {
            case .whole:
                showWholeVideo()
            case .liked:
                showLikedVideo()
            case .success:
                showSuccessVideo()
            case .fail:
                showFailedVideo()
            }
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
        let button = UIButton(primaryAction: UIAction(title: "", handler: { _ in}))
        button.setImage(UIImage(systemName: isCardView ? "rectangle.stack" : "list.bullet"), for: .normal)
        button.tintColor = .systemBlue
        
        // QuickAction은 UIMenu() 라는 컴포넌트로 구현할 수 있음
        // 버튼의 menu에 UIMenu로 감싼 UIAction들을 담아주기
        // UIMenu는 Action에 대한 그룹핑 역할. displayInline을 빼면 폴더링이 되어 접힘
        // UIDeferredMenuElement를 통해 동적으로 UI가 변경될 수 있도록 정의
        button.menu = UIMenu(options: .displayInline, children: [
            UIDeferredMenuElement.uncached { [weak self] completion in
                let actions = [
                    UIMenu(title: "", options: .displayInline, children: [
                        // 앨범형으로 보기
                        UIAction(title: "앨범",
                                 image: UIImage(systemName: "rectangle.stack"),
                                 state: self!.isCardView ? .on : .off) { [unowned self] _ in
                                     self?.isCardView = true
                                 },
                        // 목록형으로 보기
                        UIAction(title: "목록",
                                 image: UIImage(systemName: "list.bullet"),
                                 state: self!.isCardView ? .off : .on) { [unowned self] _ in
                                     self?.isCardView = false
                                 }
                    ]),
                    UIMenu(title: "", options: .displayInline, children: [
                        // 날짜 기준으로 정렬
                        UIAction(title: "날짜",
                                 image: self!.isSortedByDate ? ( self!.isAscending ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")) : nil,
                                 state: self!.isSortedByDate ? .on : .off) { [unowned self] _ in
                                     
                                     if self!.isSortedByDate {
                                         // 이미 날짜 기준으로 정렬 중이라면
                                         self?.isAscending.toggle()
                                     } else {
                                         // 암장 기준으로 정렬 중이라면
                                         self?.isSortedByDate.toggle()
                                         self?.isAscending = true
                                     }
                                 },
                        // 암장 기준으로 정렬하기
                        UIAction(title: "클라이밍 장",
                                 image: self!.isSortedByDate ? nil : ( self!.isAscending ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")),
                                 state: self!.isSortedByDate ? .off : .on) { [unowned self] _ in
                                     
                                     if self!.isSortedByDate {
                                         // 날짜 기준으로 정렬 중이라면
                                         self?.isSortedByDate.toggle()
                                         self?.isAscending = true
                                     } else {
                                         // 이미 암장 기준으로 정렬 중이라면
                                         self?.isAscending.toggle()
                                     }
                                 }
                    ]),
                    UIMenu(title: "", options: .displayInline, children: [
                        // 모든 비디오 보여주기
                        UIAction(title: "모든 비디오",
                                 image: UIImage(systemName: "photo.on.rectangle.angled"),
                                 state: self?.selectedVideoFilterEnum == .whole ? .on : .off) { [unowned self] _ in
                                     self?.selectedVideoFilterEnum = .whole
                                 },
                        // 즐겨찾는 항목만 보여주기
                        UIAction(title: "즐겨찾는 항목",
                                 image: UIImage(systemName: "heart"),
                                 state: self?.selectedVideoFilterEnum == .liked ? .on : .off) { [unowned self] _ in
                                     self?.selectedVideoFilterEnum = .liked
                                 },
                        // 성공 영상만 보여주기
                        UIAction(title: "성공",
                                 image: UIImage(systemName: "circle"),
                                 state: self?.selectedVideoFilterEnum == .success ? .on : .off) { [unowned self] _ in
                                     self?.selectedVideoFilterEnum = .success
                                 },
                        // 실패 영상만 보여주기
                        UIAction(title: "실패",
                                 image: UIImage(systemName: "multiply"),
                                 state: self?.selectedVideoFilterEnum == .fail ? .on : .off) { [unowned self] _ in
                                     self?.selectedVideoFilterEnum = .fail
                                 }
                    ])
                ]
                completion(actions)
            }
        ])

        // 버튼을 눌렀을 때 메뉴를 보여주도록 설정
        button.showsMenuAsPrimaryAction = true
        
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
        navigationController?.isNavigationBarHidden = true
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
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(orrPadding.padding3.rawValue)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(orrPadding.padding3.rawValue)
        }
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        headerView.addSubview(logoView)
        logoView.snp.makeConstraints {
            $0.bottom.equalTo(headerView.snp.bottom).inset(16)
            $0.leading.equalTo(headerView.snp.leading).offset(24)
        }
        
        headerView.addSubview(quickActionButton)
        quickActionButton.snp.makeConstraints {
            $0.bottom.equalTo(headerView.snp.bottom).inset(16)
            $0.trailing.equalTo(headerView.snp.trailing).inset(24)
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

// QuickAction을 통한 정렬 및 필터링 시 함수를 아래에 구현
extension HomeViewController {
    // 정렬 기준 함수
    func sortByDate() {
        
    }
    
    func sortByGym() {
        
    }
    
    func sortToAscending() {
        
    }
    
    func sortToDescending() {
        
    }
    
    // 필터링 기준 함수
    func showWholeVideo() {
        
    }
    
    func showLikedVideo() {
        
    }
    
    func showSuccessVideo() {
        
    }
    
    func showFailedVideo() {
        
    }
}
