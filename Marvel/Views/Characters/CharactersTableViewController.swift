//
//  ViewController.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class CharactersTableViewController: UIViewController, UITableViewDelegate{
    
    var didSetupConstraints = false
    
    let tableView: UITableView = UITableView()
    let cellIdentifier = "CharacterCell"
    var charactersData = CharacterDataType()
    private var dataSource = CharacterDataSource()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
    
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            tableView.snp_makeConstraints(closure: { (make) in
                make.size.equalTo(view)
                make.centerX.equalTo(view.snp_centerX)
                make.centerY.equalTo(view.snp_centerY)
            })
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Setup Methods
    
    func setupView() -> Void {
        self.title = "Characters"
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        tableView.registerClass(CharacterCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        view.setNeedsUpdateConstraints()
    }
    
    func setupTableView() -> Void {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    // MARK: Load Methods
    
    func loadData() -> Void {
        ApiManager.sharedInstance.getCharacters(
            {(result) in
                if let listChar = result.value?.characters {
                    self.charactersData = CharacterDataType(characters:listChar)
                    self.dataSource.dataObject = self.charactersData
                    self.setupTableView()
                }
            })
            {(error) in
                print("Error: ", error);
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CharacterCell.preferredHeight();
    }
    
}
