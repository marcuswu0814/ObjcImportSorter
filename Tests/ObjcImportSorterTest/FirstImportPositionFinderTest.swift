import XCTest
@testable import ObjcImportSorterCore

class FirstImportPositionFinderTest: XCTestCase {
    
    func test__shouldFindFirstImportPosition() {
        let testContent =
        """
        // This is comment
        // Second line

        #import "a.h"
        #import <b/b.h>
        #import "c.h"
        #import <d/d.h>
        """
        
        let sut = FirstImportPositionFinder(with: testContent)
        
        let firstPosition = sut.find()
        
        XCTAssertEqual(firstPosition, 3)
    }
    
    func test__whenFileContentNotHadImport__shuoldGotPositionNil() {
        let testContent =
        """
        // This is comment
        // Second line
        """
        
        let sut = FirstImportPositionFinder(with: testContent)
        
        let firstPosition = sut.find()
        
        XCTAssertEqual(firstPosition, nil)
    }

}
