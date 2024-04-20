//
//  ThreeSquareColumnFlowLayout.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import UIKit

class SquareColumnFlowLayout: UICollectionViewFlowLayout {
    
    var numberOfItemsPerRow = 3
    let padding = 0.0
    
    // Setup layout attributes
    override func prepare() {
        super.prepare()
        
        minimumInteritemSpacing = 15
        let horizontalSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = horizontalSpacing
        self.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

        // Calculate spacing between items
        let availableWidth = collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(numberOfItemsPerRow - 1) * minimumInteritemSpacing
        let itemWidth = (availableWidth - padding) / CGFloat(numberOfItemsPerRow)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        self.itemSize = itemSize
        
    }
    
    // Calculate content size based on item size and number of items
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        
        let sectionInset = self.sectionInset
        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(numberOfItemsPerRow - 1) * minimumInteritemSpacing
        let itemWidth = (availableWidth - padding) / CGFloat(numberOfItemsPerRow)
        
        let rowCount = collectionView.numberOfItems(inSection: 0) / numberOfItemsPerRow
        let remainder = collectionView.numberOfItems(inSection: 0) % numberOfItemsPerRow
        let rowCountPlusRemainder = remainder > 0 ? rowCount + 1 : rowCount
        
        let contentWidth = collectionView.bounds.width
        let contentHeight = CGFloat(rowCountPlusRemainder) * (itemWidth + minimumLineSpacing) - minimumLineSpacing + sectionInset.top + sectionInset.bottom
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // Invalidate layout when bounds change
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

