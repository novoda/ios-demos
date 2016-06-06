//
//  ValueInRange.swift
//  Kaleidoscope
//
//  Created by Wagner Truppel on 24/05/2016.
//  Copyright © 2016 Restless Brain. All rights reserved.
//

import UIKit


struct ValueInRange<T: Comparable>
{
    let minimum: T
    let maximum: T
    var current: T
    let step: T?

    init(minimum: T, maximum: T, current: T, step: T? = nil)
    {
        guard minimum <= current && current <= maximum else
        { fatalError("'(\(minimum), \(current), \(maximum))' do not satisfy \(minimum) ≤ \(current) ≤ \(maximum)") }

        self.minimum = minimum
        self.maximum = maximum
        self.current = current
        self.step = step
    }
}
