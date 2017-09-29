//
//  AccountViewController.swift
//  HseAlum
//
//  Created by Sergey on 9/29/17.
//  Copyright © 2017 Бизнес в стиле .RU. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var cellsViewModel: CustomCellViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellsViewModel = CustomCellViewModel()
        setupTableView()
        addUINotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cellsViewModel.loadCellDescriptor(for: "smth")
    }
    
    private func addUINotificationObserver(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("AccountUIObserver"), object: nil, queue: OperationQueue.main) { (notification) in
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.register(UINib(nibName: "dropdownButtonCell", bundle: nil), forCellReuseIdentifier: "Dropdown Cell")
        tableView.register(UINib(nibName: "basicCell", bundle: nil), forCellReuseIdentifier: "Basic Cell")
        tableView.register(UINib(nibName: "addItemCell", bundle: nil), forCellReuseIdentifier: "Add Item Cell")
        tableView.register(UINib(nibName: "switchCell", bundle: nil), forCellReuseIdentifier: "Switch Cell")
    }

}

//MARK: UITableViewDelegate/DataSource
extension AccountViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsViewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDescriptor = cellsViewModel.getCellDescriptior(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor["cellIdentifier"] as! String, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Информация о вузе"
        case 1:
            return "Контакты"
        default:
            return "Error"
        }
    }
}


