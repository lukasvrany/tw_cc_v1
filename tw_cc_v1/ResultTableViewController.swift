//
//  ResultTableViewController.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 21.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit

class ResultTableViewController: UIViewController {

	private let cellId = "cellId"
	weak var tableView: UITableView!

	let rulesManager = RulesManager()

	override func loadView() {
		super.loadView()
        print(Collector.Instance().isNervous())
		self.view.backgroundColor = UIColor.whiteColor()

		let tableView = UITableView(frame: .zero, style: .Plain)
		view.addSubview(tableView)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.layoutMargins = UIEdgeInsetsZero
		tableView.separatorInset = UIEdgeInsetsZero
		tableView.registerClass(ResultTableViewCell.self, forCellReuseIdentifier: cellId)
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 30
		tableView.snp_makeConstraints { make in
			make.edges.equalTo(view)
		}
		self.tableView = tableView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension ResultTableViewController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rulesManager.allRulesCount
	}


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ResultTableViewCell
        
        
        let rule = rulesManager.allRules[indexPath.row]
        
        cell.lblName.text = rule.0
        cell.lblValue.text = String(rule.1)
        
        return cell
    }
}

extension ResultTableViewController: UITableViewDelegate {
}