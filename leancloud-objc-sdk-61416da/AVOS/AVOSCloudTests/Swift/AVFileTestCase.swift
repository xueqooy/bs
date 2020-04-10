//
//  AVFile_TestCase.swift
//  AVOS
//
//  Created by zapcannon87 on 22/01/2018.
//  Copyright © 2018 LeanCloud Inc. All rights reserved.
//

import XCTest

class AVFile_TestCase: LCTestBase {
    
    let remoteURL: URL = URL(string: "https://lc-nq0awk3l.cn-n1.lcfile.com/yQpOeKBh4V4eJB1xMaRjLgD.png")!
    
    lazy var smallDataTuple: (data: Data, name: String) = {
        
        let filePath: String = Bundle(for: type(of: self)).path(forResource: "alpacino", ofType: "jpg")!
        
        let url: URL = URL.init(fileURLWithPath: filePath)
        
        let data: Data = try! Data.init(contentsOf: url)
        
        return (data, "image.jpg")
    }()
    
    lazy var bigDataTuple: (data: Data, name: String) = {
        
        let filePath: String = Bundle(for: type(of: self)).path(forResource: "_10_MB_", ofType: "png")!
        
        let url: URL = URL.init(fileURLWithPath: filePath)
        
        let data: Data = try! Data.init(contentsOf: url)
        
        return (data, "image.png")
    }()
    
    func testc_upload_remote_url() {
        
        if self.isServerTesting { return }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let remoteURL: URL = self.remoteURL
            let file: AVFile = AVFile(remoteURL: remoteURL)
            
            semaphore.increment()
            
            file.upload(with: [], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                XCTAssertEqual(file.url(), remoteURL.absoluteString)
                XCTAssertNotNil(file.createdAt)
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let remoteURL: URL = self.remoteURL
            let file: AVFile = AVFile(remoteURL: remoteURL)
            var hasProgress: Bool = false
            
            semaphore.increment()
            
            file.upload(with: [], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(number >= 0 && number <= 100)
                hasProgress = true
                
            }, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                XCTAssertEqual(file.url(), remoteURL.absoluteString)
                XCTAssertTrue(hasProgress)
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
    }
    
    func testc_upload_data() {
        
        if self.isServerTesting { return }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let uploadDataTuple: (data: Data, name: String) = self.smallDataTuple
            let file: AVFile = AVFile(data: uploadDataTuple.data, name: uploadDataTuple.name)
            
            semaphore.increment()
            
            file.upload(with: [], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                XCTAssertNotNil(file.createdAt)
                
                guard let cachedPath: String = file.persistentCachePath() else {
                    XCTFail()
                    return
                }
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploadDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let uploaDataTuple: (data: Data, name: String) = self.bigDataTuple
            let file: AVFile = AVFile(data: uploaDataTuple.data, name: uploaDataTuple.name)
            var hasProgress = false
            
            semaphore.increment()
            
            file.upload(with: [], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(number >= 0 && number <= 100)
                hasProgress = true
                
            }, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                XCTAssertTrue(hasProgress)
                
                guard let cachedPath: String = file.persistentCachePath() else {
                    XCTFail()
                    return
                }
                
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploaDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let uploaDataTuple: (data: Data, name: String)  = self.smallDataTuple
            let file: AVFile = AVFile(data: uploaDataTuple.data, name: uploaDataTuple.name)
            
            semaphore.increment()
            
            file.upload(with: [.ignoringCachingData], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                
                guard let cachedPath: String = file.persistentCachePath() else {
                    XCTFail()
                    return
                }
                XCTAssertFalse(FileManager.default.fileExists(atPath: cachedPath))
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
    }
    
    func testc_upload_file_path() {
        
        if self.isServerTesting { return }
        
        let uploadDataTuple: (data: Data, name: String) = self.bigDataTuple
        let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        try! FileManager.default.createDirectory(
            at: documentsDirectory,
            withIntermediateDirectories: true,
            attributes: nil)
        let filePath: URL = documentsDirectory.appendingPathComponent(uploadDataTuple.name, isDirectory: false)
        do {
            try uploadDataTuple.data.write(to: filePath, options: [.atomic])
        } catch let err {
            XCTFail("\(err)")
        }
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            XCTFail()
            return
        }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            var file: AVFile! = nil
            do {
                file = try AVFile(localPath: filePath.path)
            } catch let err {
                XCTFail("\(err)")
            }
            guard file != nil else {
                XCTFail()
                return
            }
            
            semaphore.increment()
            
            file.upload(with: [], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                XCTAssertNotNil(file.createdAt)
                
                guard let cachedPath: String = file.persistentCachePath() else {
                    XCTFail()
                    return
                }
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploadDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            var file: AVFile! = nil
            do {
                file = try AVFile(localPath: filePath.path)
            } catch let err {
                XCTFail("\(err)")
            }
            guard file != nil else {
                XCTFail()
                return
            }
            var hasProgress: Bool = false
            
            semaphore.increment()
            
            file.upload(with: [], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(number >= 0 && number <= 100)
                hasProgress = true
                
            }, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                XCTAssertTrue(hasProgress)
                
                guard let cachedPath: String = file.persistentCachePath() else {
                    XCTFail()
                    return
                }
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploadDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            var file: AVFile! = nil
            do {
                file = try AVFile(localPath: filePath.path)
            } catch let err {
                XCTFail("\(err)")
            }
            guard file != nil else {
                XCTFail()
                return
            }
            
            semaphore.increment()
            
            file.upload(with: [.ignoringCachingData], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                
                guard let cachedPath: String = file.persistentCachePath() else {
                    XCTFail()
                    return
                }
                XCTAssertFalse(FileManager.default.fileExists(atPath: cachedPath))
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
    }
    
    func testc_download_file() {
        
        if self.isServerTesting { return }
        
        var downloadFile: AVFile!
        let uploadDataTuple: (data: Data, name: String) = self.bigDataTuple
        let removeItemAtPath: (String) -> Bool = { (path: String) in
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    return true
                } catch let err {
                    XCTFail("\(err)")
                    return false
                }
            } else {
                return true
            }
        }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let file: AVFile = AVFile(data: uploadDataTuple.data, name: uploadDataTuple.name)
            
            semaphore.increment()
            
            file.upload(with: [.ignoringCachingData], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                
                guard let cachedPath: String = file.persistentCachePath() else {
                    XCTFail()
                    return
                }
                
                if removeItemAtPath(cachedPath) {
                    downloadFile = file
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        guard downloadFile != nil, let cachedPath: String = downloadFile.persistentCachePath() else {
            XCTFail()
            return
        }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let _ = removeItemAtPath(cachedPath)
            
            semaphore.increment()
            
            downloadFile.download(with: [], progress: nil, completionHandler: { (filePath: URL?, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertEqual(filePath?.path, cachedPath)
                XCTAssertNil(error)
                
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploadDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let _ = removeItemAtPath(cachedPath)
            var hasProgress: Bool = false
            
            semaphore.increment()
            
            downloadFile.download(with: [], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(number >= 0 && number <= 100)
                hasProgress = true
                
            }, completionHandler: { (filePath: URL?, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertEqual(filePath?.path, cachedPath)
                XCTAssertNil(error)
                XCTAssertTrue(hasProgress)
                
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploadDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            var hasProgress: Bool = false
            
            semaphore.increment()
            
            downloadFile.download(with: [], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(number == 100)
                hasProgress = true
                
            }, completionHandler: { (filePath: URL?, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertEqual(filePath?.path, cachedPath)
                XCTAssertNil(error)
                XCTAssertTrue(hasProgress)
                
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploadDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            var not_100_progress_count: Int = 0
            
            semaphore.increment()
            
            downloadFile.download(with: [.ignoringCachedData], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                
                if number >= 0 && number != 100 {
                    not_100_progress_count += 1
                }
                
            }, completionHandler: { (filePath: URL?, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertEqual(filePath?.path, cachedPath)
                XCTAssertNil(error)
                XCTAssertTrue(not_100_progress_count > 0)
                
                guard FileManager.default.fileExists(atPath: cachedPath) else {
                    XCTFail()
                    return
                }
                do {
                    let data: Data = try Data.init(contentsOf: URL.init(fileURLWithPath: cachedPath))
                    XCTAssertEqual(uploadDataTuple.data.count, data.count)
                } catch let err {
                    XCTFail("\(err)")
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        downloadFile.clearPersistentCache()
        XCTAssertFalse(FileManager.default.fileExists(atPath: cachedPath))
        AVFile.clearAllPersistentCache()
        XCTAssertFalse(FileManager.default.fileExists(atPath: URL.init(fileURLWithPath: cachedPath).deletingLastPathComponent().path))
    }
    
    func testc_download_external_url() {
        
        if self.isServerTesting { return }
        
        let removeItemAtPath: (String) -> Bool = { (path: String) in
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    return true
                } catch let err {
                    XCTFail("\(err)")
                    return false
                }
            } else {
                return true
            }
        }
        
        var externalURLFile: AVFile!
        
        let remoteURL: URL = self.remoteURL
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let file: AVFile = AVFile(remoteURL: remoteURL)
            
            semaphore.increment()
            
            file.upload(with: [], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                XCTAssertEqual(file.url(), remoteURL.absoluteString)
                
                if succeeded {
                    externalURLFile = file
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        guard externalURLFile != nil, let cachedPath: String = externalURLFile.persistentCachePath() else {
            XCTFail()
            return
        }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let _ = removeItemAtPath(cachedPath)
            
            semaphore.increment()
            
            externalURLFile.download(with: [], progress: nil, completionHandler: { (filePath: URL?, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertNotNil(filePath)
                XCTAssertNil(error)
                
                if let path: String = filePath?.path {
                    XCTAssertTrue(FileManager.default.fileExists(atPath: path))
                } else {
                    XCTFail()
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        externalURLFile.clearPersistentCache()
        XCTAssertFalse(FileManager.default.fileExists(atPath: cachedPath))
        AVFile.clearAllPersistentCache()
        XCTAssertFalse(FileManager.default.fileExists(atPath: URL.init(fileURLWithPath: cachedPath).deletingLastPathComponent().path))
    }
    
    func testc_cancel_task() {
        
        if self.isServerTesting { return }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let uploadDataTuple: (data: Data, name: String) = self.bigDataTuple
            let file: AVFile = AVFile(data: uploadDataTuple.data, name: uploadDataTuple.name)
            var canceled: Bool = false
            
            semaphore.increment()
            
            file.upload(with: [], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                file.cancelUploading()
                canceled = true
                
            }, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertFalse(succeeded)
                XCTAssertNotNil(error)
                XCTAssertTrue(canceled)
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        var downloadCancelFile: AVFile!
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            let uploadDataTuple: (data: Data, name: String) = self.bigDataTuple
            let file: AVFile = AVFile(data: uploadDataTuple.data, name: uploadDataTuple.name)
            
            semaphore.increment()
            
            file.upload(with: [.ignoringCachingData], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
                XCTAssertNotNil(file.objectId())
                XCTAssertNotNil(file.url())
                
                if succeeded {
                    downloadCancelFile = file
                }
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
        
        guard downloadCancelFile != nil else {
            XCTFail()
            return
        }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            var canceled: Bool = false
            
            semaphore.increment()
            
            downloadCancelFile.download(with: [.ignoringCachedData], progress: { (number: Int) in
                
                XCTAssertTrue(Thread.isMainThread)
                downloadCancelFile.cancelDownloading()
                canceled = true
                
            }, completionHandler: { (filePath: URL?, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertNil(filePath)
                XCTAssertNotNil(error)
                XCTAssertTrue(canceled)
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
    }
    
    func testc_delete_file_object() {
        
        if self.isServerTesting { return }
        
        let uploadedFile = { () -> AVFile? in
            
            let remoteURL: URL = self.remoteURL
            let file: AVFile = AVFile(remoteURL: remoteURL)
            
            RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
                
                semaphore.increment()
                
                file.upload(with: [], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                    
                    semaphore.decrement()
                    XCTAssertTrue(Thread.isMainThread)
                    
                    XCTAssertTrue(succeeded)
                    XCTAssertNil(error)
                    XCTAssertNotNil(file.objectId())
                    XCTAssertNotNil(file.url())
                    XCTAssertEqual(file.url(), remoteURL.absoluteString)
                })
                
            }, failure: {
                
                XCTFail("timeout")
            })
            
            return file.objectId() != nil ? file : nil
        }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            var array: [AVFile] = []
            for _ in 0..<3 {
                guard let file: AVFile = uploadedFile() else {
                    continue
                }
                array.append(file)
            }
            
            semaphore.increment()
            
            AVFile.delete(with: array, completionHandler: { (succeeded: Bool, error: Error?) in
                
                semaphore.decrement()
                XCTAssertTrue(Thread.isMainThread)
                
                XCTAssertTrue(succeeded)
                XCTAssertNil(error)
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
    }
    
    func testc_get_file_object() {
        
        if self.isServerTesting { return }
        
        let uploadedFile = { () -> AVFile? in
            
            let remoteURL: URL = self.remoteURL
            let file: AVFile = AVFile(remoteURL: remoteURL)
            
            RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
                
                semaphore.increment()
                
                file.upload(with: [], progress: nil, completionHandler: { (succeeded: Bool, error: Error?) in
                    
                    semaphore.decrement()
                    XCTAssertTrue(Thread.isMainThread)
                    
                    XCTAssertTrue(succeeded)
                    XCTAssertNil(error)
                    XCTAssertNotNil(file.objectId())
                    XCTAssertNotNil(file.url())
                    XCTAssertEqual(file.url(), remoteURL.absoluteString)
                })
                
            }, failure: {
                
                XCTFail("timeout")
            })
            
            return file.objectId() != nil ? file : nil
        }
        
        guard let objectId: String = uploadedFile()?.objectId() else {
            XCTFail()
            return
        }
        
        RunLoopSemaphore.wait(async: { (semaphore: RunLoopSemaphore) in
            
            semaphore.increment()
            
            AVFile.getWithObjectId(objectId, completionHandler: { (file: AVFile?, error: Error?) in
                
                semaphore.decrement()
                
                XCTAssertTrue(Thread.isMainThread)
    
                XCTAssertNotNil(file)
                XCTAssertEqual(file?.objectId(), objectId)
                XCTAssertNil(error)
                XCTAssertNotNil(file?.createdAt)
                XCTAssertNotNil(file?.updatedAt)
            })
            
        }, failure: {
            
            XCTFail("timeout")
        })
    }
    
    func testc_multiple_download() {
        let uploadExp = expectation(description: "upload file")
        let file = AVFile(data: self.bigDataTuple.data, name: self.bigDataTuple.name)
        file.upload { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            uploadExp.fulfill()
        }
        wait(for: [uploadExp], timeout: 60)
        
        let downloadExp = expectation(description: "multiple download file")
        downloadExp.expectedFulfillmentCount = 5
        for i in 0..<downloadExp.expectedFulfillmentCount {
            let file = AVFile(objectId: file.objectId()! + "\(i)", url: file.url()!)
            file.download(completionHandler: { (fileURL, error) in
                XCTAssertNotNil(fileURL)
                XCTAssertNil(error)
                downloadExp.fulfill()
            })
        }
        wait(for: [downloadExp], timeout: 60)
    }
}
