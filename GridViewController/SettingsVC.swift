//
//  SettingsVC.swift
//  GridViewController
//
//  Created by Luca Giorgetti on 09/03/17.
//  Copyright © 2017 SPOT Software. All rights reserved.
//

import UIKit

protocol SettingsVCDelegate : class {
    
    func onSavePressed ()
}

class SettingsVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var numberOfRows: UITextField!
    
    @IBOutlet weak var numberOfCols: UITextField!
    
    @IBOutlet weak var rowsHeight: UITextField!
    
    @IBOutlet weak var colsWidth: UITextField!
    
    @IBOutlet weak var spaceBetweenRows: UITextField!
    
    @IBOutlet weak var spaceBetweenCols: UITextField!

    @IBOutlet weak var spaceAfterFirstRow: UITextField!
    
    @IBOutlet weak var spaceAfterFirstCol: UITextField!
    
    var delegate:SettingsVCDelegate?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        if let valueString = self.numberOfRows.text, !valueString.isEmpty {
            ViewController.rows = Int(valueString) ?? 5
        }
        
        if let valueString = self.numberOfCols.text, !valueString.isEmpty {
            ViewController.cols = Int(valueString) ?? 5
        }
        
        if let valueString = self.rowsHeight.text, !valueString.isEmpty {
            ViewController.rowsHeight = CGFloat(Int(valueString)!)
        }
        
        if let valueString = self.colsWidth.text, !valueString.isEmpty {
            ViewController.colsWidth = CGFloat(Int(valueString)!)
        }
        
        if let valueString = self.spaceBetweenRows.text, !valueString.isEmpty {
            ViewController.spaceBetweenRows = CGFloat(Int(valueString)!)
        }
        
        if let valueString = self.spaceBetweenCols.text, !valueString.isEmpty {
            ViewController.spaceBetweenCols = CGFloat(Int(valueString)!)
        }
        
        if let valueString = self.spaceAfterFirstRow.text, !valueString.isEmpty {
            ViewController.spaceAfterFirstRow = CGFloat(Int(valueString)!)
        }
        
        if let valueString = self.spaceAfterFirstCol.text, !valueString.isEmpty {
            ViewController.spaceAfterFirstCol = CGFloat(Int(valueString)!)
        }
        
        self.dismiss(animated: true, completion: {
            self.delegate?.onSavePressed()
        })
    }
}
