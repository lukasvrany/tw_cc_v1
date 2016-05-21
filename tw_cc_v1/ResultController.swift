//
//  ResultController.swift
//  tw_cc_v1
//
//  Created by EN on 12.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit
import SnapKit
import LTMorphingLabel

class ResultController: UIViewController, LTMorphingLabelDelegate {

	private let cellId = "cellId"
	weak var tableView: UITableView!

	let collector = Collector.Instance()

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
			make.top.equalTo(view)
			make.trailing.equalTo(view)
			make.leading.equalTo(view)
			make.height.equalTo(300)
		}
		self.tableView = tableView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collector.calculateBehaviour()

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ResultController: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return collector.getBehaviourCount()
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! ResultTableViewCell

		let behaviour = collector.behaviours[indexPath.row]

		cell.lblName.text = behaviour.destricption
		cell.lblValue.text = String(behaviour.coeficient)

		return cell
	}
}

extension ResultController: UITableViewDelegate {
}

