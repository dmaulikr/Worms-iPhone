//
//  PegImageView.h
//  LateWorm
//
//  Created by Fred Sharples on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PegImageView : UIImageView {
	NSMutableString *_pegType;
}

- (void) setPegType:(NSString*)pegType;

@end
