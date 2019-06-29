//
//  EnhanceWrapperTests.swift
//  EnhanceWrapperTests
//
//  Created by Kostiantyn Gorbunov on 29/06/2019.
//  Copyright © 2019 Kostiantyn Gorbunov. All rights reserved.
//

import XCTest
@testable import EnhanceWrapper

class EnhanceWrapperTests: XCTestCase {

    func testEnhancerBase() {
        let enhancer = Enhancer()
        let input = "12345123451234512345123451234512345\0"
        do {
            let result = try enhancer.execute(withInputString: input)
            XCTAssertEqual(result, "54321543215432154321543215432154321")
        } catch {
            XCTFail("no error expected")
        }
    }
    
    func testEnhancerEmpty() {
        let enhancer = Enhancer()
        let input = "\0"
        do {
            let result = try enhancer.execute(withInputString: input)
            XCTAssertEqual(result, "")
        } catch {
            XCTFail("no error expected")
        }
    }
    
    func testEnhancerASCII() {
        let enhancer = Enhancer()
        let input = "abc12345123451234512345123451234512345\0"
        do {
            let result = try enhancer.execute(withInputString: input)
            XCTAssertEqual(result, "54321543215432154321543215432154321cba")
        } catch {
            XCTFail("no error expected")
        }
    }
    
    func testEnhancerErrorOne() {
        let enhancer = Enhancer()
        let input = "12345123451234512345123451234512345"
        do {
            let _ = try enhancer.execute(withInputString: input)
            XCTFail("error expected")
        } catch {
            let errorCode = (error as NSError).code
            XCTAssertEqual(errorCode, 1, "no null-character on the end")
        }
    }
    
    func testEnhancerErrorTwo() {
        let enhancer = Enhancer()
        let input = ""
        do {
            let _ = try enhancer.execute(withInputString: input)
            XCTFail("error expected")
        } catch {
            let errorCode = (error as NSError).code
            XCTAssertEqual(errorCode, 1, "no null-character on the end")
        }
    }
    
    func testEnhancerNonASCII() {
        let enhancer = Enhancer()
        let input = "abcЯ12345123451234512345123451234512345\0"
        do {
            let _ = try enhancer.execute(withInputString: input)
            XCTFail("error expected")
        } catch {
            let errorCode = (error as NSError).code
            XCTAssertEqual(errorCode, 2, "non ACSII character in the input string")
        }
    }

}
