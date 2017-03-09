//
//  ViewController.swift
//  GridViewController
//
//  Created by Luca Giorgetti on 07/03/17.
//  Copyright © 2017 SPOT Software. All rights reserved.
//

import UIKit

enum cellType {
    case type1, type2
}

class ViewController: UIViewController, GridViewProtocol, SettingsVCDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var gridView: GridView!
    
    //MARK: Variables
    
    static var rows = 20
    
    static var cols = 20
    
    static var rowsHeight:CGFloat = 100
    
    static var colsWidth:CGFloat = 100
    
    static var spaceBetweenRows:CGFloat = 10
    
    static var spaceBetweenCols:CGFloat = 10
    
    static var spaceAfterFirstRow:CGFloat = 10
    
    static var spaceAfterFirstCol:CGFloat = 10
    
    private var datasource:[[cellType]] = []
    
    //MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Interface of the grid view
        self.gridView.gridViewProtocol = self
        
        //Register of all cell types
        self.gridView.register(nib: UINib(nibName: "ExampleCell01", bundle: nil), forCellWithReuseIdentifier: "ExampleCell01")
        self.gridView.register(nib: UINib(nibName: "ExampleCell02", bundle: nil), forCellWithReuseIdentifier: "ExampleCell02")
        
        self.createFakeDatasource()
    }
    
    //MARK: GridViewProtocol
    
    func numberOfRows(in gridVc: GridView) -> Int {
        return self.datasource.count
    }
    
    func numberOfColumns(in gridVc: GridView) -> Int {
        if self.datasource.count > 0 {
            return self.datasource.first?.count ?? 0
        }
        else {
            return 0
        }
    }
    
    func reuseIdentifier(for point:CGPoint) -> String {
        let row = self.datasource[Int(point.y)]
        let item = row[Int(point.x)]
        
        if item == .type1 {
            return "ExampleCell01"
        }
        else {
            return "ExampleCell02"
        }
    }
    
    func gridView(_ gridVc: GridView, cell:UICollectionViewCell, forPointAt point: CGPoint) -> UICollectionViewCell {
        
        let row = self.datasource[Int(point.y)]
        let item = row[Int(point.x)]
        
        let s = "X:" + String(describing: Int(point.x)) + "\nY:" + String(describing: Int(point.y))
        
        if item == .type1 {
            let tmpCell = cell as! ExampleCell01
            tmpCell.lblCell.text = s
            return tmpCell
        }
        else {
            let tmpCell = cell as! ExampleCell02
            tmpCell.lblCell.text = s
            return tmpCell
        }
    }
    
    func gridView(_ gridView: GridView, spaceOver row: CGFloat) -> CGFloat {
        if row == 1 {
            return ViewController.spaceAfterFirstRow
        }
        return ViewController.spaceBetweenRows
    }
    
    func gridView(_ gridView: GridView, spaceOnLeftOf col: CGFloat) -> CGFloat {
        if col == 1 {
            return ViewController.spaceAfterFirstCol
        }
        return ViewController.spaceBetweenCols
    }
    
    func gridView(_ gridVc: GridView, heightFor row: CGFloat) -> CGFloat {
        return ViewController.rowsHeight
    }
    
    func gridView(_ gridVc: GridView, widthFor col: CGFloat) -> CGFloat {
        if col == 1 {
            return 50
        }
        return ViewController.colsWidth
    }

    func gridView(_ gridView: GridView, didSelectItemAt point: CGPoint) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? SettingsVC {
            vc.delegate = self
        }
    }
    
    //MARK - : SettingsVCDelegate
    
    func onSavePressed() {
        self.createFakeDatasource()
    }
    
    //MARK - : Private methods
    
    private func createFakeDatasource () {
        
        var tmpDatasource:[[cellType]] = []
        for index1 in stride(from: 0, to: ViewController.rows, by: 1) {
            var tmpRow:[cellType] = []
            for index2 in stride(from: 0, to: ViewController.cols, by: 1) {
                if index1 % 2 == 0 {
                    if index2 % 2 == 0 {
                        tmpRow.append(.type1)
                    }
                    else {
                        tmpRow.append(.type2)
                    }
                }
                else {
                    if index2 % 2 == 0 {
                        tmpRow.append(.type2)
                    }
                    else {
                        tmpRow.append(.type1)
                    }
                }
            }
            tmpDatasource.append(tmpRow)
        }
        self.datasource = tmpDatasource
        self.gridView.reloadData()
    }
}

