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
    weak var lblSmile: UIImageView!

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		let name = LTMorphingLabel()
        let smile = UIImageView()
        smile.contentMode = UIViewContentMode.ScaleAspectFit
        
        smile.snp_makeConstraints { (make) in
            make.width.equalTo(30)
        }
        
		let stackView = UIStackView(arrangedSubviews: [smile, name])
		stackView.axis = .Horizontal
		stackView.spacing = 10
		contentView.addSubview(stackView)
		stackView.snp_makeConstraints { make in
			make.edges.equalTo(contentView)
		}

		self.lblName = name
        self.lblSmile = smile
        
        contentView.snp_makeConstraints { (make) in
            make.height.equalTo(50)
        }
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}