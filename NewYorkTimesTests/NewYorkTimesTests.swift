//
//  NewYorkTimesTests.swift
//  NewYorkTimesTests
//
//  Created by Ananth Kamath on 09/06/22.
//

import XCTest
@testable import NewYorkTimes

class NewYorkTimesTests: XCTestCase {
    var sut: URLSession!
    var testSut: NewYorkTimes.NewYorkTimesViewController!
    var testSutRest: NewYorkTimes.RestAPIHelper!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
        testSut = NewYorkTimes.NewYorkTimesViewController()
        testSutRest = NewYorkTimes.RestAPIHelper.shared
    }
    
    override func tearDown() async throws {
        testSut = nil
        testSutRest = nil
        
        try await super.tearDown()
    }

    func testCheckTheDateFormatWhenValidInputDateStringIsGiven() {
        let validInputDateString = "2022-06-09"
        
        XCTAssertEqual(testSut.prettifyDateFormat(dateString: validInputDateString), "Jun 09, 2022", "The computed date string is wrong")
    }
    
    func testCheckTheDateFormatWhenInvalidInputDateStringIsGiven() {
        let invalidInputDateString = "09-06-2022"
        
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "MMM dd, yyy"
        let prettyDateString = formatter.string(from: date)

        XCTAssertEqual(testSut.prettifyDateFormat(dateString: invalidInputDateString), prettyDateString, "The computed date string is valid")
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidApiCallGetsHTTPStatusCode200() throws {
      // given
      let urlString = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=4l3b0h7CtvGG4LELYVfzjfvcKKbaAKB5"
      let url = URL(string: urlString)!
      // 1
      let promise = expectation(description: "Status code: 200")

      // when
      let dataTask = sut.dataTask(with: url) { _, response, error in
        // then
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            // 2
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      // 3
      wait(for: [promise], timeout: 5)
    }
    
    // Asynchronous test: faster fail
    func testRestAPICalls() {
        let urlString = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=4l3b0h7CtvGG4LELYVfzjfvcKKbaAKB5"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?

        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
          statusCode = (response as? HTTPURLResponse)?.statusCode
          responseError = error
          promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
