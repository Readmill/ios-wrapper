//
//  ReadmillAPIConfiguration.m
//  ReadmillAPI
//
//  Created by Martin Hwasser on 10/31/11.
//  Copyright (c) 2011 Readmill Network LTD. All rights reserved.
//

#import "ReadmillAPIConfiguration.h"

@implementation ReadmillAPIConfiguration

- (id)initWithClientID:(NSString *)aClientID clientSecret:(NSString *)aClientSecret redirectURL:(NSURL *)aRedirectURL apiBaseURL:(NSURL *)anApiBaseURL authURL:(NSURL *)anAuthURL 
{    
    NSAssert(aClientID, @"No Client ID supplied");
	NSAssert(aClientSecret, @"No Client Secret supplied");
    NSAssert(anApiBaseURL, @"No Api Base URL supplied");
    NSAssert(anAuthURL, @"No Auth URL supplied");
	
	if (self = [super init]) {
        
        _accessTokenURL = [[NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/token.json", [anAuthURL absoluteString]]] retain];

		_apiBaseURL = [anApiBaseURL retain];
		_authURL = [anAuthURL retain];
		
		_clientID = [aClientID copy];
		_clientSecret = [aClientSecret copy];
		_redirectURL = [aRedirectURL retain];
        
	}
	return self;
}

+ (id)configurationForProductionWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURL:(NSURL *)redirectURL 
{
	return [[[self alloc] initWithClientID:clientID
                             clientSecret:clientSecret
                              redirectURL:redirectURL
                               apiBaseURL:[NSURL URLWithString:kLiveAPIEndPoint]
                                  authURL:[NSURL URLWithString:kLiveAuthorizationUri]] 
             autorelease];
}

+ (id)configurationForStagingWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret redirectURL:(NSURL *)redirectURL 
{
    return [[[self alloc] initWithClientID:clientID
                             clientSecret:clientSecret
                              redirectURL:redirectURL
                               apiBaseURL:[NSURL URLWithString:kStagingAPIEndPoint]
                                  authURL:[NSURL URLWithString:kStagingAuthorizationUri]]
             autorelease];
}

-(void)dealloc 
{
    [_accessTokenURL release]; _accessTokenURL = nil;
	[_apiBaseURL release]; _apiBaseURL = nil;
	[_authURL release]; _authURL = nil;
	
	[_clientID release]; _clientID = nil;
	[_clientSecret release]; _clientSecret = nil;
	[_redirectURL release]; _redirectURL = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark - Synthesize

@synthesize apiBaseURL = _apiBaseURL;
@synthesize accessTokenURL = _accessTokenURL;
@synthesize authURL = _authURL;

@synthesize clientID = _clientID;
@synthesize clientSecret = _clientSecret;
@synthesize redirectURL = _redirectURL;

#pragma mark - 
#pragma mark - NSCoding

static NSString * const kReadmillAPIConfigurationAccessTokenURLKey = @"accessTokenURL";
static NSString * const kReadmillAPIConfigurationAPIBaseURLKey = @"apiBaseURL";
static NSString * const kReadmillAPIConfigurationAuthURLKey = @"authURL";
static NSString * const kReadmillAPIConfigurationClientIDKey = @"clientID";
static NSString * const kReadmillAPIConfigurationClientSecretKey = @"clientSecret";
static NSString * const kReadmillAPIConfigurationRedirectURLKey = @"redirectURL";

- (void)encodeWithCoder:(NSCoder *)aCoder 
{
    [aCoder encodeObject:[[self accessTokenURL] absoluteString] forKey:kReadmillAPIConfigurationAccessTokenURLKey];
    [aCoder encodeObject:[[self apiBaseURL] absoluteString] forKey:kReadmillAPIConfigurationAPIBaseURLKey];
    [aCoder encodeObject:[[self authURL] absoluteString] forKey:kReadmillAPIConfigurationAuthURLKey];
    [aCoder encodeObject:[self clientID] forKey:kReadmillAPIConfigurationClientIDKey];
    [aCoder encodeObject:[self clientSecret] forKey:kReadmillAPIConfigurationClientSecretKey];
    [aCoder encodeObject:[[self redirectURL] absoluteString] forKey:kReadmillAPIConfigurationRedirectURLKey];
}
- (id)initWithCoder:(NSCoder *)aDecoder 
{
    self = [super init];
    if (self) {
        [self setAccessTokenURL:[NSURL URLWithString:[aDecoder decodeObjectForKey:kReadmillAPIConfigurationAccessTokenURLKey]]];
        [self setApiBaseURL:[NSURL URLWithString:[aDecoder decodeObjectForKey:kReadmillAPIConfigurationAPIBaseURLKey]]];
        [self setAuthURL:[NSURL URLWithString:[aDecoder decodeObjectForKey:kReadmillAPIConfigurationAuthURLKey]]];
        [self setClientID:[aDecoder decodeObjectForKey:kReadmillAPIConfigurationClientIDKey]];
        [self setClientSecret:[aDecoder decodeObjectForKey:kReadmillAPIConfigurationClientSecretKey]];
        [self setRedirectURL:[NSURL URLWithString:[aDecoder decodeObjectForKey:kReadmillAPIConfigurationRedirectURLKey]]];
    }
    return self;
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"ReadmillAPIConfiguration: %@, with endPoint: %@, clientID: %@", [super description], [self apiBaseURL], [self clientID]];
}

@end
