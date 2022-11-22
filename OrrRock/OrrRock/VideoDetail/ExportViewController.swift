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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.backgroundColor = .orrWhite
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
    
