#import "LevelIntroView.h"

@implementation LevelIntroView

@synthesize _levelFlower;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}



- (void) setMovesText:(unsigned)moves {
	_movesText.font = [UIFont fontWithName:@"HelveticaNeueLTStd-Bd" size:16.0];
	if (moves == 0) {
		_movesText.text = @"You've already won the flower.";
	} else {
		if (moves == 1) {
			_movesText.text = [NSString stringWithFormat:@"Solve it in %d move to win a flower.", moves];
		} else {
			_movesText.text = [NSString stringWithFormat:@"Solve it in %d moves to win a flower.", moves];
		}
	}
}

- (void) setLevelNumberImages:(unsigned)levelNum {
	unsigned firstNumber, secondNumber;
	
	firstNumber = floor(levelNum / 10);
	secondNumber = levelNum % 10;
	
	_levelNumber0.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", firstNumber]];
	_levelNumber1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", secondNumber]];
	
	if (levelNum < 10) {
		_levelNumber0.hidden = YES;
		_levelNumber1.frame = CGRectMake(117, _levelNumber1.frame.origin.y, _levelNumber1.image.size.width, _levelNumber1.image.size.height);
	} else {
		_levelNumber0.hidden = NO;
		_levelNumber1.frame = CGRectMake(156, _levelNumber1.frame.origin.y, _levelNumber1.image.size.width, _levelNumber1.image.size.height);
	}

}

@end
