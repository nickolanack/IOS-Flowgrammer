//
//  ProcessorBlock.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ProcessorBlock.h"
#import "FlowView.h"
#import "Flowutils.h"

@implementation ProcessorBlock

-(void)configure{

    self.outputVariableConnections=[[NSMutableArray alloc] init];
    self.inputVariableConnections=[[NSMutableArray alloc] init];
    [super configure];

}
-(NSArray *)getConnections{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getConnections]];
    
    if(self.inputVariableConnections!=nil)[a addObjectsFromArray:self.inputVariableConnections];
    if(self.outputVariableConnections!=nil)[a addObjectsFromArray:self.outputVariableConnections];
    
    
    return [[NSArray alloc] initWithArray:a];
    
  
}


-(void)addInputVariableConnection:(VariableConnection *)v{
    
    if([self.inputVariableConnections indexOfObject:v]==NSNotFound)[self.inputVariableConnections addObject:v];
    //    if(v.name!=nil&&[v.name isEqualToString:@"b"]){
    //        NSLog(@"%@", v);
    //    }
}
-(void)addOutputVariableConnection:(VariableConnection *)v{
    
    if([self.outputVariableConnections indexOfObject:v]==NSNotFound)[self.outputVariableConnections addObject:v];
}


-(void)removeInputVariableConnection:(VariableConnection *)v{
    
    if([self.inputVariableConnections indexOfObject:v]!=NSNotFound)[self.inputVariableConnections removeObject:v];
    
}

-(void)removeOutputVariableConnection:(VariableConnection *)v{
    if([self.outputVariableConnections indexOfObject:v]!=NSNotFound)[self.outputVariableConnections removeObject:v];
}

-(void)notifyOutputVariableDidChangeValueForConnection:(VariableConnection *)vc{ }
-(void)notifyInputVariableDidChangeValueForConnection:(VariableConnection *)vc{ }

-(void)notifyOutputVariableConnectionStateDidChange:(VariableConnection *)vc{ }
-(void)notifyInputVariableConnectionStateDidChange:(VariableConnection *)vc{ }

-(bool)restore:(NSDictionary *)state{
    NSArray *inputs=[state objectForKey:@"inputs"];
    if(inputs!=nil){
        for(int i=0;i<inputs.count;i++){
            int j=[((NSNumber *)[inputs objectAtIndex:i]) integerValue];
            if(j!=NSNotFound){
                [[self.inputVariableConnections objectAtIndex:i] insertBlock:[self.flow blockAtIndex:j]];
            }

        }
        
    }
    
    NSArray *outputs=[state objectForKey:@"outputs"];
    if(outputs!=nil){
        for(int i=0;i<outputs.count;i++){
            int j=[((NSNumber *)[outputs objectAtIndex:i]) integerValue];

            [[self.outputVariableConnections objectAtIndex:i] insertBlock:[self.flow blockAtIndex:j]];
        }
        
    }
    return [super restore:state];
    
}

-(NSDictionary *)save{
    NSMutableDictionary *d=[[NSMutableDictionary alloc] initWithDictionary:[super save]];
    
    NSMutableArray *inputs=[[NSMutableArray alloc] init];
    for (VariableConnection *v in self.inputVariableConnections) {
        Variable *var=(Variable *)v.source;
        if(var!=nil){
            [inputs addObject:[NSNumber numberWithInt:[self.flow indexOfBlock:var]]];
        }else{
            [inputs addObject:[NSNumber numberWithInt:NSNotFound]];
        }
    }
    
    NSMutableArray *outputs=[[NSMutableArray alloc] init];
    for (VariableConnection *v in self.outputVariableConnections) {
        Variable *var=(Variable *)v.destination;
        if(var!=nil){
            [outputs addObject:[NSNumber numberWithInt:[self.flow indexOfBlock:var]]];
        }else{
            [outputs addObject:[NSNumber numberWithInt:NSNotFound]];
        }
    }
    
    
    [d addEntriesFromDictionary:@{
                                  @"inputs":inputs,
                                  @"outputs":outputs
                                  }];
    return d;
}

@end
