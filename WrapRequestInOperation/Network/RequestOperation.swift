//
//  RequestOperation.swift
//  WrapRequestInOperation
//
//  Created by Zhihui Sun on 28/3/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import Foundation

public class RequestOperation: Operation {
    private var service: NetworkService = NetworkService()
    private var success: (String) -> Void
    private var _executing = true
    private var _finished = false
    
    public override var isExecuting: Bool {
        return _executing
    }
    
    public override var isFinished: Bool {
        return _finished
    }
    
    init(success: @escaping (String) -> Void) {
        self.success = success
        self._executing = false
        self._finished = false
        super.init()
    }
    
    public override func start() {
        if isCancelled {
            willChangeValue(forKey: "isFinished")
            _finished = true
            didChangeValue(forKey: "isFinished")
        }
        
        willChangeValue(forKey: "isExecuting")
        main()
        _executing = true
        didChangeValue(forKey: "isExecuting")
    }
    
    private func completedOperation() {
        willChangeValue(forKey: "isFinished")
        willChangeValue(forKey: "isExecuting")
        _finished = true
        _executing = false
        didChangeValue(forKey: "isFinished")
        didChangeValue(forKey: "isExecuting")
    }
    
    override public func main() {
        guard !isCancelled else {
            return
        }
        let url = URL(string: "http://api.github.com/users/hadley/orgs")!
        service.performRequest(url: url) {[weak self] (result) in
            self?.success(result)
            self?.completedOperation()
        }
    }
    
    override public func cancel() {
        guard !isCancelled else {
            return
        }
        service.cancelAllRequest()
        super.cancel()
    }
}
