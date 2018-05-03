struct TestDataFactory {
    
    static let noAnyImportFile =
    """
    //
    //  FakeClass.h
    //  Fake
    //
    //  Created by MarcusWu on 2018/5/3.
    //
    """
    
    static let generalHeader =
    """
    //
    //  FakeClass.h
    //  Fake
    //
    //  Created by MarcusWu on 2018/4/24.
    //

    #import <UIKit/UIKit.h>

    #import "d.h"
    #import <y/b.h>
    #import "c.h"
    #import <y/a.h>
    #import "a.h"
    #import <z/b.h>
    #import "b.h"
    #import <z/a.h>

    #import <Foundation/Foundation.h>
    @interface FakeClass : UIView

    @end

    """
    
    static let generalHeaderWithoutImport =
    """
    //
    //  FakeClass.h
    //  Fake
    //
    //  Created by MarcusWu on 2018/4/24.
    //



    @interface FakeClass : UIView

    @end

    """
    
    static let exceptGeneralHeader =
    """
    //
    //  FakeClass.h
    //  Fake
    //
    //  Created by MarcusWu on 2018/4/24.
    //

    #import "a.h"
    #import "b.h"
    #import "c.h"
    #import "d.h"

    #import <Foundation/Foundation.h>

    #import <UIKit/UIKit.h>

    #import <y/a.h>
    #import <y/b.h>
    
    #import <z/a.h>
    #import <z/b.h>

    @interface FakeClass : UIView

    @end


    """
    // IMPORTANT: This means one empty line suffix, not two.
    
    static let mocHeader =
    """
    //
    //  FakeClass.h
    //  Fake
    //
    //  Created by MarcusWu on 2018/4/24.
    //

    #import <CoreData/CoreData.h>
    @interface TestCoreData : NSManagedObject

    @end

    """
    
    static let ifdefContent =
    """
    //
    //  FakeClass.h
    //  Fake
    //
    //  Created by MarcusWu on 2018/4/24.
    //

    #import "b.h"
    #import "a.h"
    
    #import <UIKit/UIKit.h>


    #ifdef TARGET
    #import "e.h"
    #import "c.h"
    #else
    #import "d.h"
    #endif

    #import "f.h"

    #import <Foundation/Foundation.h>

    @interface FakeClass : UIView

    #ifdef TARGET

    - (void)testFunc;

    #endif

    @end

    """
    
    static let exceptIfdefContent =
    """
    //
    //  FakeClass.h
    //  Fake
    //
    //  Created by MarcusWu on 2018/4/24.
    //

    #import "a.h"
    #import "b.h"
    #import "f.h"

    #import <Foundation/Foundation.h>

    #import <UIKit/UIKit.h>

    #ifdef TARGET
    #import "e.h"
    #import "c.h"
    #else
    #import "d.h"
    #endif

    @interface FakeClass : UIView

    #ifdef TARGET

    - (void)testFunc;

    #endif

    @end


    """
}
