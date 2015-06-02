//
//  FlowerTests.m
//  FlowerTests
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Flowutils.h"
#import "Block.h"
#import "Connection.h"
#import "StartupBlock.h"


@interface FlowerTests : XCTestCase

@end

@implementation FlowerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParse
{
    XCTAssertTrue(true, @"Pass");
    
    NSDictionary * state=[Flowutils ParseFlowgramJson:@"{ "
     "\"blocks\":[]"
     "}"];
    
    XCTAssertTrue([state objectForKey:@"blocks"]!=nil);
    
    NSString *blankProgram = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"2015-06-02 000002.flow"];
    
    NSError *error;
    NSArray *dir=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath]  error:&error];
    NSLog(@"%@", dir);
    
    
    state=[Flowutils ParseFlowgramFromFile:blankProgram];
    
    XCTAssertTrue([state objectForKey:@"blocks"]!=nil);

    
}

- (void)testLoad{

    
    NSString *blankProgram = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"2015-06-02 000002.flow"];
    
    NSError *error;
    NSArray *dir=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath]  error:&error];
    NSLog(@"%@", dir);
    
    
    NSDictionary * state=[Flowutils ParseFlowgramFromFile:blankProgram];
    
    XCTAssertTrue([state objectForKey:@"blocks"]!=nil);
    XCTAssertEqual(2, [((NSArray *)[state objectForKey:@"blocks"]) count]);
    

    XCTAssertTrue([state objectForKey:@"connections"]!=nil);
    XCTAssertEqual(1, [((NSArray *)[state objectForKey:@"connections"]) count]);
    
    
    NSArray *blocks =[Flowutils LoadFlowgramBlocks:[state objectForKey:@"blocks"] withOwner:nil];
    
    XCTAssertEqual(2, blocks.count);

    
    for (int i=0; i<blocks.count; i++) {
        XCTAssertTrue([[blocks objectAtIndex:i] isKindOfClass:[Block class]]);
    }
    
    [Flowutils ConnectFlowgramBlocks:blocks withConnections:[state objectForKey:@"blocks"]];
    
    
      
}


- (void)testRun{
    
    
    NSString *blankProgram = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"2015-06-02 000002.flow"];

    
    NSDictionary * state=[Flowutils ParseFlowgramFromFile:blankProgram];

    NSArray *blocks =[Flowutils LoadFlowgramBlocks:[state objectForKey:@"blocks"] withOwner:nil];
    
    for (int i=0; i<blocks.count; i++) {
        XCTAssertTrue([[blocks objectAtIndex:i] isKindOfClass:[Block class]]);
    }
    
    [Flowutils ConnectFlowgramBlocks:blocks withConnections:[state objectForKey:@"blocks"]];
    
    StartupBlock *start=(StartupBlock *)[blocks objectAtIndex:0];
    [start run];
    
    
}

@end
