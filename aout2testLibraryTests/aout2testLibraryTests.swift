//
/* 
 *		Created by 游諭 in 2020/12/27
 *		
 *		Using Swift 5.0
 *		
 *		Running on macOS 11.1
 */


import XCTest
import TestSpy

class ILogger {
    func LogError(message: String) {
        
    }
}
class LogAnalyzer {
    let logger: ILogger
    
    internal init(logger: ILogger) {
        self.logger = logger
    }
    
    var minNameLength = 10
    
    func analyze(_ filename: String) {
        if filename.count < minNameLength {
            logger.LogError(message: "Filename too short: \(filename)")
        }
    }
}

class FakeLogger: ILogger {
    var lastError: String?
    override func LogError(message: String) {
        lastError = message
    }
}

class aout2testLibraryTests: XCTestCase {

    func test_手刻假物件來進行驗證() {
        let logger = FakeLogger()
        let analyzer = LogAnalyzer(logger: logger)
        analyzer.minNameLength = 6
        analyzer.analyze("a.txt")
        
        XCTAssertTrue(logger.lastError!.contains("too short"))
    }
}
