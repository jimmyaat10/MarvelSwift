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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var didSetupConstraints = false
    
    let tableView: UITableView = UITableView()
    let cellIdentifier = "CharacterCell"
    var characters: [CharacterModel] = []
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    // MARK: Load Methods
    
    func loadData() -> Void {
        ApiManager.sharedInstance.getCharacters(
            {(result) in
                if let listChar = result.value?.characters {
                    self.characters = listChar
                    self.setupTableView()
                }
            })
            {(error) in
                print("Error: ", error);
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = self.characters[indexPath.row]
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? CharacterCell
            else { fatalError("Unexpected cell type at \(indexPath)") }
        cell.configureCell(object)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CharacterCell.preferredHeight();
    }
    
}

