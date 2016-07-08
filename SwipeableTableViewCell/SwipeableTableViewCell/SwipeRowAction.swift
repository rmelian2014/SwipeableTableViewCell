//
//  File.swift
//  czyPojade
//
//  Created by Błażej Wdowikowski on 27/05/2016.
//  Copyright © 2016 dudi. All rights reserved.
//

import UIKit

private let DefaultWidth:CGFloat = 80.0

public struct SwipeRowAction {
    
    public var title: String?
    public var image: UIImage?
    public var backgroundColor: UIColor?
    public var width: CGFloat = DefaultWidth
    public var action: (Void) -> Void
    
}