//
//  ResultTableViewCell.swift
//  tw_cc_v1
//
//  Created by Lukáš Vraný on 21.04.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import Foundation
import UIKit
import LTMorphingLabel

class ResultTableViewCell: UITableViewCell, LTMorphingLabelDelegate {

	weak var lblName: LTMorphingLabel!
	weak var lblValue: LTMorphingLabel!

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let name = LTMorphingLabel()
		let value = LTMorphingLabel()
        
        value.textAlignment = .Right
        value.setContentCompressionResistancePriority(1500, forAxis: .Horizontal)

		let stackView = UIStackView(arrangedSubviews: [name, value])
		stackView.axis = .Horizontal
		stackView.spacing = 10
		contentView.addSubview(stackView)
		stackView.snp_makeConstraints { make in
			make.edges.equalTo(contentView)
		}

		self.lblName = name
		self.lblValue = value
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}