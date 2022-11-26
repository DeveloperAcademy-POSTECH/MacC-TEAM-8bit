//
//  RouteFindingThumbnailCollectionViewFlowLayout.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/25.
//  https://stackoverflow.com/questions/35045155/how-to-create-a-centered-uicollectionview-like-in-spotifys-player

import UIKit

final class RouteFindingThumbnailCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let collectionViewCellSize: Int = 62
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        minimumLineSpacing = 2
        minimumInteritemSpacing = 2
        itemSize = CGSize(width: collectionViewCellSize, height: collectionViewCellSize)
    }
    
    // 스크롤 시 스크롤이 정지할 것으로 예상되는 지점을 반환하는 메서드
    // 이 메서드를 수정하여, 개발 시 의도한 지점에서 스크롤이 정지하도록 설정 가능
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // proposedContentOffset : 스크롤이 자연스럽게 정지하는 지점의 좌표(좌상단 좌표)
        // velocity : 스크롤 속도
        
        guard let collectionView = collectionView else { return .zero }
        
        // 특정 좌표(사각형 범위 내)에 있는 레이아웃 요소들을 가져오기
        // rectAttributes에 collectionView 내 셀들의 정보를 저장함
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionView.frame.width,
                                height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        // CollectionView의 정 가운데 = CollectionView의 좌측 좌표 + CollectionView width의 절반
        // horizontalCenter 위치에 셀이 정지하도록 설정
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        // offsetAdjustment를 CGFloat으로 표현가능한 가장 큰 값으로 초기화
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        
        
        for layoutAttributes in rectAttributes {
            // 셀의 중간 값 위치에 대해
            let itemHorizontalCenter = layoutAttributes.center.x
            // 셀 중간값과 화면 중간값의 차가 더 작은 값을 offsetAdjustment로 지정
            // = 정지할 것으로 예상되는 지점에서 가장 가까운 셀 대한 거리 차이를 offsetAdjustment에 저장
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        // 정지 예상 지점에서 가장 가까운 셀까지의 거리를 더해, 셀 위치에 정지할 수 있도록 지정
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    // MARK: 필요 시 사용할 함수
    
    //    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    //        return true
    //    }
    //
    //    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
    //        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
    //        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
    //        return context
    //    }
}
