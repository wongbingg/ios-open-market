//
//  TableViewController.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/12.
//

import UIKit

class TableViewController: UITableViewController {
    
    private var productList: [Product]?
    var manager = Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "ItemCell")
        manager.dataTask { result in
            self.productList = result.pages
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return productList?.count ?? 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! TableViewCell
        guard let productList = productList else {
            return UITableViewCell()
        }
        let selectedProduct = productList[indexPath.row]
//        cell.layoutIfNeeded()
        cell.setupCellData(with: selectedProduct)
//        tableView.reloadData()
        return cell
    }
}
