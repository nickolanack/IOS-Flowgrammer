//
//  FlowLibraryViewController.m
//  Flower
//
//  Created by Nick Blackwell on 3/14/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowLibraryViewController.h"
#import "FlowLibraryCell.h"

@interface FlowLibraryViewController ()

@property NSArray *files;
@end

@implementation FlowLibraryViewController

@synthesize flow, flowViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self getFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)getFiles{

    if(_files!=nil)return _files;
    NSString *directory = [NSHomeDirectory()
                            stringByAppendingPathComponent:@"Documents"];
    NSFileManager *f=[NSFileManager defaultManager];
    NSError *err;
    NSArray *a=[f contentsOfDirectoryAtPath:directory error:&err];
    NSMutableArray *files=[[NSMutableArray alloc] init];
    for (NSString *path in a) {
        BOOL dir;
        if([f fileExistsAtPath:[directory stringByAppendingPathComponent:path] isDirectory:&dir]&&!dir){
            NSRange r=[path rangeOfString:@".flow"];
            if(r.location==path.length-5){
                [files addObject:path];
            }
            
     
            
        }
    }
    _files=[[NSArray alloc] initWithArray:files];
    return _files;
    
}
-(NSDictionary *)decodeFile:(NSString *)file{
    NSError *error;

    NSString *flowgram=[NSString stringWithContentsOfFile:[[NSHomeDirectory()
                                                            stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:file] encoding:NSUTF8StringEncoding error:&error];
    
    if(flowgram!=nil){
        
        NSDictionary* state = [NSJSONSerialization JSONObjectWithData:[flowgram dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        
        if(state!=nil){
            return state;
            
        }
        
    }
    return nil;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _files.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlowLibraryCell *c=[collectionView dequeueReusableCellWithReuseIdentifier:@"flowLibraryCell" forIndexPath:indexPath];
    if(c!=nil){
        NSString *file=[_files objectAtIndex:indexPath.item];
        [c.file setText:file];
        [c.label setText:@"My Flow"];
        [c.note setText:@"my first flowgram"];
        
        NSDictionary *state=[self decodeFile:file];
        if(state!=nil){
        
            [c.label setText:(NSString *)[state objectForKey:@"name"]];
            [c.note setText:(NSString *)[state objectForKey:@"description"]];
            
            [c setPath:file];
            [c setFlowLibraryViewController:self];
        
        }
        
        
       
        
        return c;
    }
    return nil;
}

-(void)selectFile:(NSString *)path{

    NSLog(@"Select file %@", path);
    if([self.flowViewController.flowFile isEqualToString:path]){
        //same file.
    }else{
        [self dismissViewControllerAnimated:TRUE completion:^{
            [self.flowViewController openFlow:path];
        }];
        
    }
}

- (IBAction)onNewClick:(id)sender {
    
    NSString *file=[self.flowViewController blankFlowFile];
    [self.flowViewController writeFlow:[self.flowViewController blankFlow] toFile:file];
    
    [self selectFile:file];
    
    
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}
@end
