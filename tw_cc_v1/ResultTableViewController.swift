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

	var info: [String: String]!

	override func loadView() {
		super.loadView()

		self.view.backgroundColor = UIColor.whiteColor()

		let tableView = UITableView(frame: .zero, style: .Plain)
		view.addSubview(tableView)
		tableView.dataSource = self
		tableView.delegate = self
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
		return info.count
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ResultTableViewCell

		let key = Array(info!.keys)[indexPath.row]

		cell.name.text = key + ":"
		cell.value.text = info![key]

		return cell
	}
}

extension ResultTableViewController: UITableViewDelegate {
}