//
//  VoterBoatTests.m
//  VoterBoatTests
//
//  Created by Bradley Slayter on 9/18/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface VoterBoatTests : XCTestCase {
	BOOL passwordsMatch;
	BOOL didLogIn;
	BOOL loadedElections;
	BOOL uploadedProfile;
}



@end

@implementation VoterBoatTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testPasswordsMatch {
	XCTAssertTrue(passwordsMatch);
}

-(void) testDidLogIn {
	XCTAssertTrue(didLogIn);
}

-(void) testLoadedElections {
	XCTAssertTrue(loadedElections);
}

-(void) testUploadedProfile {
	XCTAssertTrue(uploadedProfile);
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
