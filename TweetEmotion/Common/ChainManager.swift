//
//  ChainManager.swift
//  TweetEmotion
//
//  Created by Ricardo Carvalho on 20/12/18.
//  Copyright © 2018 Ricardo Carvalho. All rights reserved.
//

import Foundation

class ChainManager<Element, Parameter> {
    private let elements: [Element]
    private var chainedElements = [Element]()
    private var currentElement: Element?
    private var onStart: (Element, Parameter) -> Void
    private var onStop: (Element) -> Void
    
    var isRunning: Bool { return currentElement != nil }
    
    init(with elements: [Element], onEachStart: @escaping (Element, Parameter) -> Void, onStopCurrent: @escaping (Element) -> Void) {
        self.elements = elements
        onStart = onEachStart
        onStop = onStopCurrent
    }
    
    func begin(with param: Parameter) {
        stop()
        chainedElements.append(contentsOf: elements)
        if !startNext(with: param) {
            stop()
        }
    }
    
    func startNext(with param: Parameter) -> Bool {
        guard !chainedElements.isEmpty else {
            currentElement = nil
            return false
        }
        let current = chainedElements.removeFirst()
        currentElement = current
        onStart(current, param)
        return true
    }
    
    func stop() {
        if let current = currentElement {
            onStop(current)
        }
        currentElement = nil
        chainedElements.removeAll()
    }
}
