//
//  SwipeableButton.swift
//  czyPojade
//
//  Created by Błażej Wdowikowski on 28/05/2016.
//  Copyright © 2016 dudi. All rights reserved.
//

import UIKit

class SwipeableButton: UIButton {
    
    var onTouchUpInside:(Void->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(SwipeableButton.didTouchUpInside(_:)), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    func didTouchUpInside(sender:AnyObject) {
        self.onTouchUpInside?()
    }
    
}
