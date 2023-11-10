//
//  AsyncOperation.swift
//  SugarBoxApp
//
//  Created by Kaushal Chaudhary on 09/11/23.
//

import Foundation
class AsyncOperation: Operation {
    static let defaultOperationQueue = OperationQueue()
    private var work: (@convention(block) (AsyncOperation) -> Void)?
    override init() {
        self.work = nil
        super.init()
    }
    convenience init(work: @escaping @convention(block) (AsyncOperation) -> Void ) {
        self.init()
        self.work = work
    }
    
    
    private let lockQueue = DispatchQueue(label: "com.kushal.asyncoperation", attributes: .concurrent)
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        isFinished = false
        isExecuting = true
        main()
    }
    
    override func main() {
        work?(self)
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}
