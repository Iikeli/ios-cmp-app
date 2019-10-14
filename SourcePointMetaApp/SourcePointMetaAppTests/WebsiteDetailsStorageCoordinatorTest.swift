//
//  WebsiteDetailsStorageCoordinatorTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/29/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import XCTest
import CoreData
@testable import SourcePointMetaApp

class WebsiteDetailsStorageCoordinatorTest: XCTestCase {
    
    var websiteDetailsStorageCoordinator = WebsiteDetailsStorageCoordinator()
    // Will add all the targeting params to this array
    var targetingParamsArray = [TargetingParamModel]()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // This method is used to test whether all site data can be fetched from database or not.
    func testFetchAllWebsites() {
        websiteDetailsStorageCoordinator.fetchAllWebsites(executionCompletionHandler: { (_allWebsites) in
            XCTAssertNotNil(_allWebsites, "unable to fetch the site data")
        })
    }
    
    // This method is used to test whether site data can be fetched from database or not.
    func testfetchSiteData() {
        websiteDetailsStorageCoordinator.managedObjectID(completionHandler: {(managedObjectID) in
            if (managedObjectID.entity.name != nil) {
                self.websiteDetailsStorageCoordinator.fetch(website: managedObjectID, completionHandler: { ( siteDataDetailsModel) in
                    XCTAssertNotNil(siteDataDetailsModel, "unable to find out stored data")
                })
            }
        })
    }
    
    // This method is used to test whether managed object ID can be fetched from database or not.
    func testfetchManagedObjectID() {
        websiteDetailsStorageCoordinator.managedObjectID(completionHandler: {(managedObjectID) in
            XCTAssertNotNil(managedObjectID, "unable to find out stored managedObjectID data")
        })
    }
    
    
    // This test method is used to test whether the website data added or not to database.
    func testAddWebsite() {
        let websiteDataModel = WebsiteDetailsModel(websiteName: "mobile.demo", accountID: 22, creationTimestamp: NSDate(), isStaging: false)
        let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "false")
        targetingParamsArray.append(targetingParamModel)
        websiteDetailsStorageCoordinator.add(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray, completionHandler: { (websiteManagedObjectID, siteStoredStatus) in
            
            if siteStoredStatus {
                XCTAssert(true, "successfully stored data to database")
            } else {
                XCTAssert(false, "failed to store data to database")
            }
        })
    }
    
    // This test method is used to test whether the website data updated or not to database.
    func testUpdateSiteData() {
        let websiteDataModel = WebsiteDetailsModel(websiteName: "mobile.demo", accountID: 22, creationTimestamp: NSDate(), isStaging: false)
        let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "false")
        targetingParamsArray.append(targetingParamModel)
        websiteDetailsStorageCoordinator.add(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray, completionHandler: { (websiteManagedObjectID, siteStoredStatus) in
            if let managedObjectID = websiteManagedObjectID {
                self.targetingParamsArray.removeAll()
                let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "true")
                self.targetingParamsArray.append(targetingParamModel)
                self.websiteDetailsStorageCoordinator.update(websiteDetails: websiteDataModel, targetingParams: self.targetingParamsArray, whereManagedObjectID: managedObjectID, completionHandler: {(managedObject, updateStatus) in
                    if updateStatus {
                        XCTAssert(true, "successfully updated the site data to database")
                    } else {
                        XCTAssert(false, "failed to update the site data to database")
                    }
                })
            }
        })
    }
    
    // This test method is used to test whether the website data deleted from database or not.
    func testDeleteSiteData() {
        websiteDetailsStorageCoordinator.delete(website: NSManagedObject.init(), completionHandler: {(deleteStatus) in
            if deleteStatus {
                XCTAssert(true, "successfully deleted the site data from database")
            } else {
                XCTAssert(false, "failed to delete the site data from database")
            }
        })
    }
    
    // This method is used to test whether the site data already exist in database or not
    func testcheckExitanceOfData() {
        let websiteDataModel = WebsiteDetailsModel(websiteName: "mobile.demo", accountID: 22, creationTimestamp: NSDate(), isStaging: false)
        let targetingParamModel = TargetingParamModel(targetingParamKey: "MyPrivacyManager", targetingParamValue: "false")
        targetingParamsArray.append(targetingParamModel)
        websiteDetailsStorageCoordinator.add(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray, completionHandler: { (websiteManagedObjectID, siteStoredStatus) in
            
            self.websiteDetailsStorageCoordinator.checkExitanceOfData(websiteDetails: websiteDataModel, targetingParams: self.targetingParamsArray , completionHandler: { (isStored) in
                print(isStored)
                if isStored {
                    XCTAssert(true, "Site data present in database")
                } else {
                    XCTAssert(false, "Site data is not present in database")
                }
            })
        })
    }
}
