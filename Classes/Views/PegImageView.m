//
//  PegImageView.m
//  LateWorm
//
//  Created by Fred Sharples on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PegImageView.h"
#import "Constants.h"

@implementation PegImageView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		_pegType = [[NSMutableString alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) setPegType:(NSString*)pegType {
	UIImage *pegImage = nil;
	
	if (![_pegType isEqualToString:pegType]) {
		[_pegType setString:pegType];
		
		if ([_pegType isEqualToString:kGameEmpty]) {
			[self setImage:nil];
		} else {
			if ([_pegType isEqualToString:kGameWorm]) {
				pegImage = [UIImage imageNamed:kPegWormImage];
				
			} else if ([_pegType isEqualToString:kGameHole]) {
				pegImage = [UIImage imageNamed:kPegHoleImage];
			}
			[self setImage:pegImage];
			self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,pegImage.size.width,pegImage.size.height);
		}
		
		[self setNeedsDisplay];
	}
}

@end
