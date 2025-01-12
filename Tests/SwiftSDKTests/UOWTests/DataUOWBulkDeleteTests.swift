//
//  UOWBulkDeleteTests.swift
//
/*
 * *********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 *  ********************************************************************************************************************
 *
 *  Copyright 2020 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE: All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any. The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 *  ********************************************************************************************************************
 */

import XCTest
@testable import SwiftSDK

class DataUOWBulkDeleteTests: XCTestCase {
    
    private let backendless = Backendless.shared
    private let timeout: Double = 20.0
    private let tableName = "TestClass"
    
    // call before all tests
    override class func setUp() {
        Backendless.shared.hostUrl = BackendlessAppConfig.hostUrl
        Backendless.shared.initApp(applicationId: BackendlessAppConfig.appId, apiKey: BackendlessAppConfig.apiKey)
    }
    
    func test_01_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
            Backendless.shared.data.ofTable("TestClass").createBulk(entities: testObjects, responseHandler: { objectIds in
                let uow = UnitOfWork()
                let _ = uow.bulkDelete(tableName: self.tableName, objectIdValues: objectIds)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    uow.execute(responseHandler: { uowResult in
                        XCTAssertNil(uowResult.error)
                        XCTAssertTrue(uowResult.isSuccess)
                        XCTAssertNotNil(uowResult.results)
                        expectation.fulfill()
                    }, errorHandler: {  fault in
                        XCTFail("\(fault.code): \(fault.message!)")
                    })
                })
            }, errorHandler: { fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_02_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").createBulk(entities: testObjects, responseHandler: { objectIds in
            var objectsToDelete = [[String : Any]]()
            for objectId in objectIds {
                objectsToDelete.append(["objectId": objectId])
            }
            let uow = UnitOfWork()
            let _ = uow.bulkDelete(tableName: self.tableName, objectsToDelete: objectsToDelete)
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_03_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").createBulk(entities: testObjects, responseHandler: { objectIds in
            var objectsToDelete = [TestClass]()
            for objectId in objectIds {
                let objectToDelete = TestClass()
                objectToDelete.objectId = objectId
                objectsToDelete.append(objectToDelete)
            }
            let uow = UnitOfWork()
            let _ = uow.bulkDelete(objectsToDelete: objectsToDelete)
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_04_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        let testObjects = [["name": "Bob", "age": 25], ["name": "Ann", "age": 45], ["name": "Jack", "age": 26]]
        Backendless.shared.data.ofTable("TestClass").createBulk(entities: testObjects, responseHandler: { objectIds in
            let uow = UnitOfWork()
            let _ = uow.bulkDelete(tableName: self.tableName, whereClause: "age>25")
            uow.execute(responseHandler: { uowResult in
                XCTAssertNil(uowResult.error)
                XCTAssertTrue(uowResult.isSuccess)
                XCTAssertNotNil(uowResult.results)
                expectation.fulfill()
            }, errorHandler: {  fault in
                XCTFail("\(fault.code): \(fault.message!)")
            })
        }, errorHandler: { fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_05_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        let uow = UnitOfWork()
        
        let objectToSave1 = TestClass()
        objectToSave1.name = "Bob"
        objectToSave1.age = 25
        
        let objectToSave2 = TestClass()
        objectToSave2.name = "Ann"
        objectToSave2.age = 45
        
        let objectToSave3 = TestClass()
        objectToSave3.name = "Jack"
        objectToSave3.age = 26
        
        let objectsToSave = [objectToSave1, objectToSave2, objectToSave3]
        let bulkCreateResult = uow.bulkCreate(objectsToSave: objectsToSave)
        let _ = uow.bulkDelete(result: bulkCreateResult)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_06_bulkDelete() {
        let expectation = self.expectation(description: "PASSED: uow.bulkDelete")
        let uow = UnitOfWork()
        let findResult = uow.find(tableName: self.tableName, queryBuilder: nil)
        let _ = uow.bulkDelete(result: findResult)
        uow.execute(responseHandler: { uowResult in
            XCTAssertNil(uowResult.error)
            XCTAssertTrue(uowResult.isSuccess)
            XCTAssertNotNil(uowResult.results)
            expectation.fulfill()
        }, errorHandler: {  fault in
            XCTFail("\(fault.code): \(fault.message!)")
        })
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
