import XCTest
@testable import Network
import ReactiveNetwork
import Moya

final class NetworkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        NetworkConfigure.shared.target = TargetConfigure.shared
        
        let except = expectation(description: "Github.zen did finished.")
        
        Github.userRepos.request.retry(when: { (error) -> Bool in
            if case .moyaError(let moyaError) = error, case .statusCode(let response) = moyaError {
                return response.statusCode != 200
            }
            return false
        }, times: 3).on(value: { value in
            print(value)
            except.fulfill()
        }).start()
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
