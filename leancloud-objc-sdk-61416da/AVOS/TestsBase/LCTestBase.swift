//
//  LCTestBase.swift
//  AVOS
//
//  Created by ZapCannon87 on 11/12/2017.
//  Copyright © 2017 LeanCloud Inc. All rights reserved.
//

import XCTest

class LCTestBase: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        AVOSCloud.setAllLogsEnabled(true)
        
        let env: LCTestEnvironment = LCTestEnvironment.sharedInstance()
        
        /// custom url for API
        if let APIURL: String = env.url_API {
            AVOSCloud.setServerURLString(APIURL, for: .API)
            AVOSCloud.setServerURLString(APIURL, for: .push)
            AVOSCloud.setServerURLString(APIURL, for: .statistics)
            AVOSCloud.setServerURLString(APIURL, for: .engine)
        }
        
        /// custom url for RTM router
        if let RTMRouterURL: String = env.url_RTMRouter {
            AVOSCloud.setServerURLString(RTMRouterURL, for: .RTM)
        }
        
        /// custom app id & key
        if let appId: String = env.app_ID, let appKey: String = env.app_KEY {
            AVOSCloud.setApplicationId(appId, clientKey: appKey)
        } else {
            let testApp: TestApp = .ChinaNorth
            switch testApp {
            case .ChinaNorth, .ChinaEast:
                AVOSCloud.setApplicationId(
                    testApp.appInfo.id,
                    clientKey: testApp.appInfo.key,
                    serverURLString: testApp.appInfo.serverURL)
            case .US:
                AVOSCloud.setApplicationId(
                    testApp.appInfo.id,
                    clientKey: testApp.appInfo.key)
            }
        }
    }
    
    override class func tearDown() {
        AVFile.clearAllPersistentCache()
        super.tearDown()
    }
}

extension LCTestBase {
    
    var isServerTesting: Bool {
        return LCTestEnvironment.sharedInstance().isServerTesting
    }
    
    enum TestApp {
        case ChinaNorth
        case ChinaEast
        case US
        var appInfo: (id: String, key: String, serverURL: String) {
            switch self {
            case .ChinaNorth:
                return (id: "S5vDI3IeCk1NLLiM1aFg3262-gzGzoHsz",
                        key: "7g5pPsI55piz2PRLPWK5MPz0",
                        serverURL: "https://s5vdi3ie.lc-cn-n1-shared.com")
            case .ChinaEast:
                return (id: "skhiVsqIk7NLVdtHaUiWn0No-9Nh9j0Va",
                        key: "T3TEAIcL8Ls5XGPsGz41B1bz",
                        serverURL: "https://skhivsqi.lc-cn-e1-shared.com")
            case .US:
                return (id: "eX7urCufwLd6X5mHxt7V12nL-MdYXbMMI",
                        key: "PrmzHPnRXjXezS54KryuHMG6",
                        serverURL: "")
            }
        }
    }
    
}

class RunLoopSemaphore {
    
    private var lock: NSLock = NSLock()
    var semaphoreValue: Int = 0
    
    func increment(_ number: Int = 1) {
        assert(number > 0)
        self.lock.lock()
        self.semaphoreValue += number
        self.lock.unlock()
    }
    
    func decrement(_ number: Int = 1) {
        assert(number > 0)
        self.lock.lock()
        self.semaphoreValue -= number
        self.lock.unlock()
    }
    
    private func running() -> Bool {
        return (self.semaphoreValue > 0) ? true : false
    }
    
    static func wait(timeout: TimeInterval = 30, async: (RunLoopSemaphore) -> Void, failure: (() -> Void)? = nil) {
        XCTAssertTrue(timeout >= 0)
        defer {
            XCTAssertTrue(RunLoop.current.run(mode: RunLoop.Mode.default, before: Date(timeIntervalSinceNow: 1.0)))
        }
        let semaphore: RunLoopSemaphore = RunLoopSemaphore()
        async(semaphore)
        let startTimestamp: TimeInterval = Date().timeIntervalSince1970
        while semaphore.running() {
            let date: Date = Date(timeIntervalSinceNow: 1.0)
            XCTAssertTrue(RunLoop.current.run(mode: RunLoop.Mode.default, before: date))
            if date.timeIntervalSince1970 - startTimestamp > timeout {
                failure?()
                return
            }
        }
    }
    
}
