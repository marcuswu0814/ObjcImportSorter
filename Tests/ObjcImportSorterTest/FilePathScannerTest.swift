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
        
        guard let result = FilePathScanner.scanFile(type: .h) else {
            XCTFail("Result can't be nil")
            return
        }
        
        XCTAssertTrue(result.count == 2)
        XCTAssertTrue(result.contains(where: {
            return $0.string.hasSuffix(aFilePath.string)
        }))
        XCTAssertTrue(result.contains(where: {
            return $0.string.hasSuffix(bFilePath.string)
        }))
    }
    
    override func tearDown() {
        try? aFilePath.delete()
        try? bFilePath.delete()
        try? tempDir.delete()

        super.tearDown()
    }
}
