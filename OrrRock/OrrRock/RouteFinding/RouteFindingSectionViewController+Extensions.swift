//
//  RouteFindingSectionViewController+Extensions.swift
//  OrrRock
//
//  Created by dohankim on 2022/11/25.
//

import UIKit
import SnapKit

extension RouteFindingSectionViewController: UICollectionViewDelegate {
    
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
            supplementaryView.prepare(title: "\(routeInformations.count)개의 도전", subtitle: "편집",isEditing: mMode == .view ? false : true)
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

extension RouteFindingSectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routeInformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 실사들어오면 사용할 것들
//        let screenBounds = UIScreen.main.bounds
//        let screenScale = UIScreen.main.scale
//        let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
        
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteFindingCollectionViewCustomCell", for: indexPath) as! RouteFindingCollectionViewCustomCell
        cell.cellLevelLabel.text = "V\(routeInformations[index].problemLevel)"
        cell.cellChallengeLabel.text = routeInformations[index].isChallengeComplete ? "도전 성공" : "도전 중"
        cell.cellDateLabel.text = routeInformations[index].dataWrittenDate.timeToString()
        cell.cellTitleLabel.text = routeInformations[index].gymName
        cell.cellImage.image = routeFindingDataManager?.getRouteFindingList()[index].imageLocalIdentifier.generateCardViewThumbnail()
        cell.isSelectable = mMode == .select ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mMode {
        case .view:
            routeFindingCollectionView.deselectItem(at: indexPath, animated: true)
            //화면이동 로직 들어갈 부분
            let index = indexPath.row
            guard let route = routeFindingDataManager?.getRouteFindingList()[index] else { return }

            let routeDataDraft = RouteDataDraft(manager: routeFindingDataManager!, existingRouteFinding: route, imageLocalIdentifier: route.imageLocalIdentifier)
            let vc = RouteFindingDetailViewController(routeDataDraft: routeDataDraft)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
            changeStatusOfChangeFolderButtons(to: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select {
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
        return minimumInteritemSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - minimumInteritemSpacingForSection / 2
        return CGSize(width: width, height: width * cellScaleBetweenWidthAndHeight)
    }
}

extension RouteFindingSectionViewController: RouteFindingCollectionViewHeaderCellDelegate {
    func tapEditButton() {
        mMode = mMode == .view ? .select : .view
    }
}

extension RouteFindingSectionViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
    }
}

extension RouteFindingSectionViewController: RouteModalDelegate {
    
    func delete() {
        var deleteNeededIndexPaths : [IndexPath] = []
        for (key,value) in dictionarySelectedIndexPath {
            if value {
                deleteNeededIndexPaths.append(key)
            }
        }
        initEditRouteInformationsData(editType: .delete)
        deselectAllItemsInRouteFindingCollectionView()
        routeFindingCollectionView.deleteItems(at: deleteNeededIndexPaths)
        afterEdit(type: .delete)
    }
    
    func folderingToChallenge() {
        changeFoldering(to: .toChallenge)
    }
    
    func folderingToSuccess() {
        changeFoldering(to: .toSuccess)
    }
    
    private func changeFoldering(to editType: RouteFindingEditType) {
        initEditRouteInformationsData(editType: editType)
        deselectAllItemsInRouteFindingCollectionView()
        afterEdit(type: editType)
    }
    
    private func initEditRouteInformationsData(editType : RouteFindingEditType) {
        var temporarySavedIndexPaths: [IndexPath] = []
        for (key,value) in dictionarySelectedIndexPath {
            if value {
                temporarySavedIndexPaths.append(key)
            }
        }
        if editType == .delete {
            editRouteInformationsData(editType: .delete, at: temporarySavedIndexPaths)
        } else {
            switch sectionKind {
            case .all:
                for i in temporarySavedIndexPaths.sorted(by:{$0.item > $1.item}) {
                    routeFindingDataManager?.updateRouteStatus(to: editType == .toSuccess ? true : false, of: routeInformations[i.item])
                }
            case .challenge:
                if editType == .toSuccess {
                    editRouteInformationsData(editType: editType, at: temporarySavedIndexPaths)
                }
            case .success:
                if editType == .toChallenge {
                    editRouteInformationsData(editType: editType, at: temporarySavedIndexPaths)
                }
            case .none:
                break
            }
        }
    }
    
    private func editRouteInformationsData(editType: RouteFindingEditType, at temporarySavedIndexPaths: [IndexPath]) {
        switch editType {
        case .delete:
            deleteRouteInformationsData(at: temporarySavedIndexPaths)
        case .toChallenge:
            changeSuccessToChallenge(at: temporarySavedIndexPaths)
        case .toSuccess:
            changeChallengeToSuccess(at: temporarySavedIndexPaths)
        }
    }
    
    private func deleteRouteInformationsData(at temporarySavedIndexPaths: [IndexPath]) {
        for i in temporarySavedIndexPaths.sorted(by:{$0.item > $1.item}) {
            routeFindingDataManager!.deleteRouteData(routeInformation: routeInformations[i.item])
            routeInformations.remove(at: i.item)
        }
    }
    
    private func changeSuccessToChallenge(at temporarySavedIndexPaths: [IndexPath]) {
        for i in temporarySavedIndexPaths.sorted(by:{$0.item > $1.item}) {
            routeFindingDataManager?.updateRouteStatus(to: false, of: routeInformations[i.item])
            routeInformations.remove(at: i.item)
        }
        routeFindingCollectionView.deleteItems(at: temporarySavedIndexPaths)
    }
    
    private func changeChallengeToSuccess(at temporarySavedIndexPaths: [IndexPath]) {
        for i in temporarySavedIndexPaths.sorted(by:{$0.item > $1.item}) {
            routeFindingDataManager?.updateRouteStatus(to: true, of: routeInformations[i.item])
            routeInformations.remove(at: i.item)
        }
        routeFindingCollectionView.deleteItems(at: temporarySavedIndexPaths)
    }
    
    private func deselectAllItemsInRouteFindingCollectionView() {
        for (key,value) in dictionarySelectedIndexPath {
            if value {
                routeFindingCollectionView.deselectItem(at: key, animated: true)
            }
        }
    }
    
    private func afterEdit(type : RouteFindingEditType) {
        switch type {
        case .delete:
            showToast("\(dictionarySelectedIndexPath.count)개의 루트 파인딩을 삭제했습니다.", withDuration: 1.0, delay: 1.0)
        case .toChallenge:
            showToast("\(dictionarySelectedIndexPath.count)개의 루트 파인딩이 '도전 중'으로 이동했습니다.", withDuration: 1.0, delay: 0.0)
        case .toSuccess:
            showToast("\(dictionarySelectedIndexPath.count)개의 루트 파인딩이 '도전 성공'으로 이동했습니다.", withDuration: 1.0, delay: 0.1)
        }
        backToDefaultRouteFindingSectionViewSetting()
    }
    
    private func backToDefaultRouteFindingSectionViewSetting() {
        dictionarySelectedIndexPath.removeAll()
        mMode = .view
        changeStatusOfChangeFolderButtons(to: false)
        backToDefaultRouteFindingCollectionViewSetting()
        checkAndShowEmptyGuideView()
    }
    
    private func backToDefaultRouteFindingCollectionViewSetting() {
        routeFindingCollectionView.allowsMultipleSelection = false
        routeFindingCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    private func checkAndShowEmptyGuideView() {
        if routeInformations.count == 0 {
            self.emptyGuideView.alpha = 1.0
        }
    }
    
    func changeStatusOfChangeFolderButtons(to status : Bool) {
        folderButton.isEnabled = status
        deleteButton.isEnabled = status
    }
    
    private func showToast(_ message : String, withDuration: Double, delay: Double) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.orrWhite!.withAlphaComponent(1.0)
        toastLabel.layer.borderColor = UIColor.orrGray200?.cgColor
        toastLabel.layer.borderWidth = 1.0
        toastLabel.textColor = UIColor.orrGray700
        toastLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        
        view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.snp_bottomMargin).offset(-12)
            $0.width.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.height.equalTo(42)
        }
        UIView.animate(withDuration: 0.5, delay: 0) {
            toastLabel.alpha = 1.0
        }completion: { _ in
            UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    
}
