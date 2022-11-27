//
//  RouteFindingFeatureViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/25.
//

import UIKit

import SnapKit

final class RouteFindingFeatureViewController: UIViewController {
    
    // MARK: Variables
    
    var routeInfo: RouteInfo
    var pages: [PageInfo]
    var pageViews: [RouteFindingPageView] = []
    
    var centerCell: RouteFindingThumbnailCollectionViewCell?
    private var beforeCell: RouteFindingThumbnailCollectionViewCell?
    private var afterCell: RouteFindingThumbnailCollectionViewCell?
    
    let collectionViewCellSize: Int = 62
    
    // MARK: View Components
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        
        // 다양한 기기 사이즈에서 16:9 이미지 사이즈를 유지하기 위해 width, height을 계산
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.windows.first
        let contentHeight = view.frame.height - Double(((window?.safeAreaInsets.top)! + (window?.safeAreaInsets.bottom)!))
        let contentWidth = view.frame.width
        view.image = routeInfo.imageLocalIdentifier.generateCardViewThumbnail(targetSize: CGSize(width: contentWidth, height: contentHeight))
        view.backgroundColor = .white
        return view
    }()
    
    // 루트파인딩 제스처와 인터렉션이 실제로 이뤄지는 뷰
    private var pageView: RouteFindingPageView = {
        let view = RouteFindingPageView()
        return view
    }()
    
    let thumbnailCollectionView: UICollectionView = {
        let layout = RouteFindingThumbnailCollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(RouteFindingThumbnailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: RouteFindingThumbnailCollectionViewCell.identifier)
        collection.register(RouteFindingThumbnailCollectionViewAddCell.classForCoder(), forCellWithReuseIdentifier: RouteFindingThumbnailCollectionViewAddCell.identifier)
        
        return collection
    }()
    
    private let pageNumberingLabelView: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .orrWhite
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        return label
    }()
    
    private lazy var pageNumberingView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrBlack?.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.layer.cornerRadius = 20
        button.backgroundColor = .orrGray700
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .orrWhite
        button.addAction(UIAction { _ in
            self.exitRouteFinding()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 40))
        button.layer.cornerRadius = 20
        button.backgroundColor = .orrGray700
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.orrWhite, for: .normal)
        button.setTitleColor(.orrGray500, for: .highlighted)
        button.addAction(UIAction { _ in
            self.finishRouteFinding()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var footHandStackView: UIStackView = {
        
        // TODO: house 이미지를 손, 발 이미지로 대체하기
        
        let handButton = UIButton()
        handButton.backgroundColor = .clear
        handButton.setImage(UIImage(systemName: "house"), for: .normal)
        handButton.tintColor = .orrWhite
        handButton.addAction(UIAction { _ in
            self.tapHandButton()
        }, for: .touchUpInside)
        
        let footButton = UIButton()
        footButton.backgroundColor = .clear
        footButton.setImage(UIImage(systemName: "house"), for: .normal)
        footButton.tintColor = .orrWhite
        footButton.addAction(UIAction { _ in
            self.tapFootButton()
        }, for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [handButton, footButton])
        stackView.backgroundColor = .orrGray700
        // stackView의 width가 40이므로, cornerRadius의 값을 20으로 지정
        stackView.layer.cornerRadius = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 삭제모드 진입 시 화면 인터렉션 방지를 위한 뷰
    private lazy var deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelDeleteMode))
        view.addGestureRecognizer(gestureRecognizer)
        
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        button.setImage(UIImage(systemName: "minus.circle.fill")?.resized(to: CGSize(width: 26, height: 26)).withTintColor(.orrFail!, renderingMode: .alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(deletePage(_:)), for: .touchUpInside)
        button.backgroundColor = .orrWhite
        button.layer.cornerRadius = 14
        button.tintColor = .orrFail
        return button
    }()
    
    private lazy var deleteImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.image = routeInfo.imageLocalIdentifier.generateCardViewThumbnail(targetSize: CGSize(width: collectionViewCellSize, height:  collectionViewCellSize))
        return view
    }()
    
    // MARK: Life Cycle Functions
    
    init(routeInfo: RouteInfo) {
        self.routeInfo = routeInfo
        self.pages = routeInfo.pages
        
        super.init(nibName: nil, bundle: nil)
        
        // RouteInfo를 받아와, 루트파인딩 페이지를 그리기 위한 정보를 저장
        var views: [RouteFindingPageView] = []
        routeInfo.pages.forEach { pageInfo in
            let view = convertPageInfoToPageView(from: pageInfo)
            
            self.backgroundImageView.addSubview(view)
            views.append(view)
        }
        self.pageViews = views
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpLayout()
        setUpThumbnailCollectionDelegate()
    }
    
    // status bar 의 글자 색상을 흰 색으로 변경
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        // CollectionView가 다 그려지고 난 뒤, CollectionView의 content에 Inset을 넣어 끝까지 스크롤이 가능하도록 하기
        let layoutMargins: CGFloat = self.thumbnailCollectionView.layoutMargins.left
        let sideInset = self.view.frame.width / 2 - layoutMargins
        self.thumbnailCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        // 뷰가 올라오면 가장 처음 페이지로 이동
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Functions
    
    // PageInfo를 RouteFindingPageView로 전환
    private func convertPageInfoToPageView(from pageInfo: PageInfo) -> RouteFindingPageView {
        let view = RouteFindingPageView()
        
        // TODO: RouteFindingPageVIew UI 및 뷰 구현방법이 나오면 PageInfo에서 뷰 그리기 구현
        
        return view
    }
    
    // 선택된 셀(화면 가운데 위치한 셀)에 대해 페이지를 보여줌
    func selectPage() {
        guard let selectedCell = centerCell else { return }
        pageView.snp.removeConstraints()
        pageNumberingLabelView.text = "\(selectedCell.indexPathOfCell.row + 1)/\(pages.count)"
        
        pageView = pageViews[selectedCell.indexPathOfCell.row]
        pageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // 삭제모드를 위한 뷰 띄우기
    private func showDeleteView(for indexPath: IndexPath) {
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerX.equalTo(deleteView.snp.centerX)
            $0.width.height.equalTo(28)
            $0.bottom.equalTo(thumbnailCollectionView.snp.top).offset(-20)
        }
        
        deleteView.addSubview(deleteImage)
        deleteImage.snp.makeConstraints {
            $0.center.equalTo(self.thumbnailCollectionView.cellForItem(at: indexPath)!.snp.center)
            $0.width.height.equalTo(self.thumbnailCollectionView.cellForItem(at: indexPath)!.frame.width)
        }
    }
    
    func finishRouteFinding() {
        
        // TODO: 루트파인딩 저장하기 뷰로 데이터 넘겨주기
        routeInfo.pages = pages
//        routeInfo -> 전달
        
        print("Done Button Tapped")
    }
    
    func exitRouteFinding() {
        
        // TODO: 루트파인딩 데이터 초기화 및 뷰 닫기
        showPage()
        print("Exit Button Tapped")
    }
    
    func tapHandButton() {
        
        // TODO: 손 버튼을 눌렀을 때 손 입력모드 or 최대 개수 초과 알림 띄우기
        
        print("Hand Button Tapped")
    }
    
    func tapFootButton() {
        
        // TODO: 발 버튼을 눌렀을 때 손 입력모드 or 최대 개수 초과 알림 띄우기
        
        print("Foot Button Tapped")
    }
    
    // MARK: @objc Functions
    
    @objc private func cancelDeleteMode() {
        deleteView.removeFromSuperview()
        deleteButton.removeFromSuperview()
        deleteImage.removeFromSuperview()
        UIView.animate(withDuration: 0.2) {
            self.deleteImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.pageNumberingView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // 선택된 페이지를 삭제
    @objc private func deletePage(_ sender: UIButton) {
        guard let targetPageCell = centerCell else { return }
        
        // 남은 셀의 수가 1개라면 삭제하지 않음
        // 필요 시 아래 if 블록 내에 알림 추가
        if pages.count > 1 {
            pages.remove(at: targetPageCell.indexPathOfCell.row)
            pageViews.remove(at: targetPageCell.indexPathOfCell.row)
        }
        
        thumbnailCollectionView.reloadData()
        
        let nextPath = IndexPath(row: (targetPageCell.indexPathOfCell.row > 0) ? targetPageCell.indexPathOfCell.row - 1 : 1,
                                 section: targetPageCell.indexPathOfCell.section)
        
        thumbnailCollectionView.scrollToItem(at: nextPath, at: .centeredHorizontally, animated: true)
        cancelDeleteMode()
    }
}

extension RouteFindingFeatureViewController {
    
    // MARK: Set Up Functions
    
    private func setUpLayout() {
        // 화면 비율 기기 대응 작업
        view.addSubview(backgroundImageView)
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.windows.first
        let contentHeight = view.frame.height - (window?.safeAreaInsets.top)! + (window?.safeAreaInsets.bottom)!
        let contentWidth = view.frame.width
        let widthFirst: Bool = contentWidth < (contentHeight - 69) * 9 / 16
        backgroundImageView.snp.makeConstraints {
            if widthFirst {
                $0.width.equalTo(contentWidth)
                $0.height.equalTo(contentWidth * 16 / 9)
            } else {
                $0.height.equalTo(contentHeight - 69)
                $0.width.equalTo((contentHeight - 69) * 9 / 16)
            }
            $0.top.equalTo(view.forLastBaselineLayout.snp_topMargin)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints {
            $0.height.equalTo(74)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(pageNumberingView)
        pageNumberingView.snp.makeConstraints {
            $0.centerX.equalTo(thumbnailCollectionView.snp.centerX)
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(-OrrPd.pd16.rawValue)
            $0.height.equalTo(20)
            $0.width.equalTo(71)
        }
        
        pageNumberingView.addSubview(pageNumberingLabelView)
        pageNumberingLabelView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(64)
        }
        
        view.addSubview(footHandStackView)
        footHandStackView.snp.makeConstraints {
            $0.centerY.equalTo(backgroundImageView.snp.centerY)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.height.equalTo(110)
            $0.width.equalTo(40)
        }
    }
    
    private func setUpThumbnailCollectionDelegate() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
}

extension RouteFindingFeatureViewController: RouteFindingThumbnailCollectionViewAddCellDelegate {
    // 페이지 추가 버튼이 눌리면 새로운 페이지를 추가
    func tapAddPageButton() {
        pages.append(PageInfo(rowOrder: pages.last!.rowOrder + 1))
        let newView = RouteFindingPageView()
        self.backgroundImageView.addSubview(newView)
        pageViews.append(newView)
        
        thumbnailCollectionView.reloadData()
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: pageViews.count, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension RouteFindingFeatureViewController: RouteFindingThumbnailCollectionViewCellDelegate {
    // 셀을 long press 했을 때 삭제모드로 진입
    func enterDeletePageMode(indexPath: IndexPath) {
        thumbnailCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        showDeleteView(for: indexPath)
        
        UIView.animate(withDuration: 0.2) {
            self.deleteImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.pageNumberingView.transform = CGAffineTransform(translationX: 0, y: -50)
        }
    }
}

// DEBUG
extension RouteFindingFeatureViewController {
    func showPage() {
        let nextVC = RouteFindingOnboardingViewController(backgroundImage: backgroundImageView.image!)
//        RouteFindingOnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
