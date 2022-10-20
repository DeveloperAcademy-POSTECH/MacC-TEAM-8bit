//
//  VideoCollectionViewController.swift
//  OrrRock
//
//  Created by dohankim on 2022/10/20.
//

import UIKit

class VideoCollectionViewController: UIViewController {

    var imageArr = ["as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5","as","as1","as2","as3","as4","as5"]
    
    private lazy var videoCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.headerReferenceSize = .init(width: 100, height: 100)
        layout.footerReferenceSize = .init(width: 50, height: 100)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
