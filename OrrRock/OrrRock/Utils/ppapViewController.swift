//
//  ppapViewController.swift
//  OrrRock
//
//  Created by Ruyha on 2022/11/21.
//

import UIKit
import SnapKit

class ppapViewController: UIViewController {
    
    let rtaa = LevelPickerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rtaa)
        view.backgroundColor = .systemPink
        rtaa.snp.makeConstraints{
            $0.height.equalTo(100)
            $0.width.equalTo(view.snp.width)
            $0.center.equalToSuperview()
        }
        rtaa.setpicker()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
