//
//  SettingsTableViewController.swift
//  HseAlum
//
//  Created by Sergey on 10/22/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    //MARK: Fields
    private var customCellsViewModel : CustomCellViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        customCellsViewModel = CustomCellViewModel()
        customCellsViewModel.loadCellDescriptor(for: "settingsCells")
        tableView.register(UINib(nibName: "switchCell", bundle: nil), forCellReuseIdentifier: "Switch Cell")
        tableView.register(UINib(nibName: "dropdownButtonCell", bundle: nil), forCellReuseIdentifier: "Dropdown Cell")
    }
    
    //MARK: TableViewDataSource/Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customCellsViewModel.numberOfRows(for: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return customCellsViewModel.numberOfTableViews
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hello"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDescriptor = customCellsViewModel.getCellDescriptior(for: indexPath, index: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor["cellIdentifier"] as! String, for: indexPath) as! CustomCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    

}
