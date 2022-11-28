//
//  RouteFindinCameraViewController+.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/28.
// MARK: 테스트를 위한 메소드 보관소

import UIKit

extension RouteFindingCameraViewController {
    
    // MARK: **TEST용** 다음 VC에서 카메라로 촬영하거나, 사진 앱에서 불러온 이미지가 정상적으로 출력되는지를 테스트하기 위함
    func navigateToSampleImageVC(image: UIImage)
    {
        let nextVC = ImageViewController()
        nextVC.setImageView(image: photoImage)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
