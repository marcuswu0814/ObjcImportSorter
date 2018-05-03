import XCTest
import PathKit
@testable import ObjcImportSorterCore

class FilePathScannerTest: XCTestCase {
    
    let tempDir = Path("/tmp/ObjcImportSorterCoreTest")
    lazy var aFilePath: Path = tempDir + Path("a.h")
    lazy var bFilePath: Path = tempDir + Path("b.h")
    
    override func setUp() {
        super.setUp()
        
        try? tempDir.mkdir()
        try? aFilePath.write("")
        try? bFilePath.write("")
    }

    func test__shouldFindTwoHeaderFile() {
        Path.current = tempDir
        
        let result = FilePathScanner.scanFile(type: .h)
        
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.contains(where: { $0.string.hasSuffix(aFilePath.string) }), true)
        XCTAssertEqual(result?.contains(where: { $0.string.hasSuffix(bFilePath.string) }), true)
    }
    
    override func tearDown() {
        try? aFilePath.delete()
        try? bFilePath.delete()
        try? tempDir.delete()

        super.tearDown()
    }
}
