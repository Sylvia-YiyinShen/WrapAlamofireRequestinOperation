//
//  Copyright © 2019 ANZ. All rights reserved.
//
import Alamofire
import Foundation

public class NetworkService {
    private var  sessionManager: SessionManager
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionManager = SessionManager(configuration: sessionConfiguration,
                                        serverTrustPolicyManager: nil)
    }

    public func performRequest(url: URL, completionHandler: @escaping (String) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        sessionManager.request(urlRequest).responseData { (response) in
            switch response.result {
            case let .success(value):
                completionHandler(String("value:\(value)"))
                        print("thread: \(Thread.current)")
            case let .failure(error):
                completionHandler(String("value:\(error.localizedDescription)"))
                        print("thread: \(Thread.current)")
            }
        }
    }

    public func cancelAllRequest() {
        sessionManager.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }

}
