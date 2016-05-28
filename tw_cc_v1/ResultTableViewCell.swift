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
	weak var lblSmile: UIImageView!

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let name = LTMorphingLabel()
        name.numberOfLines = 0
        name.textAlignment = .Left
		let smile = UIImageView()
		smile.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(smile)
		smile.snp_makeConstraints { (make) in
			make.leading.equalTo(5)
            make.width.equalTo(30)
            make.centerY.equalTo(contentView)
		}
        contentView.addSubview(name)
        name.snp_makeConstraints { (make) in
            make.top.equalTo(contentView.snp_top).offset(10)
            make.left.equalTo(smile.snp_right).offset(10)
            make.trailing.equalTo(-5)
            make.bottom.equalTo(contentView.snp_bottom).offset(-10)
        }

		self.lblName = name
		self.lblSmile = smile
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}