//
//  RouteFindingSaveViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/25.
//

import UIKit
import SnapKit

class RouteFindingSaveViewController: UIViewController {
    
    //FIXME: PR전 dummyData 삭제
    var routeInfo: RouteInfo = RouteInfo.dummyData
    //FIXME: PR전 dummyData 삭제
    var pages: [PageInfo]! = RouteInfo.dummyData.pages
    var pageViews: [RouteFindingPageView] = [] // TODO: 프리뷰에 띄워주는 로직 구현
    
    let collectionViewCellwidth: Int = 58
    
    var beforeCell: SaveRouteFindingImageCollectionViewCell?
    var centerCell: SaveRouteFindingImageCollectionViewCell?
    var afterCell: SaveRouteFindingImageCollectionViewCell?
    
    private var goBackButton: UIBarButtonItem!
    private var saveButton: UIBarButtonItem!
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        button.tintColor = .orrWhite
        button.addAction(UIAction { _ in
            self.goBackAction()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.tintColor = .orrWhite
        button.addAction(UIAction { _ in
            self.saveAction()
        }, for: .touchUpInside)
        
        return button
    }()
    
    var previewImage: UIImageView! = {
        let view = UIImageView()
        //FIXME: PR전 dummyData 삭제
        view.image = RouteInfo.dummyData.imageLocalIdentifier.generateCardViewThumbnail()
       
        return view
    }()
    
    lazy var previewImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray200
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        btn.setBackgroundColor(.orrUPBlue!, for: .normal)
//        btn.addTarget(self, action: #selector(pressNextButton), for: .touchUpInside)
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        
        return btn
    }()
    
    private lazy var skipButton: UIButton = {
        let btn = UIButton()
//        btn.addTarget(self, action: #selector(pressSkipButton), for: .touchUpInside)
        btn.setAttributedTitle("저장하지 않을래요".underLineAttribute(), for: .normal)
        
        return btn
    }()
    
    private lazy var toastMessageView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.orrUPBlue?.cgColor
        view.layer.borderWidth = 1
        view.alpha = 1
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.orrBlack
        view.clipsToBounds  =  true
        
        return view
    }()
    
    private lazy var toastMessage: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.text = "이 루트파인딩을 사진에 저장했습니다."
        
        return label
    }()
    
    private lazy var countVideoView:  UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray800
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var countVideoLabel: UILabel = {
        let label = UILabel()
        label.text = "0/0"
        label.textColor = .orrWhite
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        
        return label
    }()
    
    let saveRouteFindingImageCollectionView: UICollectionView = {
        let layout = SaveRouteFindingImageCollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(SaveRouteFindingImageCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: SaveRouteFindingImageCollectionViewCell.identifier)
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setCountVideoLabel()
        setUpsaveRouteFindingImageCollectionViewDelegate()
        
        self.view.backgroundColor = .orrBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layoutMargins: CGFloat = self.saveRouteFindingImageCollectionView.layoutMargins.left
        let sideInset = self.view.frame.width / 2 - layoutMargins
        self.saveRouteFindingImageCollectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        saveRouteFindingImageCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func setUpsaveRouteFindingImageCollectionViewDelegate() {
        saveRouteFindingImageCollectionView.delegate = self
        saveRouteFindingImageCollectionView.dataSource = self
    }
    
    @objc func goBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAction() {
        let image = previewImageView.asImage()
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        completeSaveImage()
    }
    
    @objc func completeSaveImage() {
        
        self.toastMessageView.alpha = 0
        
        view.addSubview(toastMessageView)
        toastMessageView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-OrrPd.pd8.rawValue)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(42)
            $0.width.equalTo(nextButton.snp.width)
        }
        
        toastMessageView.addSubview(toastMessage)
        toastMessage.snp.makeConstraints {
            $0.center.equalTo(toastMessageView.snp.center)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.toastMessageView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
                self.toastMessageView.alpha = 0.0
            }, completion: { _ in
                self.toastMessageView.removeFromSuperview()
            })
        })
    }
    
    func setCountVideoLabel() {
        guard let selectedCell = centerCell else { return }
        countVideoLabel.text = "\(selectedCell.indexPathOfCell.row + 1)/\(pages.count)"
    }
}

extension RouteFindingSaveViewController {
    
    private func setUpLayout() {
        
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
            $0.width.equalTo(40)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view).inset(OrrPd.pd36.rawValue)
            $0.leading.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.trailing.equalTo(view).inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(56)
        }
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.height.equalTo(18)
            $0.width.equalTo(108)
            $0.bottom.equalTo(nextButton.snp.top).offset(-OrrPd.pd8.rawValue)
        }
        
        view.addSubview(countVideoView)
        countVideoView.snp.makeConstraints {
            $0.bottom.equalTo(skipButton.snp.top).offset(-54) // TODO: 린다와 패딩 협의 필요
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(71)
        }
        
        countVideoView.addSubview(countVideoLabel)
        countVideoLabel.snp.makeConstraints {
            $0.center.equalTo(countVideoView.snp.center)
        }
        
        view.addSubview(saveRouteFindingImageCollectionView)
        saveRouteFindingImageCollectionView.snp.makeConstraints {
            $0.height.equalTo(125)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(countVideoView.snp.top).offset(-OrrPd.pd8.rawValue)
        }
        
        view.addSubview(previewImageView)
        previewImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(exitButton.snp.bottom).offset(OrrPd.pd8.rawValue)
            $0.bottom.equalTo(saveRouteFindingImageCollectionView.snp.top).offset(-OrrPd.pd8.rawValue)
            $0.width.equalTo(previewImageView.snp.height).multipliedBy(0.5625)
        }
        
        previewImageView.addSubview(previewImage)
        previewImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
