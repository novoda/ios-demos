//
//  Created by sergdort on 14/03/2017.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation

func dispatchOnMainQueueIfNeeded(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}
