//
//  PullFactory.swift
//  Afladagbokin
//
//  Created by Ivar Johannesson on 08/03/2018.
//  Copyright © 2018 Stokkur. All rights reserved.
//

import Foundation

struct PullFactory {
    
    static func fromJSON(_ json: JSON) -> Pull? {
    
        return Pull(json: json)
    }
}
