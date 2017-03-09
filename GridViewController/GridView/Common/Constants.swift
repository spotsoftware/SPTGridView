//
//  Constants.swift
//  GridViewController
//
//  Created by Luca Giorgetti on 09/03/17.
//  Copyright © 2017 SPOT Software. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Defaults {
        
        static let rowHeight:CGFloat = 50
        
        static let colWidth:CGFloat = 50
    }
    
    struct Identifiers {
        
        static let rowIdentifier = "GridRow"
    }
    
    struct Notifications {
        
        struct Fields {
            
            static let xPosition = "xPosition"
            
            static let scrollView = "scrollView"
        }
        
        static let kPostScrollOnXAxis = "kPostScrollOnXAxis"
    }
}
