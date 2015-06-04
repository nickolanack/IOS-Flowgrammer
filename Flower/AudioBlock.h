//
//  AudioBlock.h
//  Flower
//
//  Created by Nick Blackwell on 3/16/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowBlock.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioBlock : FlowBlock<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *audioImage;
@property NSString *sound;
@end
 