//
//  Backendless.swift
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

import Foundation

@objcMembers public class Backendless: NSObject {    

    public static let shared = Backendless()
    
    public var hostUrl = "https://api.backendless.com"
    public var useSharedUrlSession = false
    
    var urlSessionConfig: URLSessionConfiguration?
    var urlSession: URLSession?
    
    private var applicationId = ""
    private var apiKey = ""
    private var customDomain = ""
    
    private var headers = [String : String]()
    
    private override init() { }
    
    public func initApp(applicationId: String, apiKey: String) {
        self.applicationId = applicationId
        self.apiKey = apiKey
        self.customDomain = ""
        
        // mappings for updating objects correctly
        self.data.of(BackendlessUser.self).mapColumn(columnName: "password", toProperty: "_password")
    }
    
    public func initApp(customDomain: String) {
        self.applicationId = ""
        self.apiKey = ""
        if customDomain.starts(with: "http") {
            self.customDomain = customDomain
        }
        else {
            self.customDomain = "http://" + customDomain
        }
        // mappings for updating objects correctly
        self.data.of(BackendlessUser.self).mapColumn(columnName: "password", toProperty: "_password")
    }
    
    public func getApplicationId() -> String {
        return applicationId
    }
    
    public func getApiKey() -> String {
        return apiKey
    }
    
    public func getCustomDomain() -> String {
        return customDomain
    }
    
    public lazy var rt: RTService = {
        return self.rtService
    }()
    
    public lazy var rtService: RTService = {
        let _rtSevice = RTService()
        return _rtSevice
    }()
    
    public lazy var userService: UserService = {
        let _userSevice = UserService()
        return _userSevice
    }()
    
    public lazy var data: PersistenceService = {
        return self.persistenceService
    }()
    
    public lazy var persistenceService: PersistenceService = {
        let _persistenceSevice = PersistenceService()
        return _persistenceSevice
    }()
    
    public lazy var messaging: MessagingService = {
        return self.messagingService
    }()
    
    public lazy var messagingService: MessagingService = {
        let _messagingSevice = MessagingService()
        return _messagingSevice
    }()
    
    public lazy var file: FileService = {
        return self.fileService
    }()
    
    public lazy var fileService: FileService = {
        let _fileSevice = FileService()
        return _fileSevice
    }()
    
    public lazy var logging: Logging = {
        let _logging = Logging()
        return _logging
    }()
    
    public lazy var cache: CacheService = {
        return self.cacheService
    }()
    
    public lazy var cacheService: CacheService = {
        let _cacheSevice = CacheService()
        return _cacheSevice
    }()
    
    public lazy var counters: AtomicCounters = {
        let _atomicCounters = AtomicCounters()
        return _atomicCounters
    }()
    
    public lazy var customService: CustomService = {
        let _customService = CustomService()
        return _customService
    }()
    
    public lazy var events: Events = {
        let _events = Events()
        return _events
    }()
    
    public func sharedObject(name: String) -> SharedObject {
        return SharedObject(name: name)
    }
    
    public func getHeaders() -> [String : String] {
        return headers
    }
    
    public func setHeader(key: String, value: String) {
        if key == "user-token" {
            UserDefaultsHelper.shared.saveUserToken(value)
            Backendless.shared.userService.setUserToken(value: value)
        }
        headers[key] = value
    }
    
    public func removeHeader(key: String) {
        if key == "user-token" {
            UserDefaultsHelper.shared.removeUserToken()
        }
        headers.removeValue(forKey: key)
    }
    
    public func setupURLSessionConfig(_ config: URLSessionConfiguration) {
        self.urlSessionConfig = config
    }
    
    public func setupURLSession(_ session: URLSession) {
        self.urlSession = session
    }
}
