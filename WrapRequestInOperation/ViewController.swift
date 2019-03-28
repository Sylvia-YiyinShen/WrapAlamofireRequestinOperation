//
//  ViewController.swift
//  WrapRequestInOperation
//
//  Created by Zhihui Sun on 28/3/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var requestQueue: OperationQueue = OperationQueue()
    private var resultString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startOperations()
    }

    private func startOperations() {
        var requests: [Operation] = []
        
        let requestOperationA = RequestOperation() {[weak self] (result) in
            self?.resultString.append("A")
        }
        let requestOperationB = RequestOperation() {[weak self] (result) in
            self?.resultString.append("B")
        }
        let requestOperationC = RequestOperation() {[weak self] (result) in
            self?.resultString.append("C")
        }
        
        requests.append(requestOperationA)
        requests.append(requestOperationB)
        requests.append(requestOperationC)
        requestOperationA.addDependency(requestOperationC)
        requestOperationB.addDependency(requestOperationC)
    
        let completionOperation = BlockOperation(block: { [weak self] in
                print("completionBlock: \(self?.resultString ?? "")")
            }
        )
        completionOperation.addDependency(requestOperationA)
        completionOperation.addDependency(requestOperationB)
        requests.append(completionOperation)
        
        requestQueue.addOperations(requests, waitUntilFinished: false)
    }
}

