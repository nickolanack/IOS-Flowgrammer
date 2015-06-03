//
//  Flowutils.h
//  Flower
//
//  Created by Nick Blackwell on 2015-06-02.
//  Copyright (c) 2015 Nick Blackwell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Block;
@class Connection;

@interface Flowutils : NSObject

+(NSDictionary *)ParseFlowgramJson:(NSString *) json;
+(NSDictionary *)ParseFlowgramFromFile:(NSString *) file;
+(NSArray *)LoadFlowgramBlocks:(NSArray *) state withOwner:(id) owner;
+(Block *)LoadFlowgramBlock:(NSDictionary *) block withOwner:(id) owner;
+(void)ConnectFlowgramBlocks: (NSArray *) blocks withConnections:(NSArray *)connections;
    


+(bool)InsertBlock:(Block *)n At:(Connection *)c;

+(Block *)InstantiateWithBundle:(NSString *)bundle andIndex:(int)index andOwner:(id) owner;

@end
