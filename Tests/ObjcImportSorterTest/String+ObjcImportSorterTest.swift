import XCTest
import PathKit
@testable import ObjcImportSorterCore

class StringObjcImportSorterTest: XCTestCase {
    
    let tempDir = Path("/tmp/ObjcImportSorterCoreTest")
    lazy var testFilePath: Path = tempDir + Path("a.h")
    
    override func setUp() {
        super.setUp()
        
        try? tempDir.mkdir()
        
        let testContent = TestDataFactory.generalHeader
        try? testFilePath.write(testContent)
    }
    
    func test__shouldFindInternalImports() {
        let fileContent: String? = try? testFilePath.read()
        let result = fileContent?.findInternalImport()
        
        XCTAssertEqual(result?.count, 4)
    }
    
    func test__shouldFindFrameworkImports() {
        let fileContent: String? = try? testFilePath.read()
        let result = fileContent?.findFrameworkImport()
        
        XCTAssertEqual(result?.count, 6)
    }
    
    override func tearDown() {
        try? testFilePath.delete()
        try? tempDir.delete()

        super.tearDown()
    }
}
