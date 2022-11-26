//
//  RouteFindingSectionViewController+Extensions.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/25.
//

import UIKit
import SnapKit

extension RouteFindingSectionViewController : UICollectionViewDelegate{
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RouteFindingCollectionViewHeaderCell.id,
                for: indexPath
            ) as! RouteFindingCollectionViewHeaderCell
            supplementaryView.prepare(title: "\(infoArr.count)개의 도전", subtitle: "편집",isEditing: mMode == .view ? false : true)
            supplementaryView.delegate = self
            return supplementaryView
            
        case UICollectionView.elementKindSectionFooter:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RouteFindingCollectionViewHeaderCell.id,
                for: indexPath
            ) as! RouteFindingCollectionViewHeaderCell
            supplementaryView.prepare(title: "13개의 도전", subtitle: "편집",isEditing: false)
            return supplementaryView
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension RouteFindingSectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 실사들어오면 사용할 것들
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteFindingCollectionViewCustomCell", for: indexPath) as! RouteFindingCollectionViewCustomCell
        cell.cellLevelLabel.text = "V5"
        cell.cellChallengeLabel.text = "도전 완료"
        cell.cellDateLabel.text = "2022년 10월 13일"
        cell.cellTitleLabel.text = "아띠 클라이밍장"
        cell.cellImage.image = UIImage(named: "SwipeOnboardingImage1")
        cell.isSelectable = mMode == .select ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode{
        case .view:
            routeFindingCollectionView.deselectItem(at: indexPath, animated: true)
            //화면이동 로직 들어갈 부분
            print("화면이동합니다~")
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
            //toolbar enable 들어갈 부분
            self.folderButton.isEnabled = true
            self.deleteButton.isEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select{
            dictionarySelectedIndexPath[indexPath] = false
            collectionView.cellForItem(at: indexPath)?.isHighlighted = false
            collectionView.cellForItem(at: indexPath)?.isSelected = false
            self.folderButton.isEnabled = dictionarySelectedIndexPath.values.filter({$0 == true}).count == 0 ? false : true
            self.deleteButton.isEnabled = dictionarySelectedIndexPath.values.filter({$0 == true}).count == 0 ? false : true
        }
    }
}

extension RouteFindingSectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 6.5
        return CGSize(width: width, height: width * 1.8)
    }
}

extension RouteFindingSectionViewController : RouteFindingCollectionViewHeaderCellDelegate{
    func tapEditButton() {
        mMode = mMode == .view ? .select : .view
        routeFindingCollectionView.reloadSections(IndexSet(integer: 0))
        (routeFindingCollectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as! RouteFindingCollectionViewHeaderCell).subTitleButton.setTitle(mMode == .select ? "완료" : "편집", for: .normal)
        (routeFindingCollectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as!
         RouteFindingCollectionViewHeaderCell).subTitleButton.setTitleColor(mMode == .select ? UIColor.orrUPBlue: UIColor.orrGray400, for: .normal)
        
    }
}

extension RouteFindingSectionViewController : UISheetPresentationControllerDelegate{
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
    }
}

extension RouteFindingSectionViewController : RouteModalDelegate{
    func delete() {
        var deleteNeededIndexPaths : [IndexPath] = []
        for (key,value) in dictionarySelectedIndexPath{
            if value{
                deleteNeededIndexPaths.append(key)
            }
        }
        //삭제 실제 배열에서
        for i in deleteNeededIndexPaths.sorted(by:{$0.item > $1.item}) {
            //            //데이터에서 실제로 삭제하는 부분
            //            DataManager.shared.deleteData(videoInformation: videoInformationArray[i.item])
            infoArr.remove(at: i.item)
        }
        
        for (key,value) in dictionarySelectedIndexPath {
            if value {
                routeFindingCollectionView.deselectItem(at: key, animated: true)
            }
        }
        showToast("\(dictionarySelectedIndexPath.count)개의 루트 파인딩을 삭제했습니다.", withDuration: 3.0, delay: 0.1)
        
        dictionarySelectedIndexPath.removeAll()
        
        mMode = .view
        
        routeFindingCollectionView.allowsMultipleSelection = false
        routeFindingCollectionView.deleteItems(at: deleteNeededIndexPaths)
        
        folderButton.isEnabled = false
        deleteButton.isEnabled = false
        
        //도전의 개수 업데이트
        //        getSuccessCount()
        routeFindingCollectionView.reloadSections(IndexSet(integer: 0))
        
        if infoArr.count == 0 {
            self.emptyGuideView.alpha = 1.0
        }
    }
    
    func folderingToChallenge() {
        
        showToast("\(dictionarySelectedIndexPath.count)개의 루트 파인딩이 '도전 중'으로 이동했습니다.", withDuration: 3.0, delay: 0.1)
    }
    
    func folderingToSuccess() {
        
        showToast("\(dictionarySelectedIndexPath.count)개의 루트 파인딩이 '도전 성공'으로 이동했습니다.", withDuration: 3.0, delay: 0.1)
    }
    
    func showToast(_ message : String, withDuration: Double, delay: Double) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.orrWhite!.withAlphaComponent(1.0)
        toastLabel.layer.borderColor = UIColor.orrGray200?.cgColor
        toastLabel.textColor = UIColor.orrGray700
        toastLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        
        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.snp_bottomMargin).offset(-12)
            $0.width.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(42)
        }
        
        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
