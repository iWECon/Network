import XCTest
@testable import Network
@testable import RxNetwork
import RxSwift
import RxMoya

final class RxNetworkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        NetworkConfigure.shared.target = TargetConfigure.shared
        
        let except = expectation(description: "api.zen is complete.")
        
        var disposeBag: DisposeBag! = DisposeBag()
        
        var result: String? = nil
        Github.zen.request.response.mapString().subscribe { (value) in
            result = value
            except.fulfill()
        } onError: { (_) in
            except.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        disposeBag = nil
        
        XCTAssertNotNil(result)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
