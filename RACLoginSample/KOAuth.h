/*
 KOAuth
 MIT License
 https://github.com/Kelp404/KOAuth
 
 Fork from https://github.com/tweetdeck/TDOAuth Max Howell <max@tweetdeck.com>
 */

#import <Foundation/Foundation.h>


/*
 This OAuth implementation doesn't cover the whole spec (eg. it’s HMAC only).
 But you'll find it works with almost all the OAuth implementations you need
 to interact with in the wild. How ace is that?!
 */
@interface KOAuth : NSObject {
    NSString *_signatureSecret;
    NSDictionary *_params; // these are pre-percent encoded
    NSDictionary *_encodedFormParameters;
    id _sourceParameters;
}

// *all keys of parameters should be NSString*
// *all values of parameters should be NSString or NSNumber*
/**
 Generate a NSMutableURLRequest instance with oauth for HTTP GET.
 @param url: http/https url
 @param unencodedParameters: http get parameters
 @param consumerKey
 @param consumerSecret
 @param accessToken
 @param tokenSecret
 @return: NSMutableURLRequest
 */
+ (NSMutableURLRequest *)get:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;
/**
 Generate a NSMutableURLRequest instance with oauth for HTTP POST.
 @param url: http/https url
 @param unencodedParameters: http post parameters
 @param consumerKey
 @param consumerSecret
 @param accessToken
 @param tokenSecret
 @return: NSMutableURLRequest
 */
+ (NSMutableURLRequest *)post:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;
/**
 Generate a NSMutableURLRequest instance with oauth for HTTP POST.
 @param url: http/https url
 @param unencodedParameters: http post parameters (NSArray or NSDictionary)
 @param consumerKey
 @param consumerSecret
 @param accessToken
 @param tokenSecret
 @return: NSMutableURLRequest
 */
+ (NSMutableURLRequest *)post:(NSURL *)url jsonParameters:(id)parameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;
/**
 Generate a NSMutableURLRequest instance with oauth for HTTP PUT.
 @param url: http/https url
 @param unencodedParameters: http put parameters
 @param consumerKey
 @param consumerSecret
 @param accessToken
 @param tokenSecret
 @return: NSMutableURLRequest
 */
+ (NSMutableURLRequest *)put:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;
/**
 Generate a NSMutableURLRequest instance with oauth for HTTP PUT.
 @param url: http/https url
 @param unencodedParameters: http put parameters (NSArray or NSDictionary)
 @param consumerKey
 @param consumerSecret
 @param accessToken
 @param tokenSecret
 @return: NSMutableURLRequest
 */
+ (NSMutableURLRequest *)put:(NSURL *)url jsonParameters:(id)parameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;
/**
 Generate a NSMutableURLRequest instance with oauth for HTTP DELETE.
 @param url: http/https url
 @param unencodedParameters: http delete parameters
 @param consumerKey
 @param consumerSecret
 @param accessToken
 @param tokenSecret
 @return: NSMutableURLRequest
 */
+ (NSMutableURLRequest *)delete:(NSURL *)url parameters:(NSDictionary *)unencodedParameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;
/**
 Generate a NSMutableURLRequest instance with oauth for HTTP DELETE.
 @param url: http/https url
 @param unencodedParameters: http delete parameters (NSArray or NSDictionary)
 @param consumerKey
 @param consumerSecret
 @param accessToken
 @param tokenSecret
 @return: NSMutableURLRequest
 */
+ (NSMutableURLRequest *)delete:(NSURL *)url jsonParameters:(id)parameters consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;

// request for request_token
+ (NSMutableURLRequest *)requestTokenWithUrl:(NSURL *)url consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;
// request for access_token
+ (NSMutableURLRequest *)accessTokenWithUrl:(NSURL *)url consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret requestToken:(NSString *)requestToken tokenSecret:(NSString *)tokenSecret oauthVerfier:(NSString *)oauthVerfier;

@end
