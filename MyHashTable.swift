//
//  MyHashTable.swift
//  NiceTry-Swift
//
//  Created by iceberg on 03/09/2018.
//  Copyright © 2018 iceberg. All rights reserved.
//

import Foundation

public struct MyHashTable<Key: Hashable, Value> {
    fileprivate typealias Element = (key: Key, value: Value)
    fileprivate typealias Bucket = [Element]
    fileprivate var buckets: [Bucket]

    fileprivate(set) public var count = 0
    
    public var isEmpty: Bool {return count == 0}
    
    public init(capaticy: Int) {
        assert(capaticy > 0)
        buckets = Array<Bucket>(repeatElement([], count: capaticy))
    }
    
    fileprivate func index(forKey key: Key) -> Int {
        return abs(key.hashValue) % buckets.count
    }
    

    public subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        
        set {
            if let value = newValue {
                updateValue(newValue: value, forKey: key)
            }else {
                removeValue(forKey: key)
            }
        }
    }
}

extension MyHashTable {
    
    fileprivate func value(forKey key: Key) -> Value? {
        let idx = self.index(forKey: key)
        for ele in buckets[idx] {
            if ele.key == key {
                return ele.value
            }
        }

        return nil
    }
    
    fileprivate mutating func updateValue(newValue: Value, forKey key: Key) -> Value? {
        let idx = self.index(forKey: key)
        
        //Why use "enumerated"? Answer : http://swift.gg/2017/05/05/you-probably-don't-want-enumerated/
        for (i, ele) in self.buckets[idx].enumerated() {
            if ele.key == key {
                let oldValue = ele.value
                self.buckets[idx][i].value = newValue
                return oldValue
            }
        }
        
        self.buckets[idx].append((key: key, value: newValue))
        self.count += 1
        return nil
    }
    
    fileprivate mutating func removeValue(forKey key: Key) -> Value? {
        let idx = self.index(forKey: key)
        
        for (i, ele) in self.buckets[idx].enumerated() {
            if ele.key == key {
                let oldValue = ele.value
                self.buckets[idx].remove(at: i)
                self.count -= 1
                return oldValue
            }
        }
        
        return nil
    }
}

var hashTable1 = MyHashTable<String, Any>(capaticy: 10)
hashTable1["nice"] = "iceberg"
print(hashTable1["nice1"] ?? "sss")

