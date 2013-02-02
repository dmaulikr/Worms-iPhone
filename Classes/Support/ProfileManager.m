//
//  ProfileManager.m
//  LateWorm
//
//  Created by Susan Surapruik on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProfileManager.h"
#import "Constants.h"

@implementation ProfileManager

static ProfileManager *_sharedProfileManager = nil;

@synthesize _gameInProgress;

#pragma mark -
#pragma mark Initialization / Singleton / Memory Management

+ (ProfileManager*) sharedProfileManager {
	if (_sharedProfileManager == nil) {
		_sharedProfileManager = [[super allocWithZone:NULL] init];
		
		NSMutableDictionary *profile = [_sharedProfileManager getProfile];
		_sharedProfileManager._levelNum = [profile[kGameDataLevelNumKey] intValue];
		_sharedProfileManager._nextLevelNum = [profile[kGameDataNextLevelNumKey] intValue];
		[_sharedProfileManager updateLevels:profile[kGameDataLevelsKey]];
		[_sharedProfileManager updateSavedLayout:profile[kGameDataSavedLayoutKey]];
		_sharedProfileManager._savedLevel = [profile[kGameDataSavedLevelKey] boolValue];
		_sharedProfileManager._savedMoves = [profile[kGameDataSavedMovesKey] intValue];

		/*
		// Get level num
		NSMutableArray *levels = [NSMutableArray arrayWithArray:[_saveData objectForKey:kGameDataLevelsKey]];
		_levels = [[NSMutableArray alloc] initWithCapacity:[levels count]];
		for (i = 0; i < [levels count]; i++) {
			NSMutableDictionary *levelData = [[NSMutableDictionary alloc] initWithCapacity:[[levels objectAtIndex:i] count]];
			[levelData addEntriesFromDictionary:[levels objectAtIndex:i]];
			[_levels addObject:levelData];
			[levelData release];
		}
		*/
		
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return _sharedProfileManager;
}

+ (id) allocWithZone:(NSZone*) zone {
    return [self sharedProfileManager];
}

- (id) copyWithZone:(NSZone*) zone {
    return self;
}

//- (id) retain {
  //  return self;
//}

//- (NSUInteger) retainCount {
  //  return NSUIntegerMax;  //denotes an object that cannot be released
//}

//- (void) release {
    //do nothing
//}

//- (id) autorelease {
  //  return self;
//}


- (void) applicationWillResignActive {
	_paused = YES;
}

- (void) applicationDidBecomeActive {
	if (_paused) {
		_paused = NO;
	}
}

- (void)applicationWillTerminate {
	if (_paused && _gameInProgress) {
		self._savedLevel = YES;
		[self saveSavedLayout];
	} else {
		self._savedLevel = NO;
	}
	
}

- (NSMutableDictionary*) getProfile {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *filePath;
	NSMutableDictionary *profile, *initialProfile;
	
	if ([userDefaults objectForKey:kGameDataKey]) {
		profile = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:kGameDataKey]];
	} else {
		filePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
		initialProfile = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
		profile = [NSMutableDictionary dictionaryWithDictionary:initialProfile[kGameDataKey]];
	}
	
	return profile;
}

- (BOOL) setProfile:(NSDictionary*)newProfile {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *profile = [self getProfile];
	BOOL success;
	
	[profile addEntriesFromDictionary:newProfile];
	
	[userDefaults setObject:profile forKey:kGameDataKey];
	
	success = [userDefaults synchronize];
	
	return success;
}

- (void) initializeLayout {
	_currentLevelParse = 0;
	_currentLayout = [[NSMutableArray alloc] init];
	_currentParsedCharacterData = [[NSMutableString alloc] init];
	
	unsigned numLevels = [_levels count];;
	
	NSDictionary *levelData = [self getLevelDataForLevel:_currentLevelParse];
	while(_currentLevelParse + 1 < numLevels && levelData[kGameDataLayoutKey]) {
		_currentLevelParse++;
		levelData = [self getLevelDataForLevel:_currentLevelParse];
	}
	
	if (_currentLevelParse < numLevels && !levelData[kGameDataLayoutKey]) {
		[self initializeLayoutForLevel];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LEVEL_LAYOUT_PARSED" object:self userInfo:nil];
	}
}

- (void) initializeLayoutForLevel {
	_currentLeastMoves = 0;
	[_currentLayout removeAllObjects];
	[_currentParsedCharacterData setString:@""];
	
	NSDictionary *levelData = [self getLevelDataForLevel:_currentLevelParse];
	NSString *levelIdentifier = [NSString stringWithString:levelData[kGameDataIdentifierKey]];
	
	[self parseLevelXML:levelIdentifier];
}

- (void) parseLevelXML:(NSString*)levelIdentifier {
	NSString *xmlPath = [[NSBundle mainBundle] pathForResource:levelIdentifier ofType:@"xml"];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:xmlPath]];
	
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	[parser parse];
}

- (void) levelXMLParsed {
	NSMutableDictionary *levelData = [[NSMutableDictionary alloc] initWithDictionary:[self getLevelDataForLevel:_currentLevelParse]];
	NSArray *levelLayout = [[NSArray alloc] initWithArray:_currentLayout];
	levelData[kGameDataLeastMovesKey] = [NSNumber numberWithInteger:_currentLeastMoves];
	levelData[kGameDataLayoutKey] = levelLayout;
	
	[self setLevelDataForLevel:_currentLevelParse levelData:levelData];
	[self saveLevels];
	
	_currentLevelParse++;
	if (_currentLevelParse < [_levels count]) {
		[self initializeLayoutForLevel];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LEVEL_LAYOUT_PARSED" object:self userInfo:nil];
	}
}

- (BOOL) _savedLevel {
	return _savedLevel;
	
}
- (void) set_savedLevel:(BOOL)new_savedLevel {
	_savedLevel = new_savedLevel;
	NSMutableDictionary *profile = [self getProfile];
	profile[kGameDataSavedLevelKey] = @(_savedLevel);
	[self setProfile:profile];
}

- (NSMutableArray*) _savedLayout {
	return _savedLayout;
}

- (void) updateSavedLayout:(NSMutableArray*)newSavedLayout {
	if (_savedLayout) {
		[_savedLayout removeAllObjects];
	} else {
		_savedLayout = [[NSMutableArray alloc] init];
	}
	[_savedLayout addObjectsFromArray:newSavedLayout];
}

- (void) saveSavedLayout {
	NSMutableDictionary *profile = [self getProfile];
	profile[kGameDataSavedLayoutKey] = _savedLayout;
	[self setProfile:profile];
}

- (int) _savedMoves {
	return _savedMoves;
}
- (void) set_savedMoves:(int)new_savedMoves {
	_savedMoves = new_savedMoves;
	NSMutableDictionary *profile = [self getProfile];
	profile[kGameDataSavedMovesKey] = [NSNumber numberWithInt:_savedMoves];
	[self setProfile:profile];
}

- (int) _levelNum {
	return _levelNum;
}
- (void) set_levelNum:(int)new_levelNum {
	_levelNum = new_levelNum;
	NSMutableDictionary *profile = [self getProfile];
	profile[kGameDataLevelNumKey] = @(_levelNum);
	[self setProfile:profile];
}

- (int) _nextLevelNum {
	return _nextLevelNum;
}
- (void) set_nextLevelNum:(int)new_nextLevelNum {
	_nextLevelNum = new_nextLevelNum;
	NSMutableDictionary *profile = [self getProfile];
	profile[kGameDataNextLevelNumKey] = @(_nextLevelNum);
	[self setProfile:profile];
}

- (NSMutableArray*) _levels {
	return _levels;
}

- (NSDictionary*) getLevelDataForLevel:(int)levelNum {
	return _levels[levelNum];
}

- (NSDictionary*) getCurrentLevelData {
	return _levels[_levelNum];
}

- (void) setLevelDataForLevel:(int)levelNum levelData:(NSDictionary*)levelData {
	_levels[levelNum] = levelData;
}

- (void) updateLevels:(NSMutableArray*)newLevels {
	if (_levels) {
		[_levels removeAllObjects];
	} else {
		_levels = [[NSMutableArray alloc] init];
	}
	[_levels addObjectsFromArray:newLevels];
}

- (void) saveLevels {
	NSMutableDictionary *profile = [self getProfile];
	profile[kGameDataLevelsKey] = _levels;
	[self setProfile:profile];
}

#pragma mark -
#pragma mark NSXMLParser delegate methods

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kLevelElementName = @"Level";
static NSString * const kMovesAttributeName = @"leastMoves";
static NSString * const kRowElementName = @"Row";
static NSString * const kColumnElementName = @"Column";

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:kLevelElementName]) {
		_currentLeastMoves = [attributeDict[kMovesAttributeName] intValue];
	} else if ([elementName isEqualToString:kRowElementName]) {
		NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
		[_currentLayout addObject:emptyArray];
	} else if ([elementName isEqualToString:kColumnElementName]) {
		_accumulatingParsedCharacterData = YES;
		[_currentParsedCharacterData setString:@""];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:kLevelElementName]) {
	} else if ([elementName isEqualToString:kRowElementName]) {
	} else if ([elementName isEqualToString:kColumnElementName]) {
		[_currentLayout[[_currentLayout count]-1] addObject:[NSString stringWithString:_currentParsedCharacterData]];
	}
	
	// Stop accumulating parsed character data. We won't start again until specific elements begin.
    _accumulatingParsedCharacterData = NO;
}

// This method is called by the parser when it find parsed character data ("PCDATA") in an element. The parser is not
// guaranteed to deliver all of the parsed character data for an element in a single invocation, so it is necessary to
// accumulate character data until the end of the element is reached.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [_currentParsedCharacterData appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser*)parser {
	[self performSelectorOnMainThread:@selector(levelXMLParsed) withObject:nil waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
}

@end
