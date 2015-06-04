//
//  Flowutils.m
//  Flower
//
//  Created by Nick Blackwell on 2015-06-02.
//  Copyright (c) 2015 Nick Blackwell. All rights reserved.
//

#import "Flowutils.h"
#import "Block.h"
#import "Connection.h"
#import "FlowView.h"
#import "FlowBlock.h"

@implementation Flowutils


+(NSDictionary *)ParseFlowgramFromFile:(NSString *)file{
    NSError *error;

    if(![[NSFileManager defaultManager] fileExistsAtPath:file]){
        
        @throw [NSException
                exceptionWithName:@"File does not exist"
                reason:[NSString stringWithFormat: @"File not found: %@", file]
                userInfo:nil];
        
    }
    
    NSString *flowgram=[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    
    if(error){
        @throw [NSException
                exceptionWithName:@"ReadFileFailed"
                reason:@"Failed to read file"
                userInfo:nil];
        
    }
    
    return [self ParseFlowgramJson:flowgram];

}

+(NSDictionary *)ParseFlowgramJson:(NSString *)json{

    if(json==nil){
        
        @throw [NSException
                exceptionWithName:@"EmptyJsonString"
                reason:@"Json string was empty"
                userInfo:nil];
    }
    
    NSError *error;
    NSDictionary* state = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if(error){
        @throw [NSException
                exceptionWithName:@"JsonDecodeFailed"
                reason:@"Failed to decode json string"
                userInfo:nil];

    }
    
    
    return state;
}



+(Block *)LoadFlowgramBlock:(NSDictionary *)block withOwner:(id) owner{
    
    
    NSArray *bundle=[block objectForKey:@"bundle"];
    if(bundle!=nil){
        NSString *bundleName=(NSString *)[bundle objectAtIndex:0];
        int index=[(NSNumber *)[bundle objectAtIndex:1] integerValue];
        return [Block InstantiateWithBundle:bundleName andIndex:index andOwner:owner];
        
    }else{
        
        int index=[(NSNumber *)[block objectForKey:@"index"] integerValue];
        return [Block InstantiateWithBundle:@"program" andIndex:index andOwner:owner];
        
        //Start and end blocks, do not have bundle info
        //@throw [NSException exceptionWithName:@"Expected to find bundle" reason:@"Encountered a block state without bundle info" userInfo:nil];
    }
    
    return nil;
    
}





+(NSArray *)LoadFlowgramBlocks:(NSArray *)blockStates withOwner:(id) owner{

    NSMutableArray *array=[[NSMutableArray alloc] init];
    

    for(int i=0;i<blockStates.count;i++){
        NSDictionary *blockState=[blockStates objectAtIndex:i];
        Block *b=[self LoadFlowgramBlock:blockState withOwner:owner];
        if(b!=nil){
            [array addObject:b];
        }else{
        
        
        }
    }

    return [[NSArray alloc] initWithArray:array];

}

+(void)ConnectFlowgramBlocks: (NSArray *) blocks withConnections:(NSArray *)connections {
    
   
    NSMutableArray *connectionStates=[[NSMutableArray alloc] initWithArray:connections];
    NSMutableArray *removed=[[NSMutableArray alloc] init];
    while(connectionStates.count){
        for(int i=0;i<connectionStates.count;i++){
            NSDictionary *connectionState=[connectionStates objectAtIndex:i];
            int a=[((NSNumber *)[connectionState objectForKey:@"source"]) integerValue];
            int b=[((NSNumber *)[connectionState objectForKey:@"destination"]) integerValue];
            
            if(a!=NSNotFound&&b!=NSNotFound){
                Block *blockA=[blocks objectAtIndex:a];
                Block *blockB=[blocks objectAtIndex:b];
                if([blockA isKindOfClass:[FlowBlock class]]&&[blockB isKindOfClass:[FlowBlock class]]){
                    FlowBlock *functionA=(FlowBlock *)blockA;
                    if([functionA getNextBlock]!=blockB){
                        if(functionA.primaryOutputConnection!=nil){
                            
                            [removed addObject:connectionState];
                            [functionA.primaryOutputConnection insertBlock:blockB];

                        }
                    }else{
                        [removed addObject:connectionState];
                    }
                }
            }
        }
        
        for (NSDictionary *d in removed) {
            [connectionStates removeObject:d];
        }
    }
    
}

+(Block *)InstantiateWithBundle:(NSString *)bundle andIndex:(int)index andOwner:(id) owner{
    Block *b= (Block *)[[[NSBundle mainBundle] loadNibNamed:bundle owner:owner options:nil] objectAtIndex:index];
    
    [b setBundleName:bundle];
    [b setIndexInBundle:index];
    return b;
}


@end
