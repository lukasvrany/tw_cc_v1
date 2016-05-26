//
//  TwistoInput.swift
//  tw_cc_v1
//
//  Created by EN on 26.05.16.
//  Copyright © 2016 Laky. All rights reserved.
//

import UIKit

class TwistoInput: UITextField {
    
    
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func designer(){
        textColor = UIColor.blackColor()
        layer.borderColor = UIColor.grayColor().CGColor
        layer.cornerRadius = 0
        layer.borderWidth = 1
    }
}
