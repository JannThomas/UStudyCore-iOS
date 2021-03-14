import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(UStudyCore_iOSTests.allTests),
    ]
}
#endif
