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

	var info: [String: [String: String]]!

	override func loadView() {
		super.loadView()

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
		let key = Array(info!.keys)[section]
		return info[key]!.count
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return info.count
	}

	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return Array(info!.keys)[section]
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ResultTableViewCell

		let skey = Array(info!.keys)[indexPath.section]
		let key = Array(info[skey]!.keys)[indexPath.row]

        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
		cell.name.text = key + ":"
		cell.value.text = info![skey]![key]

		return cell
	}
}

extension ResultTableViewController: UITableViewDelegate {
}