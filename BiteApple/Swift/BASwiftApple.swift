//
//  BASwiftApple.swift
//  BiteApple
//
//  Created by jayhuan on 2020/12/15.
//

import Foundation

@objc public class BASwiftApple: NSObject {
    @objc func functionA(name: String, _ age: Int) -> Void {
        print(name)
    }
    
    @objc func functionB(name: String, age: Int) -> Void {
        NSLog("%@-%d", name, age)
        functionC(name: name, age: age)
    }
    
    func functionC(name: String, age: Int) -> Void {
        NSLog("private func functionC %@", name)
    }
}
