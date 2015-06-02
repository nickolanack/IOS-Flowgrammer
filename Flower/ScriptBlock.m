//
//  ScriptNode.m
//  Flower
//
//  Created by Nick Blackwell on 3/6/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ScriptBlock.h"
#import "VariableConnection.h"
#import  "StringVariable.h"
#import "Variable.h"
#import "FlowView.h"

@implementation ScriptBlock

-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Edit Script" action:@selector(displayDetailView)]];
    return [[NSArray alloc] initWithArray:array];
}

-(NSString *)getDetailNibName{
    return @"nodeviews.viewcontrollers";
}
-(int)getDetailNibIndex{
    return 0;
}

-(void)configure{
    
    [super configure];
    
    VariableConnection *input=[[VariableConnection alloc] init];
    [input setName:@"a"];
    [input setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeTop];
    [input connectNode:nil toNode:self];
    
    VariableConnection *output=[[VariableConnection alloc] init];
    [output setName:@"out"];
    [output setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeBottom];
    [output connectNode:self toNode:nil];
    
    [self setName:@"Javascript Function"];
    
}

-(void)notifyInputVariableConnectionStateDidChange:(VariableConnection *)vc{
    
    int max=4;
    int i=self.inputVariableConnections.count-1;
    VariableConnection *c=(VariableConnection *)[self.inputVariableConnections objectAtIndex:i];
    NSArray *names=@[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i"];
    if(c.source!=nil&&self.inputVariableConnections.count< max){
        VariableConnection *input=[[VariableConnection alloc] init];
        [input setName:[names objectAtIndex:self.inputVariableConnections.count]];
        [input setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeTop];
        [input connectNode:nil toNode:self];
        [self.flow addConnection:input];
    }
    i--; //don't remove the one just added.
    for(int j=i;j>=0;j--){
       VariableConnection *c=(VariableConnection *)[self.inputVariableConnections objectAtIndex:j];
        if(c.source==nil){
            if(self.flow!=nil)[self.flow deleteConnection:c];
        }
    }
   
    int count=self.inputVariableConnections.count;
    float space=MIN(20, 35/(count-1));
    
    for(int j=0;j<self.inputVariableConnections.count;j++){
        VariableConnection *c=(VariableConnection *)[self.inputVariableConnections objectAtIndex:j];
        [c setName:[names objectAtIndex:j]];
        float offset=0;
        
        offset=space*j-((space/2.0)*(count-1));
        
        
        [c setCenterAlignOffsetDestination:CGPointMake(offset, 0)];
        [c needsUpdate];
    }

}


-(NSString *)jString:(NSString *)string{

    NSArray *a=@[string];
    NSError *error;
    NSString *s=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:a options:0 error:&error] encoding:NSUTF8StringEncoding];
    NSRange r;
    r.location=1; r.length=s.length-2;
    return [s substringWithRange:r];

}

-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    
    
    if(self.javascript!=nil){
        
        context[@"message"] = ^(NSString * string) {
            [self message:string];
        };
       
        
        [context setExceptionHandler:^(JSContext * context, JSValue * value) {
            [self error:[NSString stringWithFormat:@"%@",value]];
        }];
        
        NSString *input;
        NSMutableArray *jsParts=[[NSMutableArray alloc] init];
       [jsParts addObject:@"output"];
        for (VariableConnection *vc in self.inputVariableConnections) {
            Variable *v=(Variable *)vc.source;
            if(v!=nil){
                id value=[v value];
                if(value!=nil){
                    [jsParts addObject:[self jString:value]];
                }
                
            }else{
                
            }
        }
        input=[NSString stringWithFormat:@"[%@]",[jsParts componentsJoinedByString:@", "]];
       
        NSString *fn=[NSString stringWithFormat:@"output=(function(args){ %@ })(%@);",self.javascript, input];
        [context evaluateScript: fn];
        JSValue *output=context[@"output"];
        
        
        
        Variable *o=(Variable *)((VariableConnection *)[self.outputVariableConnections objectAtIndex:0]).destination;
        if(o!=nil){
            [o setValue:[NSString stringWithFormat:@"%@",output]];
        }
        
        
        return output;
        
    }
    
    return nil;
}
-(bool)restore:(NSDictionary *)state{

    NSString *javascript=[state objectForKey:@"javascript"];
    if(javascript !=nil){
        [self setJavascript:javascript];
    }

    return [super restore:state];
}
-(NSDictionary *)save{
    NSMutableDictionary *d=[[NSMutableDictionary alloc] initWithDictionary:[super save]];
    if(self.javascript!=nil){
    [d addEntriesFromDictionary:@{
                                  @"javascript":self.javascript,
                                  }];
    }
    return d;

}


@end
