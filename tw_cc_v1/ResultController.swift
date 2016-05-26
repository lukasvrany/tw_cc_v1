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

class ResultController: UIViewController, UITableViewDelegate, LTMorphingLabelDelegate {
    
    private let cellId = "cellId"
    weak var tableView: UITableView!
    
    let collector = Collector.Instance()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let titleLabel = UILabel()
        titleLabel.text = "Vyhodnocení"
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        titleLabel.textAlignment = .Center
        self.view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(10)
        }
        
        let tableView = UITableView(frame: .zero, style: .Plain)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(ResultTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
        
        let resultLabel = UILabel()
        resultLabel.text = "Final result"
        resultLabel.textAlignment = .Center
        resultLabel.font = UIFont(name: "HelveticaNeue", size: 19)
        
        let resultBar = UIImageView(image: UIImage(named: "bar"))
        resultBar.contentMode = UIViewContentMode.ScaleAspectFit
        resultBar.snp_makeConstraints { (make) in
            make.height.equalTo(20)
        }
        
        let resultStack = UIStackView(arrangedSubviews: [resultLabel,resultBar])
        resultStack.axis = .Vertical
        resultStack.spacing = 10
        self.view.addSubview(resultStack)
        
        resultStack.snp_makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(self.view.bottomAnchor).offset(-30)
        }
        self.view.addSubview(resultStack)
        
        tableView.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(30)
            make.width.equalTo(self.view).offset(-80)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(resultStack.snp_top)
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
        cell.lblSmile.image = behaviour.image
        
        
        return cell
    }
}