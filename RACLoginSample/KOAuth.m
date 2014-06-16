/*
 KOAuth
 MIT License
 https://github.com/Kelp404/KOAuth
 
 Fork from https://github.com/tweetdeck/TDOAuth Max Howell <max@tweetdeck.com>
 */

#import "KOAuth.h"
#import <CommonCrypto/CommonHMAC.h>

#if defined (__GNUC__) && (__GNUC__ >= 4)
#define KOAUTH_ATTRIBUTES(attr, ...) __attribute__((attr, ##__VA_ARGS__))
#else  // defined (__GNUC__) && (__GNUC__ >= 4)
#define KOAUTH_ATTRIBUTES(attr, ...)
#endif
#define KOAUTH_BURST_LINK static __inline__ KOAUTH_ATTRIBUTES(always_inline)


/*
 OAuth requires the UTC timestamp we send to be accurate. The user's device
 may not be, and often isn't. To work around this you should set this to the
 UTC timestamp that you get back in HTTP header from OAuth servers.
 */
#define KOAUTH_UTC_TIME_OFFSET 0



@implementation KOAuth

#pragma mark - Init
- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    self = [super init];
    if (self) {
        _params = @{@"oauth_consumer_key" : consumerKey,
                    @"oauth_nonce" : nonce(),
                    @"oauth_timestamp" : timestamp(),
                    @"oauth_version" : @"1.0",
                    @"oauth_signature_method" : @"HMAC-SHA1",
                    @"oauth_token" : accessToken ? : @""
                    };
        _signatureSecret = [NSString stringWithFormat:@"%@&%@", consumerSecret, tokenSecret ? : @"" ];
    }
    return self;
}

- (id)initForRequestTokenWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
    self = [super init];
    if (self) {
        _params = @{@"oauth_consumer_key" : consumerKey,
                    @"oauth_nonce" : nonce(),
                    @"oauth_timestamp" : timestamp(),
                    @"oauth_version" : @"1.0",
                    @"oauth_signature_method" : @"HMAC-SHA1",
                    @"oauth_callback" : @"oob"
                    };
        _signatureSecret = [NSString stringWithFormat:@"%@&%@", consumerSecret, @"" ];
    }
    return self;
}

- (id)initForAccessTokenWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret requestToken:(NSString *)requestToken tokenSecret:(NSString *)tokenSecret oauthVerfier:(NSString *)oauthVerfier
{
    self = [super init];
    if (self) {
        _params = @{@"oauth_consumer_key" : consumerKey,
                    @"oauth_nonce" : nonce(),
                    @"oauth_timestamp" : timestamp(),
                    @"oauth_version" : @"1.0",
                    @"oauth_signature_method" : @"HMAC-SHA1",
                    @"oauth_token" : requestToken ? : @"",
                    @"oauth_verifier" : oauthVerfier ? : @""
                    };
        _signatureSecret = [NSString stringWithFormat:@"%@&%@", consumerSecret, tokenSecret ? : @""  ];
    }
    return self;
}


#pragma mark - KOAuth alloc URLRequest
#pragma mark HTTP GET
+ (NSMutableURLRequest *)get:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    KOAuth *oauth = [[KOAuth alloc] initWithConsumerKey:consumerKey
                                         consumerSecret:consumerSecret
                                            accessToken:accessToken
                                            tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [oauth getRequestWittURL:url
                                                  andMethod:@"GET"
                                              andParameters:unencodedParameters];
    return request;
}
#pragma mark HTTP POST
+ (NSMutableURLRequest *)post:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    KOAuth *oauth = [[KOAuth alloc] initWithConsumerKey:consumerKey
                                         consumerSecret:consumerSecret
                                            accessToken:accessToken
                                            tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [oauth getRequestWittURL:url
                                                  andMethod:@"POST"
                                              andParameters:unencodedParameters];
	
    [request setHTTPBody:[oauth getUrlEncodedRequestBody]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    return request;
}
+ (NSMutableURLRequest *)post:(NSURL *)url jsonParameters:(id)parameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    KOAuth *oauth = [[KOAuth alloc] initWithConsumerKey:consumerKey
                                         consumerSecret:consumerSecret
                                            accessToken:accessToken
                                            tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [oauth getRequestWittURL:url
                                                  andMethod:@"POST"
                                              andParameters:parameters];
	
    [request setHTTPBody:[oauth getJSONRequestBody]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    return request;
}
#pragma mark HTTP PUT
+ (NSMutableURLRequest *)put:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    KOAuth *oauth = [[KOAuth alloc] initWithConsumerKey:consumerKey
                                         consumerSecret:consumerSecret
                                            accessToken:accessToken
                                            tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [oauth getRequestWittURL:url
                                                  andMethod:@"PUT"
                                              andParameters:unencodedParameters];
	
    [request setHTTPBody:[oauth getUrlEncodedRequestBody]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    return request;
}
+ (NSMutableURLRequest *)put:(NSURL *)url jsonParameters:(id)parameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    KOAuth *oauth = [[KOAuth alloc] initWithConsumerKey:consumerKey
                                         consumerSecret:consumerSecret
                                            accessToken:accessToken
                                            tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [oauth getRequestWittURL:url
                                                  andMethod:@"PUT"
                                              andParameters:parameters];
	
    [request setHTTPBody:[oauth getJSONRequestBody]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    return request;
}
#pragma mark HTTP DELETE
+ (NSMutableURLRequest *)delete:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    KOAuth *oauth = [[KOAuth alloc] initWithConsumerKey:consumerKey
                                         consumerSecret:consumerSecret
                                            accessToken:accessToken
                                            tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [oauth getRequestWittURL:url
                                                  andMethod:@"DELETE"
                                              andParameters:unencodedParameters];
	
    [request setHTTPBody:[oauth getUrlEncodedRequestBody]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    return request;
}
+ (NSMutableURLRequest *)delete:(NSURL *)url jsonParameters:(id)parameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    KOAuth *oauth = [[KOAuth alloc] initWithConsumerKey:consumerKey
                                         consumerSecret:consumerSecret
                                            accessToken:accessToken
                                            tokenSecret:tokenSecret];
    NSMutableURLRequest *request = [oauth getRequestWittURL:url
                                                  andMethod:@"DELETE"
                                              andParameters:parameters];
	
    [request setHTTPBody:[oauth getJSONRequestBody]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    return request;
}
#pragma mark request for request_token
+ (NSMutableURLRequest *)requestTokenWithUrl:(NSURL *)url consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
    KOAuth *oauth = [[KOAuth alloc] initForRequestTokenWithConsumerKey:consumerKey consumerSecret:consumerSecret];
    
	NSMutableURLRequest *rq = [oauth getRequestWittURL:url andMethod:@"POST"];
    return rq;
}
#pragma mark request for access_token
+ (NSMutableURLRequest *)accessTokenWithUrl:(NSURL *)url consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret requestToken:(NSString *)requestToken tokenSecret:(NSString *)tokenSecret oauthVerfier:(NSString *)oauthVerfier
{
    KOAuth *oauth = [[KOAuth alloc] initForAccessTokenWithConsumerKey:consumerKey
                                                       consumerSecret:consumerSecret
                                                         requestToken:requestToken
                                                          tokenSecret:tokenSecret
                                                         oauthVerfier:oauthVerfier];
	
    NSMutableURLRequest *rq = [oauth getRequestWittURL:url andMethod:@"POST"];
    return rq;
}


#pragma mark - Private ←↖↑↗→↘↓↙←↖↑↗→↘↓↙←↖↑↗→↘↓↙←↖↑↗→↘↓↙←↖↑↗→↘↓↙←↖↑↗→↘↓↙
#pragma mark - Generate Request
/**
 Generate request with oauth.
 @param url: request url
 @param method: http method
 @return: NSMutableURLRequest
 */
- (NSMutableURLRequest *)getRequestWittURL:(NSURL *)url andMethod:(NSString *)method
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:getAuthorization(url, method, _signatureSecret, _params, nil) forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:method];
    return request;
}
/**
 Generate request with oauth.
 @param url: request url
 @param method: http method
 @param parameters: query string or form data
 @return: NSMutableURLRequest
 */
- (NSMutableURLRequest *)getRequestWittURL:(NSURL *)url andMethod:(NSString *)method andParameters:(id)parameters
{
    _sourceParameters = parameters;
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        _encodedFormParameters = encodeDictionary(parameters);
    }
    
    if ([method isEqualToString:@"GET"] && _encodedFormParameters.count > 0) {
        NSString *queryString = getParametersString(_encodedFormParameters);
        if (queryString.length > 0) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", url.absoluteString, queryString]];
        }
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:getAuthorization(url, method, _signatureSecret, _params, _encodedFormParameters) forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:method];
    
    return request;
}
/**
 Get x-www-form-urlencoded form body.
 @return: NSData
 */
- (NSData *)getUrlEncodedRequestBody
{
    return [getParametersString(_encodedFormParameters) dataUsingEncoding:NSUTF8StringEncoding];
}
/**
 Get json form body.
 @return: NSData
 */
- (NSData *)getJSONRequestBody
{
    return [getJSON(_sourceParameters) dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark url encode dictionary
/**
 UrlEncode NSDictionary's key and value.
 */
KOAUTH_BURST_LINK NSDictionary *encodeDictionary(NSDictionary *source)
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:source.count];
    
    for (NSString *key in source.allKeys) {
        NSObject *value = [source objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
            [result setObject:urlEncode((NSString *)value) forKey:key];
        else if ([value isKindOfClass:[NSNumber class]])
            [result setObject:[(NSNumber *)value stringValue] forKey:key];
    }
    return result;
}
#pragma mark add parameters and get encoded string
/**
 Convert NSDictionary to x-www-form-urlencoded string.
 */
KOAUTH_BURST_LINK NSMutableString * getParametersString(NSDictionary *encodedParameters)
{
    NSMutableString *queryString = [NSMutableString new];
    for (NSString *key in encodedParameters.allKeys) {
        [queryString appendString:key];
        [queryString appendString:@"="];
        [queryString appendString:[encodedParameters objectForKey:key]];
        [queryString appendString:@"&"];
    }
    chomp(queryString);
    
    return queryString;
}
/**
 Convert NSDictionary to json.
 */
KOAUTH_BURST_LINK NSMutableString * getJSON(id parameters)
{
    NSMutableString *json = [NSMutableString new];
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        // NSDictionary
        [json appendString:@"{"];
        for (NSString *key in [(NSDictionary *)parameters allKeys]) {
            id value = [parameters objectForKey:key];
            if ([value isKindOfClass:[NSString class]])
                [json appendFormat:@"\"%@\":\"%@\",", key, [parameters objectForKey:key]];
            else if ([value isKindOfClass:[NSNumber class]])
                [json appendFormat:@"\"%@\":%@,", key, [parameters objectForKey:key]];
        }
        if (json.length > 1)
            [json deleteCharactersInRange:NSMakeRange(json.length - 1, 1)];
        [json appendString:@"}"];
    }
    else {  // NSArray
        [json appendString:@"["];
        for (id item in (NSArray *)parameters) {
            if ([item isKindOfClass:[NSString class]])
                [json appendFormat:@"\"%@\",", item];
            else if ([item isKindOfClass:[NSNumber class]])
                [json appendFormat:@"%@,", item];
        }
        if (json.length > 1)
            [json deleteCharactersInRange:NSMakeRange(json.length - 1, 1)];
        [json appendString:@"]"];
    }
    
    return json;
}


#pragma mark - Authorization
/**
 Generate Authorization header.
 @param url: request url
 @param method: http method
 @param secret: _signatureSecret
 @param params: _params
 @param encodedQueryParameters: url encoded query parameters
 @return: Authorization string
 */
KOAUTH_BURST_LINK NSString * getAuthorization(NSURL *url, NSString *method, NSString *secret, NSDictionary *params, NSDictionary *encodedQueryParameters)
{
    NSMutableString *header = [NSMutableString stringWithCapacity:512];
    [header appendString:@"OAuth "];
    for (NSString *key in params.allKeys) {
        [header appendString:key];
        [header appendString:@"=\""];
        [header appendString:[params objectForKey:key]];
        [header appendString:@"\", "];
    }
    [header appendString:@"oauth_signature=\""];
    [header appendString:urlEncode(signatureWithURL(url, method, secret, params, encodedQueryParameters))];
    [header appendString:@"\""];
    return header;
}
/**
 Generate oauth signature.
 @param url: request url
 @param method: http method
 @param signatureSecret: _signatureSecret
 @param params: _params
 @param encodedQueryParameters: url encoded query parameters
 @return: oauth signature
 */
KOAUTH_BURST_LINK NSString *signatureWithURL(NSURL *url, NSString *method, NSString *signatureSecret, NSDictionary *params, NSDictionary *encodedQueryParameters)
{
    NSData *signbase = [signatureBase(params, encodedQueryParameters, method, url) dataUsingEncoding:NSUTF8StringEncoding];
    NSData *secret = [signatureSecret dataUsingEncoding:NSUTF8StringEncoding];
	
    uint8_t digest[20] = {0};
    CCHmacContext cx;
    CCHmacInit(&cx, kCCHmacAlgSHA1, secret.bytes, secret.length);
    CCHmacUpdate(&cx, signbase.bytes, signbase.length);
    CCHmacFinal(&cx, digest);
    
    return base64(digest);
}
/**
 Generate sign base string.
 @param params: _params
 @param queryParams: _queryParams
 @param method: http method
 @param url: request url
 @return: sign base string
 */
KOAUTH_BURST_LINK NSString *signatureBase(NSDictionary *params, NSDictionary *queryParams, NSString *method, NSURL *url)
{
    NSMutableString *param = [NSMutableString stringWithCapacity:256];
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [finalParams addEntriesFromDictionary:queryParams];
    
    NSArray *keys = [[finalParams allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        [param appendString:urlEncode(key)];
        [param appendString:@"="];
        [param appendString:[finalParams objectForKey:key]];
        [param appendString:@"&"];
    }
    
    chomp(param);
    
	NSMutableString *result = [NSMutableString stringWithCapacity:256];
    [result appendFormat:@"%@&", method];
    [result appendString:url.scheme.lowercaseString];
    [result appendString:@"%3A%2F%2F"];  // @"://"
    [result appendString:urlEncode(url.host)];
    if (url.port) {
        [result appendFormat:@"%%3A%@", url.port];  // :80
    }
    if (url.path) {
        [result appendString:urlEncode(url.path)];
    }
    if (param.length > 0) {
        [result appendFormat:@"&%@", urlEncode(param)];
    }
	return result;
}


#pragma mark - Shared functions
/**
 UrlEncode (OAuth mode).
 @param source: data source
 @return: url encoded string
 */
KOAUTH_BURST_LINK NSString *urlEncode(NSString *source)
{
    CFStringRef cfstring = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) source, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSString *result = [NSString stringWithString:(__bridge NSString *)cfstring];
    CFRelease(cfstring);
    return result;
}

/**
 Remove the last char of source string.
 */
KOAUTH_BURST_LINK void chomp(NSMutableString *source)
{
    if (source.length > 0)
        [source deleteCharactersInRange:NSMakeRange(source.length - 1, 1)];
}

/**
 Genreate nonce.
 @return: 5 chars nonce string
 */
KOAUTH_BURST_LINK NSString *nonce()
{
    static const char map[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char *buffer = malloc(6);
    NSUInteger selector;
    for (NSUInteger index = 0; index < 5; index++) {
        selector = arc4random() % 62;
        buffer[index] = map[selector];
    }
    buffer[5] = '\0';
    NSString *result = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
    free(buffer);
    
    return result;
}

/**
 Generate time stamp.
 @return: time stamp string
 */
KOAUTH_BURST_LINK NSString *timestamp()
{
    time_t t;
    time(&t);
    mktime(gmtime(&t));
    return [NSString stringWithFormat:@"%lu", t + KOAUTH_UTC_TIME_OFFSET];
}

/**
 Convert array to base64 string.
 If your input string isn't 20 characters this won't work.
 @param input: [uint8_t]
 @return: base64 string
 */
KOAUTH_BURST_LINK NSString *base64(const uint8_t *input)
{
    static const char map[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
    NSMutableData *data = [NSMutableData dataWithLength:28];
    uint8_t *dataUnit = (uint8_t*) data.mutableBytes;
	
    for (NSInteger i = 0; i < 20;) {
        NSInteger v  = 0;
        for (NSInteger n = i + 3; i < n; i++) {
            v <<= 8;
            v |= 0xFF & input[i];
        }
        *dataUnit++ = map[v >> 18 & 0x3F];
        *dataUnit++ = map[v >> 12 & 0x3F];
        *dataUnit++ = map[v >> 6 & 0x3F];
        *dataUnit++ = map[v >> 0 & 0x3F];
    }
    dataUnit[-2] = map[(input[19] & 0x0F) << 2];
    dataUnit[-1] = '=';
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


@end