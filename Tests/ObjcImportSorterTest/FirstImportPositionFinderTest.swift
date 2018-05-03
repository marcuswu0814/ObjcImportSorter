import XCTest
@testable import ObjcImportSorterCore

class FirstImportPositionFinderTest: XCTestCase {
    
    func test__shouldFindFirstImportPosition() {
        let testContent = TestDataFactory.generalHeader

        let sut = FirstImportPositionFinder(with: testContent)
        
        let firstPosition = sut.find()
        
        XCTAssertEqual(firstPosition, 7)
    }
    
    func test__whenFileContentNotHadImport__shuoldGotPositionNil() {
        let testContent = TestDataFactory.noAnyImportFile
        
        let sut = FirstImportPositionFinder(with: testContent)
        
        let firstPosition = sut.find()
        
        XCTAssertEqual(firstPosition, nil)
    }

}
