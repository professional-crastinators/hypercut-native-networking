import XCTest
import HypercutFoundation
@testable import HypercutNetworking

final class HypercutNetworkingTests: XCTestCase {
  
  let network = NetworkingService(baseURL: "http://128.61.11.60:5000")
   
  func testCut() throws {
    let task = expectation(description: "cut")
    
    let cancellable = CutAudioRequest(FileID("1"), debug: true)
      .publisher(for: network.baseURL)
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          fatalError(error.localizedDescription)
        }
        print("completion")
        task.fulfill()
      } receiveValue: { value in
        print(value)
        task.fulfill()
      }

    waitForExpectations(timeout: 5) { _ in
      cancellable.cancel()
      XCTFail()
    }
    
    cancellable.cancel()
  }
}
