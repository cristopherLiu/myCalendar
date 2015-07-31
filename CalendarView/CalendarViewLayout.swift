//
//  MNCalendarViewLayout.swift
//  myCalendar
//
//  Created by hjliu on 2015/6/3.
//  Copyright (c) 2015年 hjliu. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        self.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        self.sectionInset = UIEdgeInsetsZero
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.headerReferenceSize = CGSizeMake(0, 44)
        self.footerReferenceSize = CGSizeZero
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var superAttributes: [UICollectionViewLayoutAttributes]? = super.layoutAttributesForElementsInRect(rect) as? [UICollectionViewLayoutAttributes]
        
        if superAttributes == nil {
            // If superAttributes couldn't cast, return
            return super.layoutAttributesForElementsInRect(rect)
        }
        
        let contentOffset = collectionView!.contentOffset
        var missingSections = NSMutableIndexSet()
        
        for layoutAttributes in superAttributes! {
            if (layoutAttributes.representedElementCategory == .Cell) {
                if let indexPath = layoutAttributes.indexPath {
                    missingSections.addIndex(layoutAttributes.indexPath.section)
                }
            }
        }
        
        for layoutAttributes in superAttributes! {
            if let representedElementKind = layoutAttributes.representedElementKind {
                if representedElementKind == UICollectionElementKindSectionHeader {
                    if let indexPath = layoutAttributes.indexPath {
                        missingSections.removeIndex(indexPath.section)
                    }
                }
            }
        }
        
        missingSections.enumerateIndexesUsingBlock { idx, stop in
            let indexPath = NSIndexPath(forItem: 0, inSection: idx)
            if let layoutAttributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath) {
                superAttributes!.append(layoutAttributes)
            }
        }
        
        for layoutAttributes in superAttributes! {
            if let representedElementKind = layoutAttributes.representedElementKind {
                if representedElementKind == UICollectionElementKindSectionHeader {
                    let section = layoutAttributes.indexPath!.section
                    let numberOfItemsInSection = collectionView!.numberOfItemsInSection(section)
                    
                    let firstCellIndexPath = NSIndexPath(forItem: 0, inSection: section)!
                    let lastCellIndexPath = NSIndexPath(forItem: max(0, (numberOfItemsInSection - 1)), inSection: section)!
                    
                    
                    let (firstCellAttributes: UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes) = {
                        if (self.collectionView!.numberOfItemsInSection(section) > 0) {
                            return (
                                self.layoutAttributesForItemAtIndexPath(firstCellIndexPath),
                                self.layoutAttributesForItemAtIndexPath(lastCellIndexPath))
                        } else {
                            return (
                                self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: firstCellIndexPath),
                                self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionFooter, atIndexPath: lastCellIndexPath))
                        }
                        }()
                    
                    let headerHeight = CGRectGetHeight(layoutAttributes.frame)
                    var origin = layoutAttributes.frame.origin
                    
                    //                    origin.y = min(contentOffset.y, (CGRectGetMaxY(lastCellAttributes.frame) - headerHeight))
                    // Uncomment this line for normal behaviour:
                    origin.y = min(max(contentOffset.y, (CGRectGetMinY(firstCellAttributes.frame) - headerHeight)), (CGRectGetMaxY(lastCellAttributes.frame) - headerHeight))
                    
                    layoutAttributes.zIndex = 1024
                    layoutAttributes.frame = CGRect(origin: origin, size: layoutAttributes.frame.size)
                }
            }
        }
        
        return superAttributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    
    //    //自動對齊到網格
    //    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    //        var bounds = self.collectionView!.bounds
    //        bounds.origin.y = proposedContentOffset.y - self.collectionView!.bounds.size.height/2
    //        bounds.size.width *= 1.5
    //
    //        var array = super.layoutAttributesForElementsInRect(bounds)
    //        var minOffsetY = CGFloat.max
    //        var targetLayoutAttributes:UICollectionViewLayoutAttributes?
    //
    //        if let array = array{
    //            for layoutAttributes in array{
    //
    //                var layoutAttribute = layoutAttributes as! UICollectionViewLayoutAttributes
    //
    //                var str = layoutAttribute.representedElementKind
    //
    //                if str != nil {
    //                    if str == UICollectionElementKindSectionHeader{
    //                        var offsetY = fabs(layoutAttribute.frame.origin.y - proposedContentOffset.y)
    //                        if offsetY < minOffsetY{
    //                            minOffsetY = offsetY
    //
    //                            targetLayoutAttributes = layoutAttribute
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    //        if let targetLayoutAttributes = targetLayoutAttributes{
    //            return targetLayoutAttributes.frame.origin
    //        }
    //        
    //        return CGPointMake(proposedContentOffset.x, proposedContentOffset.y)
    //    }
}