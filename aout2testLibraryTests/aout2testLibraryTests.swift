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
    
    func test() {
        let logger = SPYLogger()
        let analyzer = LogAnalyzer(logger: logger)
        analyzer.minNameLength = 6
        analyzer.analyze("a.txt")
        XCTAssertTrue(
            logger
                .check(method: All<SPYLogger.LogError>(string: "too short"),
                       predicate: P<SPYLogger.LogError>(vaildater: { all in
                    return all.string.contains("too short")
                })))
        
    }
}

class SPYLogger: ILogger, TestSpy {
    
    enum LogError {}
    typealias Method = All<LogError>
    var callstack: CallstackContainer<Method> = CallstackContainer()
    override func LogError(message: String) {
        callstack.record(All<LogError>(string: message))
    }
}

struct All<Tag>:Equatable {
    internal init( i: Int? = nil, string: String? = nil) {
        self.i = i
        self.string = string
    }
    
    
    var i: Int!
    var string: String!
}

struct P<Tag>:CallstackPredicate {
    
    typealias Method = All<Tag>
    
    let vaildater:(Method) -> Bool
    
    func check(method: All<Tag>, against callstack: [All<Tag>]) -> Bool {
        let r = callstack.first(where: vaildater) != nil
        return r
    }
    
    func description(forMethod method: All<Tag>) -> String {
        ""
    }
}
