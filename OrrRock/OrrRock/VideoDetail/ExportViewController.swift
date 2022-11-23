//
//  ExportViewController.swift
//  OrrRock
//
//  Created by kimhyeongmin on 2022/11/23.
//

import UIKit
import Photos

class ExportViewController: UIViewController, UINavigationBarDelegate {
    
    var videoInformation: VideoInformation!
    var videoAsset: PHAsset?
    
    private lazy var previewVideoView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray200
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layoutSubviews()
        
        return view
    }()
    
    private lazy var orrLogo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "V0")
        
        return imgView
    }()
    
    private lazy var orrTextLogo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ORRROCK")
        
        return imgView
    }()
    
    private lazy var calendarIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "calandarIcon")
        
        return imgView
    }()
    
    private lazy var gymIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "gymIcon")
        
        return imgView
    }()
    
    private lazy var gradation: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "gradation")
        
        return imgView
    }()
    
    private lazy var gymName: UILabel = {
        let label = UILabel()
        label.text = videoInformation.gymName
        label.textColor = .orrWhite
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return label
    }()
    
    private lazy var gymVisitDate: UILabel = {
        let label = UILabel()
        label.text = videoInformation.gymVisitDate.timeToString()
        label.textColor = .orrWhite
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return label
    }()
    
    lazy var videoPlayView: VideoPlayView = {
        let view = VideoPlayView(videoAsset: videoAsset)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigationBar()
        view.backgroundColor = .orrWhite
    }
    
    override func viewDidLayoutSubviews() {
        addVideoLayer()
    }
    
    func setNavigationBar() {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        navbar.backgroundColor = UIColor.orrWhite
        navbar.delegate = self
        
        let navItem = UINavigationItem()
        navItem.title = "사진에 저장"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeAction))
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
    }
    
    @objc private func completeAction() {
        //TODO: 확인 버튼 후 다음 뷰 띄워주기
        print(#function)
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
}
    
extension ExportViewController {
    private func setLayout() {
        view.addSubview(previewVideoView)
        previewVideoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.top).offset(100)
            $0.bottom.equalTo(view.snp.bottom).inset(100)
            $0.width.equalTo(previewVideoView.snp.height).multipliedBy(0.5625)
        }
        
        previewVideoView.addSubview(videoPlayView)
        videoPlayView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
    private func addVideoLayer() {
        previewVideoView.addSubview(gradation)
        gradation.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        previewVideoView.addSubview(orrLogo)
        orrLogo.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0485)
            $0.width.equalTo(orrLogo.snp.height).multipliedBy(0.9139)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.0901)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.4722)
        }
        
        previewVideoView.addSubview(orrTextLogo)
        orrTextLogo.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0239)
            $0.width.equalTo(orrTextLogo.snp.height).multipliedBy(8.8260)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.1055)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.5859)
        }
        
        previewVideoView.addSubview(calendarIcon)
        calendarIcon.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0265)
            $0.width.equalTo(calendarIcon.snp.height).multipliedBy(1.1960)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8364)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.0641)
        }
        
        previewVideoView.addSubview(gymIcon)
        gymIcon.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.0375)
            $0.width.equalTo(gymIcon.snp.height).multipliedBy(0.9027)
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8895)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.0613)
        }
        
        previewVideoView.addSubview(gymVisitDate)
        gymVisitDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8348)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.1465)
            gymVisitDate.font = .boldSystemFont(ofSize: previewVideoView.frame.height*0.025)
        }
        
        previewVideoView.addSubview(gymName)
        gymName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(previewVideoView.frame.height*0.8973)
            $0.left.equalToSuperview().offset(previewVideoView.frame.width*0.1465)
            gymName.font = .boldSystemFont(ofSize: previewVideoView.frame.height*0.025)
        }
    }
}
