//
//  RouteFindingFeatureViewController.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/25.
//

import UIKit
import SnapKit
import Then

final class RouteFindingFeatureViewController: UIViewController {
    
    // MARK: Variables
    
    var routeDataDraft: RouteDataDraft
    var tempRouteInfo: RouteInfo
    var pageViewControllerList: [RouteFindingPageViewController] = []
    var backgroundImage: UIImage
    var isCreateMode: Bool
    var isHandButtonMode: Bool = false {
        didSet {
            pageViewControllerList.forEach { vc in
                vc.isHandButtonMode = isHandButtonMode
            }
            
            handButton.tintColor = isHandButtonMode ? .orrWhite : .orrGray500
            footButton.tintColor = isHandButtonMode ? .orrGray500 : .orrWhite
        }
    }
    
    var pendingIndex: Int?
    var selectedIndex: Int = 0
    
    var centerCell: RouteFindingThumbnailCollectionViewCell?
    private var beforeCell: RouteFindingThumbnailCollectionViewCell?
    private var afterCell: RouteFindingThumbnailCollectionViewCell?
    
    let collectionViewCellSize: Int = 62
    
    // MARK: View Components
    
    private lazy var backgroundImageView: UIImageView = .init().then {
        // 다양한 기기 사이즈에서 16:9 이미지 사이즈를 유지하기 위해 width, height을 계산
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)!.windows.first
        let contentHeight = view.frame.height - Double(((window?.safeAreaInsets.top)! + (window?.safeAreaInsets.bottom)!))
        let contentWidth = view.frame.width
        $0.image = backgroundImage
        $0.backgroundColor = .white
    }
    
    private lazy var routePageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.view.backgroundColor = .black
        pageViewController.isPagingEnabled = false
        
        return pageViewController
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
    
    private lazy var pageNumberingView: UIView = .init().then {
        $0.backgroundColor = .orrBlack?.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
}
    
    private lazy var exitButton: UIButton = .init().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .small)
        let buttonSymbol = UIImage(systemName: "xmark", withConfiguration: config)?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        
        $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .orrGray700
        $0.setImage(buttonSymbol, for: .normal)
        $0.tintColor = .orrWhite
        $0.addAction(UIAction { _ in
            self.showExitAlert()
        }, for: .touchUpInside)
    }
    
    private lazy var doneButton: UIButton = .init().then {
        $0.frame = CGRect(x: 0, y: 0, width: 64, height: 40)
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .orrGray700
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.setTitleColor(.orrWhite, for: .normal)
        $0.setTitleColor(.orrGray500, for: .highlighted)
        $0.addAction(UIAction { _ in
            self.finishRouteFinding()
        }, for: .touchUpInside)
    }
    
    private lazy var handButton: UIButton = {
        let handButton = UIButton()
        handButton.backgroundColor = .clear
        handButton.setImage(UIImage(named: "activated_hand_button")!.withRenderingMode(.alwaysTemplate), for: .normal)
        handButton.tintColor = .orrGray500
        handButton.addAction(UIAction { _ in
            self.tapHandButton()
        }, for: .touchUpInside)
        return handButton
    }()
    
    private lazy var footButton: UIButton = {
        let footButton = UIButton()
        footButton.backgroundColor = .clear
        footButton.setImage(UIImage(named: "activated_foot_button")!.withRenderingMode(.alwaysTemplate), for: .normal)
        footButton.tintColor = .orrGray500
        footButton.addAction(UIAction { _ in
            self.tapFootButton()
        }, for: .touchUpInside)
        return footButton
    }()
    
    private lazy var footHandStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [handButton, footButton])
        stackView.backgroundColor = .orrGray700
        // stackView의 width가 40이므로, cornerRadius의 값을 20으로 지정
        stackView.layer.cornerRadius = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 삭제모드 진입 시 화면 인터렉션 방지를 위한 뷰
    private lazy var deleteView: UIView = .init().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelDeleteMode))
        view.addGestureRecognizer(gestureRecognizer)
        
}
    
    private lazy var deleteButton: UIButton = .init().then {
        $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        $0.setImage(UIImage(systemName: "minus.circle.fill")?.resized(to: CGSize(width: 26, height: 26)).withTintColor(.orrFail!, renderingMode: .alwaysTemplate), for: .normal)
        $0.addTarget(self, action: #selector(deletePage(_:)), for: .touchUpInside)
        $0.backgroundColor = .orrWhite
        $0.layer.cornerRadius = 14
        $0.tintColor = .orrFail
    }
    
    private lazy var deleteImage: UIImageView = .init().then {
        $0.image = routeDataDraft.routeInfoForUI.imageLocalIdentifier.generateCardViewThumbnail()
    }
    
    // MARK: Life Cycle Functions
    
    init(routeDataDraft: RouteDataDraft, backgroundImage: UIImage, isCreateMode: Bool) {
        self.routeDataDraft = routeDataDraft
        self.tempRouteInfo = routeDataDraft.routeInfoForUI
        
        self.backgroundImage = backgroundImage
        self.isCreateMode = isCreateMode
        super.init(nibName: nil, bundle: nil)
        
        backgroundImageView.image = self.backgroundImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomIndicator.stopLoading()
        view.backgroundColor = .black
        overrideUserInterfaceStyle = .light
        
        // 루트 파인딩 온보딩 호출
        if !UserDefaults.standard.bool(forKey: "RouteFindingOnboardingClear") {
            let onboardingVC = RouteFindingOnboardingViewController(backgroundImage: backgroundImage)
            onboardingVC.modalPresentationStyle = .fullScreen
            
            self.present(onboardingVC, animated: true, completion: nil)
        }
        
        setUpLayout()
        setUpThumbnailCollectionDelegate()
        setUpPageViewController()
        
    }
    
    // status bar 의 글자 색상을 흰 색으로 변경
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHandButtonMode = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // CollectionView가 다 그려지고 난 뒤, CollectionView의 content에 Inset을 넣어 끝까지 스크롤이 가능하도록 하기
        let layoutMargins: CGFloat = self.thumbnailCollectionView.layoutMargins.left
        let sideInset = self.view.frame.width / 2 - layoutMargins
        self.thumbnailCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        // 뷰가 올라오면 가장 처음 페이지로 이동
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Functions
    
    // 선택된 셀(화면 가운데 위치한 셀)에 대해 페이지를 보여줌
    func selectPage() {
        guard let selectedCell = centerCell else { return }
        pageNumberingLabelView.text = "\(selectedCell.indexPathOfCell.row + 1)/\(routeDataDraft.routeInfoForUI.pages.count)"
        
        routePageViewController.setViewControllers([pageViewControllerList[selectedCell.indexPathOfCell.row]], direction: .forward, animated: false)
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
    
    // TODO: 루트 파인딩 저장하기 뷰로 데이터 넘겨주기
    func finishRouteFinding() {
        
        var pageImageList: [UIImage] = []
        
        pageViewControllerList.forEach { vc in
            vc.trashView.isHidden = true
            pageImageList.append(vc.view.asImage())
        }
        
        let routeFindingSaveViewController = RouteFindingSaveViewController(routeDataDraft: routeDataDraft, backgroundImage: backgroundImage, pageImages: pageImageList)
        
        if let navigationController = self.navigationController {
            self.navigationController?.pushViewController(routeFindingSaveViewController, animated: true)
        } else {
            routeDataDraft.save()
            self.dismiss(animated: true)
        }
        
        print("Done Button Tapped")
    }
    
    func showExitAlert() {
        let msg = isCreateMode ? "루트 파인딩은" : "편집한 내용은"
        let optionMenu = UIAlertController(title: "저장하지 않고 나가기", message: "나가기 선택 시, \(msg) 저장되지 않습니다.", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "나가기", style: .destructive) {_ in
            self.routeDataDraft.routeInfoForUI = self.tempRouteInfo
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func tapHandButton() {
        
        // TODO: 손 버튼을 눌렀을 때 손 입력모드 or 최대 개수 초과 알림 띄우기
        isHandButtonMode = true
        print("Hand Button Tapped")
    }
    
    func tapFootButton() {
        
        // TODO: 발 버튼을 눌렀을 때 손 입력모드 or 최대 개수 초과 알림 띄우기
        isHandButtonMode = false
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
        if routeDataDraft.routeInfoForUI.pages.count > 1 {
            pageViewControllerList.remove(at: targetPageCell.indexPathOfCell.row)
            routeDataDraft.removePageData(at: targetPageCell.indexPathOfCell.row)
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
        
        view.addSubview(routePageViewController.view)
        routePageViewController.view.snp.makeConstraints {
            $0.edges.equalTo(backgroundImageView)
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
    
    private func setUpPageViewController() {
        routePageViewController.delegate = self
        routePageViewController.dataSource = self
        routePageViewController.isPagingEnabled = false
        
        pageViewControllerList = getViewControllerForPageVC()
        routePageViewController.setViewControllers([pageViewControllerList.first!], direction: .forward, animated: true)
    }
    
    func getViewControllerForPageVC() -> [RouteFindingPageViewController] {
        var routeViewControllers: [RouteFindingPageViewController] = []
        
        routeDataDraft.routeInfoForUI.pages.forEach { pageInfo in
            let vc = RouteFindingPageViewController(routeDataDraft: routeDataDraft, pageRowOrder: pageInfo.rowOrder, backgroundImage: backgroundImage)
            vc.delegate = self
            routeViewControllers.append(vc)
            
        }
        
        return routeViewControllers
    }
}

extension RouteFindingFeatureViewController: RouteFindingThumbnailCollectionViewAddCellDelegate {
    // 페이지 추가 버튼이 눌리면 새로운 페이지를 추가
    func tapAddPageButton() {
        let newRowOrder = routeDataDraft.routeInfoForUI.pages.last!.rowOrder + 1
        
        routeDataDraft.addPageData(pageInfo: PageInfo(rowOrder: newRowOrder))
        let newVC = RouteFindingPageViewController(routeDataDraft: routeDataDraft, pageRowOrder: newRowOrder, backgroundImage: backgroundImage)
        newVC.isHandButtonMode = isHandButtonMode
        pageViewControllerList.append(newVC)
        
        thumbnailCollectionView.reloadData()
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: pageViewControllerList.count, section: 0), at: .centeredHorizontally, animated: true)
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

extension RouteFindingFeatureViewController: IsDeletingPointButtonDelegate {
    func hidePageNumberingLabelView() {
        pageNumberingLabelView.isHidden = true
        pageNumberingView.isHidden = true
    }
    
    func showPageNumberingLabelView() {
        pageNumberingLabelView.isHidden = false
        pageNumberingView.isHidden = false
    }
}

extension RouteFindingFeatureViewController {
    func showPage() {
        let nextVC = RouteFindingOnboardingViewController(backgroundImage: backgroundImageView.image!)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
