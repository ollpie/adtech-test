//
//  SOMStructs.swift
//  SOMCore
//
//  Created by Julian Brehm on 17.01.19.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

/** Structs used by all SOM SDKs. */
public class SOMPriceBucket { // A price from a network can be mapped into a price bucket
    public init(step: Int, minimum: Int, maximum: Int) {
        self.step = step
        self.minimum = minimum
        self.maximum = maximum
    }
    public init(step: Int, maximum: Int) {
        self.step = step
        self.maximum = maximum
    }
    public init(minimum: Int) {
        self.minimum = minimum
    }
    public init(step: Int) {
        self.step = step
    }
    public var step: Int = Int.max
    public var minimum: Int = 0
    public var maximum: Int = Int.max
    public func contains(_ price: Int) -> Bool {
        return price >= self.minimum && price < self.maximum
    }
    public func pricePoint(_ price: Int) -> Int {
        let difference = price - self.minimum
        let remainder = difference % self.step
        return price - remainder
    }
}
