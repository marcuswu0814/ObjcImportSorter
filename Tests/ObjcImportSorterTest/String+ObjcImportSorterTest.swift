import XCTest
import PathKit
@testable import ObjcImportSorterCore

class StringObjcImportSorterTest: XCTestCase {
    
    let tempDir = Path("/tmp/ObjcImportSorterCoreTest")
    lazy var testFilePath: Path = tempDir + Path("a.h")
    
    override func setUp() {
        super.setUp()
        
        try? tempDir.mkdir()
        
        let testContent =
        """
        #import  <z/z.h>
        #import <z/a.h>
        #import  "y.h"
        #import "a.h"
        #import <b/b.h>
        #import "c.h"
        #import <d/d.h>

        typedef void (^MainBlock)(void);

        #import <e/e.h>
        """
        try? testFilePath.write(testContent)
    }
    
    func test__shouldFindInternalImports() {
        guard let fileContent: String = try? testFilePath.read() else {
            XCTFail("File content can't be nil")
            return
        }
        
        let result = fileContent.findInternalImport()
        
        XCTAssertTrue(result.count == 3)
    }
    
    func test__shouldFindFrameworkImports() {
        guard let fileContent: String = try? testFilePath.read() else {
            XCTFail("File content can't be nil")
            return
        }
        
        let result = fileContent.findFrameworkImport()
        
        XCTAssertTrue(result.count == 5)
    }
    
    override func tearDown() {
        try? testFilePath.delete()
        try? tempDir.delete()

        super.tearDown()
    }
}
