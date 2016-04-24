//
//  ResultTableViewCell.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 21.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit

class ResultTableViewCell: UITableViewCell {

	weak var name: UILabel!
	weak var value: UILabel!

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let name = UILabel()
		let value = UILabel()

		let stackView = UIStackView(arrangedSubviews: [name, value])
		stackView.axis = .Horizontal
		stackView.spacing = 10
		contentView.addSubview(stackView)
		stackView.snp_makeConstraints { make in
			make.edges.equalTo(contentView)
		}

		self.name = name
		self.value = value
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}