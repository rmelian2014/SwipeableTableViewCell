//
//  SwipeableScrollView.swift
//  SwipeableTableViewCell
//
//  Created by Reinier Melian on 6/2/16.
//  Copyright © 2016 47 Center, Inc. All rights reserved.
//

import UIKit

class SwipeableScrollView: UIScrollView {

    var customDelegate : UIResponder?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        customDelegate?.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            customDelegate?.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
            customDelegate?.touchesMoved(touches, withEvent: event)
    }
}
