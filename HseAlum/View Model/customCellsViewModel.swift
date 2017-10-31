//
//  customCellsViewModel.swift
//  HseAlum
//
//  Created by Sergey on 9/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

class CustomCellViewModel{
    private var cellsDescriptors = [[NSMutableDictionary]]()
    private var visibleRows = [[Int]]()
    var numberOfTableViews : Int{
        get{
            return cellsDescriptors.count
        }
    }
    
    func loadCellDescriptor(for descriptionName: String){
        if let path = Bundle.main.path(forResource: descriptionName, ofType: "plist"){
            let url = URL(fileURLWithPath: path)
            cellsDescriptors = NSMutableArray(contentsOf: url)! as! [[NSMutableDictionary]]
        }
        
        getVisibleRowsIndexes()
        reloadTableView(for: nil)
    }
    
    private func getVisibleRowsIndexes(){
        visibleRows.removeAll()
        for sectionDescriptor in cellsDescriptors{
            var visibleRowsInSection = [Int]()
            for row in 0...(sectionDescriptor.count - 1) {
                if sectionDescriptor[row]["isVisible"] as! Bool == true {
                    visibleRowsInSection.append(row)
                }
            }
            visibleRows.append(visibleRowsInSection)
        }
    }
    
    func getCellDescriptior(for indexPath: IndexPath, index: Int) -> [String : AnyObject]{
        let visibleRowIndex = visibleRows[index][indexPath.row]
        return (cellsDescriptors[index] as! [[String : AnyObject]])[visibleRowIndex]
    }
    
    
    private func reloadTableView(for index: Int?){
        NotificationCenter.default.post(name: Notification.Name("AccountUIObserver"), object: nil, userInfo: ["index" : index as Any])
    }
    
    //MARK: Functions for UITableViewDataSource
    
    func numberOfRows(for index: Int) -> Int{
        return visibleRows[index].count
    }
    
    func handleTappingRow(at indexPath: IndexPath, for index: Int) -> String{
        let indexOfTappedRow = visibleRows[index][indexPath.row]
        let cellType = cellsDescriptors[index][indexOfTappedRow].value(forKey: "cellIdentifier") as! String
        
        if cellsDescriptors[index][indexOfTappedRow].value(forKey: "isExpandable") as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if cellsDescriptors[index][indexOfTappedRow].value(forKey: "isExpanded") as! Bool == false {
                shouldExpandAndShowSubRows = true
            }
            
            cellsDescriptors[index][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
                
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cellsDescriptors[indexPath.section][indexOfTappedRow].value(forKey: "additionalRows") as! Int)) {
                    cellsDescriptors[index][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        
        getVisibleRowsIndexes()
        reloadTableView(for: index)
        return cellType
    }
    
}
