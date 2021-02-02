import XCTest
@testable import Network
@testable import ReactiveNetwork
import ReactiveSwift
import ReactiveMoya
import Alamofire

final class NetworkTests: XCTestCase {
    
    
    struct Retrier: RequestRetrierProvider {
        static let shared = Retrier()
        
        func retry(with request: Request, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//            if case .sessionTaskFailed = error.asAFError {
//                print("do not retry with: \(error.localizedDescription)")
//                completion(.retryWithDelay(3))
//            } else {
//                print("retry with response error: \(error.localizedDescription)")
//                completion(.retry)
//            }
            completion(.retry)
        }
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        NetworkConfigure.shared.target = TargetConfigure.shared
        
//        NetworkConfigure.shared.retrier = Retrier.shared
        
        let except = expectation(description: "api.zen is complete.")
        
        var result: String? = nil
//        Github.userRepos.request.retry(when: { (error) -> Bool in
//            return true
//        }, times: 3).response.mapString().on(value: { (string) in
//            result = string
//            except.fulfill()
//        }).start()
        
//        AF.request("https://www.baidu.com").validate { (request, response, data) -> DataRequest.ValidationResult in
//
//        }
        
//        Github.zen.request.response.mapString().on(value: { value in
//            result = value
//        })
        
        Github.userRepos.request.retry(upTo: 3).response.mapString().on(failed: {(moyaError) in
            print("🌈 Request error: ", moyaError.errorUserInfo)
        }, value: { (string) in
            result = string
            except.fulfill()
        }).start()
        
        waitForExpectations(timeout: 8, handler: nil)
        
        XCTAssertNotNil(result)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
