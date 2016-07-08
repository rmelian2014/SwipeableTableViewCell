//
//  Extensions.swift
//  SwipeableTableViewCell
//
//  Created by Błażej Wdowikowski on 01/06/2016.
//  Copyright © 2016 47 Center, Inc. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubviews(){
        for v in self.subviews{
            v.removeFromSuperview()
        }
    }
}
