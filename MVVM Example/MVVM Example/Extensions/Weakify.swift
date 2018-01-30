//
//  Weakify.swift
//  MVVM Example
//
//  Created by Niamh Power on 30/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation

import Foundation

public func weakify<Context: AnyObject>(_ context: Context, closure: @escaping (Context) -> Void) -> () -> Void {
    return { [weak context] in
        guard let context = context else { return }
        closure(context)
    }
}

public func weakify<Context: AnyObject, Argument1>(_ context: Context, closure: @escaping (Context, Argument1) -> Void) -> (Argument1) -> Void {
    return { [weak context] argument in
        guard let strongContext = context else { return }
        closure(strongContext, argument)
    }
}

public func weakify<Context: AnyObject, Argument>(_ context: Context, method: @escaping (Context) -> (Argument) -> Void) -> (Argument) -> Void {
    return { [weak context] argument in
        guard let strongContext = context else { return }
        method(strongContext)(argument)
    }
}

public func unowned<Context: AnyObject, Argument1, Argument2, Argument3, R>(_ context: Context, method: @escaping (Context) -> (Argument1, Argument2, Argument3) -> R) -> (Argument1, Argument2, Argument3) -> R {
    return { [unowned context] argument1, argument2, argument3 in
        return method(context)(argument1, argument2, argument3)
    }
}

public func weakify<Context1: AnyObject, Argument1, Argument2>(_ context1: Context1?, closure: @escaping (Context1, Argument1, Argument2) -> Void) -> (Argument1, Argument2) -> Void {
    return { [weak context1] argument1, argument2 in
        guard let strongContext1 = context1 else { return }
        closure(strongContext1, argument1, argument2)
    }
}
