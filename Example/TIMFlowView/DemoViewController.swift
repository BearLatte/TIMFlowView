//
//  DemoViewController.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

let CellID = "DemoCell"

class DemoViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "普通瀑布流"
        case 1:
            cell.textLabel?.text = "带有 header 的瀑布流"
        case 2:
            cell.textLabel?.text = "模仿 UICollectionView"
        default:
            break
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var destination: UIViewController! = nil
        
        switch indexPath.row {
        case 0:
            destination = DefaultDemoController()
        case 1:
            destination = HeaderDemoController()
        case 2:
            destination = CollectionDemoController()
        default:
            break
        }
        
        navigationController?.pushViewController(destination, animated: true)
    }

}
