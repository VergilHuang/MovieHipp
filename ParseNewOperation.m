//
//  ParseNewOperation.m
//  MovieUpdater
//
//  Created by 黃彥竣 on 2015/1/30.
//  Copyright (c) 2015年 self. All rights reserved.
//

#import "ParseNewOperation.h"
#import "Movie.h"

#pragma mark - notification constants

NSString *kAddMovieNotificationName2 = @"MovieNotificationName2";
NSString *kMovieResultsKey2 = @"MovieResultskey2";
NSString *kMovieErrorNotificationName2 = @"MovieErrorNotificationName2";
NSString *kMovieMessageErrorKey2 = @"MovieMessageErrorKey2";

#pragma mark - parse constants

static const NSUInteger kMaximumOfMoviesToParse = 30;

static const NSUInteger kSizeOfMoiveBatch = 10;

static NSString *kElementNameItem = @"item";
static NSString *kElementNameTitle = @"title";
static NSString *kElementNamelink = @"link";
static NSString *kElementNameEnclosure = @"enclosure";
static NSString *kElementNamePubdate = @"description";



@interface ParseNewOperation ()<NSXMLParserDelegate>
@property (nonatomic,strong) Movie *currentMovieObject;
@property (nonatomic,strong) NSMutableArray *currentParseBitchArray;
@property (nonatomic,strong) NSMutableString *currentParseCharacterDataStr;

@end

@implementation ParseNewOperation{
    BOOL accumulatingParsedCharacterData;
    BOOL didAbortParsing;
    NSInteger parseMovieCounter;
}

- (id)initWithData:(NSData *)ParseData{
    self = [super init];
    if (self) {
        _movieData = [ParseData copy];
        _currentParseBitchArray = [[NSMutableArray alloc] init];
        _currentParseCharacterDataStr = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)addMovieToList:(NSArray *)movies{
    assert([NSThread mainThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddMovieNotificationName2 object:self userInfo:@{kMovieResultsKey2 : movies}];
    
}

- (void)activeAddMovie{
    
}
#pragma mark - main function

- (void)main{
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.movieData];
    
    parser.delegate = self;
    [parser parse];
    
    if ([self.currentParseBitchArray count] > 0) {
        [self performSelectorOnMainThread:@selector(addMovieToList:) withObject:self.currentParseBitchArray waitUntilDone:NO];    }
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict{
    if (parseMovieCounter > kMaximumOfMoviesToParse) {
        didAbortParsing = YES;
        [parser abortParsing];
    }
    if ([elementName isEqualToString:kElementNameItem]) {
        Movie *movie = [[Movie alloc] init];
        self.currentMovieObject = movie;
    }
    if ([elementName isEqualToString:kElementNameEnclosure]){
        NSString *urlAttribute = [attributeDict valueForKey:@"url"];
        NSURL *imageUrl = [NSURL URLWithString:urlAttribute];
        self.currentMovieObject.imageUrl = imageUrl;
    }
    if ([elementName isEqualToString:kElementNameTitle] || [elementName isEqualToString:kElementNamelink] || [elementName isEqualToString:kElementNamePubdate]){
        accumulatingParsedCharacterData = YES;
        
        [self.currentParseCharacterDataStr setString:@""];
        
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:kElementNameItem]) {
        
        [self.currentParseBitchArray addObject:self.currentMovieObject];
        parseMovieCounter ++;
        if (self.currentParseBitchArray.count >= kSizeOfMoiveBatch) {
            [self performSelectorOnMainThread:@selector(addMovieToList:) withObject:self.currentParseBitchArray waitUntilDone:NO];
            self.currentParseBitchArray = [NSMutableArray array];
        }
    }
    if ([elementName isEqualToString:kElementNameTitle]){
        
        if ([self.currentParseCharacterDataStr isEqualToString:@"Yahoo!奇摩電影-預告片榜"]) {
            NSLog(@"title 輸出正常2");
        }else{
            self.currentMovieObject.movieName = [self.currentParseCharacterDataStr copy];
            
        }
    }
    if ([elementName isEqualToString:kElementNamelink]){
        NSScanner *scanner = [NSScanner scannerWithString:self.currentParseCharacterDataStr];
        if ([scanner scanString:@"https://tw.rd.yahoo.com/referurl/movie/hp/rss/news/*" intoString:NULL]) {
            NSString *linkUrlStr = nil;
            if ([scanner scanUpToCharactersFromSet:[NSCharacterSet illegalCharacterSet] intoString:&linkUrlStr]) {
                NSURL *linkUrl = [NSURL URLWithString:linkUrlStr];
                self.currentMovieObject.linkUrl = linkUrl;
            }
        }
    }
    if ([elementName isEqualToString:kElementNamePubdate]){
        
        self.currentMovieObject.descriptions = [self.currentParseCharacterDataStr copy];
    }
    
    accumulatingParsedCharacterData = NO;
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string{
    
    if (accumulatingParsedCharacterData) {
        [self.currentParseCharacterDataStr appendString:string];
    }
}

- (void)handleMovieError:(NSError *)parseError{
    assert([NSThread mainThread]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kMovieErrorNotificationName2 object:self userInfo:@{kMovieMessageErrorKey2 : parseError}];
}

- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError{
    if ([parseError code] != NSXMLParserDelegateAbortedParseError || !didAbortParsing) {
        [self performSelectorOnMainThread:@selector(handleMovieError:) withObject:parseError waitUntilDone:NO];
    }
}



@end

