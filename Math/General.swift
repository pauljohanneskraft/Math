//
//  General.swift
//  Math
//
//  Created by Paul Kraft on 29.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// The <-> operator can be used to simply swap two elements 
// e.g. two array items when used like this: 
// 
// array[i] <-> array[j]
//

infix operator <-> { associativity left precedence 140 assignment }
func <-> <T>(inout left: T, inout right: T) {
    (left, right) = (right, left)
}

func nocatch(block: () throws -> () ) {
    do {
        try block()
    } catch let e {
        print(e)
    }
}

func nocatch<T>(block: () throws -> T) -> T? {
    do {
        return try block()
    } catch let e {
        print(e)
        return nil;
    }
}