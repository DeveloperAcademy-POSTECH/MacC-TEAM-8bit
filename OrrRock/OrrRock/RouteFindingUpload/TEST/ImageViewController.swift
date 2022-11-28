//
//  ImageViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/28.
//

import UIKit
import SnapKit

class ImageViewController: UIViewController {
    
    private var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        view.backgroundColor = .black
    }
        
    func setUpLayout() {
        let height: CGFloat = UIScreen.main.bounds.width * 16/9
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(height)
        })
    }
    
    func setImageView(image: UIImage?) {
        imageView.image = image ?? UIImage()
    }
}
