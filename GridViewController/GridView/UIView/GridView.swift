//
//  GridView.swift
//  GridViewController
//
//  Created by Luca Giorgetti on 08/03/17.
//  Copyright © 2017 SPOT Software. All rights reserved.
//

import UIKit

struct RegisteredCell {
    
    var nib:UINib!
    
    var reuseIdentifier:String!
}

struct RegisteredSupplementaryView {
    
    var nib:UINib!
    
    var supplementaryViewOfKind: String!
    
    var reuseIdentifier: String!
}

@objc protocol GridViewProtocol {
    
    func numberOfRows(in gridVc: GridView) -> Int
    
    func numberOfColumns(in gridVc: GridView) -> Int
    
    func reuseIdentifier(for point:CGPoint) -> String
    
    func gridView(_ gridVc: GridView, cell:UICollectionViewCell, forPointAt point: CGPoint) -> UICollectionViewCell
    
    @objc optional func gridView(_ gridVc: GridView, heightFor row: CGFloat) -> CGFloat
    
    @objc optional func gridView(_ gridVc: GridView, widthFor col: CGFloat) -> CGFloat
    
    @objc optional func gridView(_ gridView: GridView, spaceOver row: CGFloat) -> CGFloat
    
    @objc optional func gridView(_ gridView: GridView, spaceOnLeftOf col: CGFloat) -> CGFloat
    
    @objc optional func gridView(_ gridView: GridView, didSelectItemAt point: CGPoint)
}

class GridView: UIView, UITableViewDelegate, UITableViewDataSource {

    //MARK: Outlets

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    
    var gridViewProtocol:GridViewProtocol?
    
    private var rowsCount:Int?
    
    private var registeredCells:[RegisteredCell] = []
    
    private var registeredSupplementaryViews:[RegisteredSupplementaryView] = []
    
    private var xContentOffset:CGFloat = 0
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GridView", owner: self, options: nil)
        contentView.frame = self.bounds
        
        
        let nib = UINib(nibName: Constants.Identifiers.rowIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Constants.Identifiers.rowIdentifier)
        self.tableView.estimatedRowHeight = 80
        
        self.addSubview(contentView)
    }
    
    func initializeView (gridViewProtocol:GridViewProtocol) {
        self.gridViewProtocol = gridViewProtocol
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        NotificationCenter.default.addObserver(self, selector: #selector(GridView.onHorizontalScrollPerformed), name: NSNotification.Name(rawValue: Constants.Notifications.kPostScrollOnXAxis), object: nil)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.rowsCount = self.gridViewProtocol?.numberOfRows(in: self) ?? 0
        return self.rowsCount!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = self.gridViewProtocol?.gridView?(self, heightFor: CGFloat(indexPath.section)) ?? Constants.Defaults.rowHeight
        height = height < 0 ? Constants.Defaults.rowHeight : height
        
        return self.gridViewProtocol?.gridView?(self, heightFor: CGFloat(indexPath.section)) ?? Constants.Defaults.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.gridViewProtocol?.gridView?(self, spaceOver: CGFloat(section)) ?? CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GridRow", for: indexPath) as! GridRow
        let numberOfColumns = self.gridViewProtocol?.numberOfColumns(in: self) ?? 0
        cell.initializeCell(
            gridView: self,
            registeredCells:self.registeredCells,
            registeredSupplementaryView:self.registeredSupplementaryViews,
            rowIndex: indexPath.section,
            numberOfColumns: numberOfColumns,
            gridViewProtocol: self.gridViewProtocol!
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let gridRow = cell as? GridRow {
            gridRow.initializeXContentOffset(xContentOffset: self.xContentOffset)
            gridRow.addObservers()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let gridRow = cell as? GridRow {
            gridRow.removeObservers()
        }
    }
    
    //MARK: Notifications
    
    func onHorizontalScrollPerformed (notification:Notification) {
        guard let userInfo = notification.userInfo as? [String : Any],
            let xPosition = userInfo[Constants.Notifications.Fields.xPosition] as? CGFloat else { return }
        
        self.xContentOffset = xPosition
    }
    
    //MARK: Public methods
    
    func register (nib:UINib, forCellWithReuseIdentifier: String) {
        let registered = RegisteredCell(nib: nib, reuseIdentifier: forCellWithReuseIdentifier)
        self.registeredCells.append(registered)
    }
    
    func register (nib:UINib, forSupplementaryViewOfKind: String, withReuseIdentifier: String) {
        let registered = RegisteredSupplementaryView(nib: nib, supplementaryViewOfKind: forSupplementaryViewOfKind, reuseIdentifier: withReuseIdentifier)
        self.registeredSupplementaryViews.append(registered)
    }
    
    func reloadData () {
        self.tableView.reloadData()
    }
    
}
