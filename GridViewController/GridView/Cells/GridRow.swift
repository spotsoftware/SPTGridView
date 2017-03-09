//
//  GridRow.swift
//  GridViewController
//
//  Created by Luca Giorgetti on 07/03/17.
//  Copyright © 2017 SPOT Software. All rights reserved.
//

import UIKit

class GridRow: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    //MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Variables
    
    private var gridView:GridView!
    
    private var rowIndex:Int!
    
    private var columnsCount:Int!
    
    private var gridViewProtocol:GridViewProtocol?
    
    private var registeredCells:[RegisteredCell] = []
    
    private var registeredSupplementaryView:[RegisteredSupplementaryView] = []
    
    //MARK: Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initializeCell (
        gridView:GridView,
        registeredCells:[RegisteredCell],
        registeredSupplementaryView:[RegisteredSupplementaryView],
        rowIndex:Int,
        numberOfColumns:Int,
        gridViewProtocol:GridViewProtocol
        ) {
        
        self.gridView = gridView
        self.rowIndex = rowIndex
        self.columnsCount = numberOfColumns
        self.gridViewProtocol = gridViewProtocol
        
        registeredCells.forEach { (registered) in
            self.collectionView.register(registered.nib, forCellWithReuseIdentifier: registered.reuseIdentifier)
        }
        
        registeredSupplementaryView.forEach { (registered) in
            self.collectionView.register(registered.nib, forSupplementaryViewOfKind: registered.supplementaryViewOfKind, withReuseIdentifier: registered.reuseIdentifier)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.reloadData()
    }
    
    //MARK: UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.columnsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        var width = self.gridViewProtocol?.gridView?(self.gridView, widthFor: CGFloat(indexPath.section)) ?? Constants.Defaults.colWidth
        width = width < 0 ? Constants.Defaults.colWidth : width
        
        var height = self.gridViewProtocol?.gridView?(self.gridView, heightFor: CGFloat(rowIndex)) ?? Constants.Defaults.rowHeight
        height = height < 0 ? Constants.Defaults.rowHeight : height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var leftInset:CGFloat
        if section == 0 {
            leftInset = 0
        }
        else {
            leftInset = self.gridViewProtocol?.gridView?(self.gridView, spaceOnLeftOf: CGFloat(section)) ?? 0
        }
        let inset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let point = CGPoint(x: indexPath.section, y: rowIndex)
        let reuseIdentifier = self.gridViewProtocol?.reuseIdentifier(for: point)
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier!, for: indexPath)
        return (self.gridViewProtocol?.gridView(self.gridView, cell: cell, forPointAt: point))!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let point = CGPoint(x: indexPath.section, y: rowIndex)
        self.gridViewProtocol?.gridView?(self.gridView, didSelectItemAt: point)
    }
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let userInfo = [
            Constants.Notifications.Fields.xPosition : self.collectionView.contentOffset.x,
            Constants.Notifications.Fields.scrollView : self.collectionView
            ] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.kPostScrollOnXAxis), object: nil, userInfo: userInfo)
    }
    
    func updateScrollPosition(xValue: CGFloat, scrollView: UICollectionView) {
        if !scrollView.isEqual(self.collectionView) {
            self.collectionView.contentOffset.x = xValue
        }
    }
    
    //MARK: Public methods
    
    func initializeXContentOffset (xContentOffset:CGFloat) {
        self.collectionView.contentOffset.x = xContentOffset
    }
    
    func addObservers () {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GridRow.updatePosition),
            name: NSNotification.Name(rawValue: Constants.Notifications.kPostScrollOnXAxis),
            object: nil)
    }
    
    func removeObservers () {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updatePosition (notification:Notification) {
        guard let userInfo = notification.userInfo as? [String : Any],
            let xPosition = userInfo[Constants.Notifications.Fields.xPosition] as? CGFloat,
            let scrollView = userInfo[Constants.Notifications.Fields.scrollView] as? UICollectionView else { return }
        
        if !scrollView.isEqual(self.collectionView) {
            self.collectionView.contentOffset.x = xPosition
        }
    }
}
