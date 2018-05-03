import XCTest
@testable import ObjcImportSorterCore

class FileImportKillerTest: XCTestCase {
    
    func test__shouldKillAllImports() {
        let testContent = TestDataFactory.generalHeader
        
        let sut = FileImportKiller(with: testContent)
        
        let result = sut.kill()
        
        let exceptContent = TestDataFactory.generalHeaderWithoutImport
        
        XCTAssertEqual(result, exceptContent)
    }
    
    func test__whenFileContentAreAllImportsLine__shouldGotAnEmptyString() {
        let testContent =
        """
        #import "a.h"
        #import <b/b.h>
        #import "c.h"
        #import <d/d.h>
        """
        
        let sut = FileImportKiller(with: testContent)
        
        let result = sut.kill()
        
        let exceptContent = ""
        
        XCTAssertEqual(result, exceptContent)
    }
    
}

