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
    
    func test__shouldFindInternalImportAndSorted() {
        guard let fileContent: String = try? testFilePath.read() else {
            XCTFail("File content can't be nil")
            return
        }
        
        let result = fileContent.findInternalImport()
        
        let exceptCountTrue = result.count == 3
        
        guard exceptCountTrue else {
            XCTFail("Result count error, stop test avoid not stable test crash.")
            return
        }
        
        XCTAssertEqual(result[0], "#import \"a.h\"")
        XCTAssertEqual(result[1], "#import \"c.h\"")
        XCTAssertEqual(result[2], "#import \"y.h\"")
    }
    
    func test__shouldFindFrameworkImportAndSorted() {
        guard let fileContent: String = try? testFilePath.read() else {
            XCTFail("File content can't be nil")
            return
        }
        
        let result = fileContent.findFrameworkImport()
                
        let exceptCountTrue = result.count == 8
        
        guard exceptCountTrue else {
            XCTFail("Result count error, stop test avoid not stable test crash.")
            return
        }
        
        XCTAssertEqual(result[0], "#import <b/b.h>")
        XCTAssertEqual(result[1], "")
        XCTAssertEqual(result[2], "#import <d/d.h>")
        XCTAssertEqual(result[3], "")
        XCTAssertEqual(result[4], "#import <e/e.h>")
        XCTAssertEqual(result[5], "")
        XCTAssertEqual(result[6], "#import <z/a.h>")
        XCTAssertEqual(result[7], "#import <z/z.h>")
    }
    
    override func tearDown() {
        try? testFilePath.delete()
        try? tempDir.delete()

        super.tearDown()
    }
}
