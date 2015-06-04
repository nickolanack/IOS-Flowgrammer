//
//  NodeLibraryViewController.m
//  Flower
//
//  Created by Nick Blackwell on 3/5/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NodeLibraryViewController.h"
#import "NodeViewCell.h"
#import "VariableViewCell.h"
#import "FunctionalBlock.h"
#import "Variable.h"
#import "Sensor.h"
#import "LogicGate.h"
#import "Flowutils.h"

@interface NodeLibraryViewController ()

@property NSArray *blocklibrary;
@property NSArray *variablelibrary;
@property NSArray *sensorlibrary;
@property NSArray *logiclibrary;

@end

@implementation NodeLibraryViewController
@synthesize flow, connection, point;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView==self.blockCollection){
       return [self getNodeLib].count;
    }else if(collectionView==self.variableCollection){
        return [self getVariableLib].count;
    }else if(collectionView==self.sensorCollection){
        return [self getSensorLib].count;
    }
    else if(collectionView==self.logicCollection){
        return [self getLogicLib].count;
    }
    return 0;
}

-(NSArray*)getNodeLib{
    if(_blocklibrary!=nil)return _blocklibrary;
    NSBundle *b=[NSBundle mainBundle];
    NSArray *a=[b loadNibNamed:@"nodeviews" owner:self options:nil];
    _blocklibrary=a;
    return a;
}
-(NSArray*)getVariableLib{
    if(_variablelibrary!=nil)return _variablelibrary;
    NSBundle *b=[NSBundle mainBundle];
    NSArray *a=[b loadNibNamed:@"variableviews" owner:self options:nil];
    _variablelibrary=a;
    return a;
}

-(NSArray*)getSensorLib{
    if(_sensorlibrary!=nil)return _sensorlibrary;
    NSBundle *b=[NSBundle mainBundle];
    NSArray *a=[b loadNibNamed:@"sensorviews" owner:self options:nil];
    _sensorlibrary=a;
    return a;
}
-(NSArray*)getLogicLib{
    if(_logiclibrary!=nil)return _logiclibrary;
    NSBundle *b=[NSBundle mainBundle];
    NSArray *a=[b loadNibNamed:@"logicviews" owner:self options:nil];
    _logiclibrary=a;
    return a;
}

-(FunctionalBlock *)getLibraryNodeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int i=indexPath.item;
    return (FunctionalBlock *)[[self getNodeLib] objectAtIndex:i];

}

-(Variable *)getLibraryVariableForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int i=indexPath.item;
    return (Variable *)[[self getVariableLib] objectAtIndex:i];
    
}
-(Sensor *)getLibrarySensorForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int i=indexPath.item;
    return (Sensor *)[[self getSensorLib] objectAtIndex:i];
    
}

-(LogicGate *)getLibraryLogicGateForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int i=indexPath.item;
    return (LogicGate *)[[self getLogicLib] objectAtIndex:i];
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==self.blockCollection){
        NodeViewCell *c=[collectionView dequeueReusableCellWithReuseIdentifier:@"nodeViewCell" forIndexPath:indexPath];
        if(c!=nil){
            Block *block=[self getLibraryNodeForItemAtIndexPath:indexPath];
            
            [block setBundleName:@"nodeviews"];
            [block setIndexInBundle:indexPath.item];
            
            [c setNode:block];
            [c setNodeLibraryViewController:self];
            return c;
        }
    }else if(collectionView==self.variableCollection){
        VariableViewCell *c=[collectionView dequeueReusableCellWithReuseIdentifier:@"variableViewCell" forIndexPath:indexPath];
        if(c!=nil){
            
            Block *block=[self getLibraryVariableForItemAtIndexPath:indexPath];
            
            [block setBundleName:@"variableviews"];
            [block setIndexInBundle:indexPath.item];
            
            [c setNode:block];
            [c setNodeLibraryViewController:self];
            return c;
        }
    }else if(collectionView==self.sensorCollection){
        NodeViewCell *c=[collectionView dequeueReusableCellWithReuseIdentifier:@"nodeViewCell" forIndexPath:indexPath];
        if(c!=nil){
            
            Block *block=[self getLibrarySensorForItemAtIndexPath:indexPath];
            
            [block setBundleName:@"sensorviews"];
            [block setIndexInBundle:indexPath.item];
            
            [c setNode:block];
            [c setNodeLibraryViewController:self];
            return c;
        }
    }else if(collectionView==self.logicCollection){
        VariableViewCell *c=[collectionView dequeueReusableCellWithReuseIdentifier:@"variableViewCell" forIndexPath:indexPath];
        if(c!=nil){
            
            Block *block=[self getLibraryLogicGateForItemAtIndexPath:indexPath];
            
            [block setBundleName:@"logicviews"];
            [block setIndexInBundle:indexPath.item];
            
            [c setNode:block];
            [c setNodeLibraryViewController:self];
            return c;
        }
    }
    
    return nil;
}
- (void) selectFlowNode:(Block *)node{
    if(self.flow){
        if(self.connection!=nil&&[node isKindOfClass:[FunctionalBlock class]]){
            [self.flow addBlock:node];
            [node moveCenterToPoint:[connection getCenterPoint]];
            [self.connection insertBlock:node];
            
        }else{
            [self.flow addBlock:node];
            if(self.point!=nil){
                [node moveCenterToPoint:[self.point CGPointValue]];
            }
        }
        [self dismissViewControllerAnimated:TRUE completion:^{
                
        }];

    }

}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}
@end
