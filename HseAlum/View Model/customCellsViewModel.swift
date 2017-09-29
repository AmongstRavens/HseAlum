//
//  customCellsViewModel.swift
//  HseAlum
//
//  Created by Sergey on 9/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import Foundation

class CustomCellViewModel{
    private var cellsDescriptors: NSMutableArray!
    private var visibleRows = [[Int]]()
    
    func loadCellDescriptor(for descriptionName: String){
        //Change here for descriptionName
        if let path = Bundle.main.path(forResource: "accountTableViewCellsDescription", ofType: "plist"){
            let url = URL(fileURLWithPath: path)
            cellsDescriptors = NSMutableArray(contentsOf: url)
        }
        
        getVisibleRowsIndexes()
        reloadTableView()
    }
    
    func getVisibleRowsIndexes(){
        visibleRows.removeAll()
        for sectionDescriptor in cellsDescriptors as! [[[String : AnyObject]]]{
            var visibleRowsInSection = [Int]()
            for row in 0...(sectionDescriptor.count - 1) {
                if sectionDescriptor[row]["isVisible"] as! Bool == true {
                    visibleRowsInSection.append(row)
                }
            }
            visibleRows.append(visibleRowsInSection)
        }
    }
    
    func getCellDescriptior(for indexPath: IndexPath) -> [String : AnyObject]{
        let visibleRowIndex = visibleRows[indexPath.section][indexPath.row]
        return (cellsDescriptors[indexPath.section] as! [[String : AnyObject]])[visibleRowIndex]
    }
    
    
    private func reloadTableView(){
        NotificationCenter.default.post(name: NSNotification.Name("AccountUIObserver"), object: nil)
    }
    
    //MARK: Functions for UITableViewDataSource
    
    func numberOfSections() -> Int{
        if cellsDescriptors != nil{
            return cellsDescriptors.count
        } else {
            return 0
        }
    }
    
    func numberOfRows(in section: Int) -> Int{
        return visibleRows[section].count
    }
    
}
