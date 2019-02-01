//
//  nuggAdLib.m
//  nuggAdLib
//
//  Created by Benjamin Müller on 05.09.12.
//  Copyright (c) 2012 urbn. All rights reserved.
//

#import "NuggAdPrediction.h"
#import "NuggAdPermission.h"
#import "NuggAdService.h"
#import "NuggAdUTProduct.h"
#import "NuggAdSurveyViewController.h"

NSString *const NUGG_AD_CONTENT_Name[content_count] = {
    
    [NUGG_AD_TG_CONTENT_NONE] = nil,
    
    [NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_AUDIO] = @"CONSUMER_ELECTRONIC_AUDIO",
    
    [NUGG_AD_TG_CONTENT_COMPUTER_HARDWARE] = @"COMPUTER_HARDWARE",
    
    [NUGG_AD_TG_CONTENT_COMPUTER_SOFTWARE_NON_GAMES] = @"COMPUTER_SOFTWARE_NON_GAMES",
    
    [NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_COMPUTER] = @"CONSUMER_ELECTRONIC_COMPUTER",
    
    [NUGG_AD_TG_CONTENT_HARDWARE_HARDWARE_EQUIPMENT] = @"HARDWARE_HARDWARE_EQUIPMENT",
    
    [NUGG_AD_TG_CONTENT_DEVICES_NOTEBOOK] = @"DEVICES_NOTEBOOK",
    
    [NUGG_AD_TG_CONTENT_DEVICES_PC] = @"DEVICES_PC",
    
    [NUGG_AD_TG_CONTENT_DEVICES_TABLETS_GADGETS] = @"DEVICES_TABLETS_GADGETS",
    
    [NUGG_AD_TG_CONTENT_CELL_PHONE_EQUIPMENT] = @"CELL_PHONE_EQUIPMENT",
    
    [NUGG_AD_TG_CONTENT_CELL_PHONE_DEVICES] = @"CELL_PHONE_DEVICES",
    
    [NUGG_AD_TG_CONTENT_CELL_PHONE] = @"CELL_PHONE",
    
    [NUGG_AD_TG_CONTENT_PHOTO] = @"PHOTO",
    
    [NUGG_AD_TG_CONTENT_PHOTO_DEVICES] = @"PHOTO_DEVICES",
    
    [NUGG_AD_TG_CONTENT_PHOTO_EQUIPMENT] = @"PHOTO_EQUIPMENT",
    
    [NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_TV] = @"CONSUMER_ELECTRONIC_TV",
    
    [NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_TV_EQUIPMENT] = @"CONSUMER_ELECTRONIC_TV_EQUIPMENT",
    
    [NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC] = @"CONSUMER_ELECTRONIC",
    
    [NUGG_AD_TG_CONTENT_DATING] = @"DATING",
    
    [NUGG_AD_TG_CONTENT_ENTERTAINMENT_CHAT] = @"ENTERTAINMENT_CHAT",
    
    [NUGG_AD_TG_CONTENT_ENTERTAINMENT_HOROSCOPE] = @"ENTERTAINMENT_HOROSCOPE",
    
    [NUGG_AD_TG_CONTENT_LOTTERY] = @"LOTTERY",
    
    [NUGG_AD_TG_CONTENT_ENTERTAINMENT_HUMOUR] = @"ENTERTAINMENT_HUMOUR",
    
    [NUGG_AD_TG_CONTENT_LOTTERY_SPORTS_BETTING] = @"LOTTERY_SPORTS_BETTING",
    
    [NUGG_AD_TG_CONTENT_ENTERTAINMENT_QUIZ] = @"ENTERTAINMENT_QUIZ",
    
    [NUGG_AD_TG_CONTENT_ENTERTAINMENT] = @"ENTERTAINMENT",
    
    [NUGG_AD_TG_CONTENT_EROTIC] = @"EROTIC",
    
    [NUGG_AD_TG_CONTENT_BEAUTY_AND_CARE] = @"BEAUTY_AND_CARE",
    
    [NUGG_AD_TG_CONTENT_FASHION] = @"FASHION",
    
    [NUGG_AD_TG_CONTENT_FASHION_FASHION_MEN] = @"FASHION_FASHION_MEN",
    
    [NUGG_AD_TG_CONTENT_FASHION_FASHION_WOMEN] = @"FASHION_FASHION_WOMEN",
    
    [NUGG_AD_TG_CONTENT_HEALTH] = @"HEALTH",
    
    [NUGG_AD_TG_CONTENT_HEALTH_PSYCHOLOGY] = @"HEALTH_PSYCHOLOGY",
    
    [NUGG_AD_TG_CONTENT_FASHION_AND_BEAUTY] = @"FASHION_AND_BEAUTY",
    
    [NUGG_AD_TG_CONTENT_FAMILY_KIDS] = @"FAMILY_KIDS",
    
    [NUGG_AD_TG_CONTENT_FAMILY] = @"FAMILY",
    
    [NUGG_AD_TG_CONTENT_COOKING] = @"COOKING",
    
    [NUGG_AD_TG_CONTENT_FURNITURE] = @"FURNITURE",
    
    [NUGG_AD_TG_CONTENT_FURNISHING] = @"FURNISHING",
    
    [NUGG_AD_TG_CONTENT_GARDEN] = @"GARDEN",
    
    [NUGG_AD_TG_CONTENT_GROCERIES] = @"GROCERIES",
    
    [NUGG_AD_TG_CONTENT_HOME_IMPROVEMENT] = @"HOME_IMPROVEMENT",
    
    [NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_HOUSEHOLD] = @"HOME_AND_GARDEN_HOUSEHOLD",
    
    [NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_INSURANCE] = @"HOME_AND_GARDEN_INSURANCE",
    
    [NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_PETS] = @"HOME_AND_GARDEN_PETS",
    
    [NUGG_AD_TG_CONTENT_RATES] = @"RATES",
    
    [NUGG_AD_TG_CONTENT_RATES_TELECOM] = @"RATES_TELECOM",
    
    [NUGG_AD_TG_CONTENT_RATES_MOBILE_PHONE] = @"RATES_MOBILE_PHONE",
    
    [NUGG_AD_TG_CONTENT_RATES_LANDLINE_PHONE] = @"RATES_LANDLINE_PHONE",
    
    [NUGG_AD_TG_CONTENT_RATES_INTERNET_ACCESS] = @"RATES_INTERNET_ACCESS",
    
    [NUGG_AD_TG_CONTENT_RATES_ELECTRICITY] = @"RATES_ELECTRICITY",
    
    [NUGG_AD_TG_CONTENT_RATES_GAS] = @"RATES_GAS",
    
    [NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_ADVICE_AND_CONSULTING] = @"HOME_AND_GARDEN_ADVICE_AND_CONSULTING",
    
    [NUGG_AD_TG_CONTENT_HOME_AND_GARDEN] = @"HOME_AND_GARDEN",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_ECONOMY] = @"INFO_NEWS_ECONOMY",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_WARRANTS_AND_OPTIONS] = @"INFO_NEWS_WARRANTS_AND_OPTIONS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_CREDITS_AND_LOANS] = @"INFO_NEWS_CREDITS_AND_LOANS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_FINANCE] = @"INFO_NEWS_FINANCE",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_KNOWLEDGE] = @"INFO_NEWS_KNOWLEDGE",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS] = @"INFO_NEWS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_POLITICS] = @"INFO_NEWS_POLITICS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_REGIONAL] = @"INFO_NEWS_REGIONAL",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_INTERNAL_POLICY] = @"INFO_NEWS_INTERNAL_POLICY",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_FOREIGN_POLICY] = @"INFO_NEWS_FOREIGN_POLICY",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_SOCIETY] = @"INFO_NEWS_SOCIETY",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_SOCIETY_VIPS] = @"INFO_NEWS_SOCIETY_VIPS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_SPORTS] = @"INFO_NEWS_SPORTS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_MOTORSPORTS] = @"INFO_NEWS_MOTORSPORTS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_BOXING] = @"INFO_NEWS_BOXING",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_GOLF] = @"INFO_NEWS_GOLF",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_TENNIS] = @"INFO_NEWS_TENNIS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_TREND_SPORTS] = @"INFO_NEWS_TREND_SPORTS",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_FOOTBALL] = @"INFO_NEWS_FOOTBALL",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_FOOTBALL_LEAGUES] = @"INFO_NEWS_FOOTBALL_LEAGUES",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_FOOTBALL_INTERNATIONAL] = @"INFO_NEWS_FOOTBALL_INTERNATIONAL",
    
    [NUGG_AD_TG_CONTENT_INFO_NEWS_SPORT_OTHER] = @"INFO_NEWS_SPORT_OTHER",
    
    [NUGG_AD_TG_CONTENT_ART] = @"ART",
    
    [NUGG_AD_TG_CONTENT_WEATHER] = @"WEATHER",
    
    [NUGG_AD_TG_CONTENT_BOOKS_COMIC] = @"BOOKS_COMIC",
    
    [NUGG_AD_TG_CONTENT_LIFESTYLE_AND_LEISURE_BOOKS] = @"LIFESTYLE_AND_LEISURE_BOOKS",
    
    [NUGG_AD_TG_CONTENT_COMPUTER_GAMES_CONSOLE] = @"COMPUTER_GAMES_CONSOLE",
    
    [NUGG_AD_TG_CONTENT_COMPUTER_GAMES] = @"COMPUTER_GAMES",
    
    [NUGG_AD_TG_CONTENT_EDUCATION_UNIVERSITY] = @"EDUCATION_UNIVERSITY",
    
    [NUGG_AD_TG_CONTENT_EDUCATION_SCHOOL] = @"EDUCATION_SCHOOL",
    
    [NUGG_AD_TG_CONTENT_EDUCATION] = @"EDUCATION",
    
    [NUGG_AD_TG_CONTENT_EVENTS] = @"EVENTS",
    
    [NUGG_AD_TG_CONTENT_GASTRONOMY_RESTAURANTS] = @"GASTRONOMY_RESTAURANTS",
    
    [NUGG_AD_TG_CONTENT_GASTRONOMY_CLUBBING] = @"GASTRONOMY_CLUBBING",
    
    [NUGG_AD_TG_CONTENT_GASTRONOMY] = @"GASTRONOMY",
    
    [NUGG_AD_TG_CONTENT_MOVIES] = @"MOVIES",
    
    [NUGG_AD_TG_CONTENT_RADIO] = @"RADIO",
    
    [NUGG_AD_TG_CONTENT_MUSIC_ROCK] = @"MUSIC_ROCK",
    
    [NUGG_AD_TG_CONTENT_MUSIC_POP] = @"MUSIC_POP",
    
    [NUGG_AD_TG_CONTENT_MUSIC_CLASSICAL_MUSIC] = @"MUSIC_CLASSICAL_MUSIC",
    
    [NUGG_AD_TG_CONTENT_MUSIC_HIPHOP] = @"MUSIC_HIPHOP",
    
    [NUGG_AD_TG_CONTENT_MUSIC_MUSIC_INSTRUMENTS] = @"MUSIC_MUSIC_INSTRUMENTS",
    
    [NUGG_AD_TG_CONTENT_MUSIC_REGGAE] = @"MUSIC_REGGAE",
    
    [NUGG_AD_TG_CONTENT_MUSIC_ELECTRO] = @"MUSIC_ELECTRO",
    
    [NUGG_AD_TG_CONTENT_MUSIC_BLUES_JAZZ] = @"MUSIC_BLUES_JAZZ",
    
    [NUGG_AD_TG_CONTENT_MUSIC_AUDIO_BOOK] = @"MUSIC_AUDIO_BOOK",
    
    [NUGG_AD_TG_CONTENT_MUSIC_SONGS_CHILDREN] = @"MUSIC_SONGS_CHILDREN",
    
    [NUGG_AD_TG_CONTENT_MUSIC] = @"MUSIC",
    
    [NUGG_AD_TG_CONTENT_SPORTS_EQUIPMENT] = @"SPORTS_EQUIPMENT",
    
    [NUGG_AD_TG_CONTENT_SPORTS_ACCESSORIES] = @"SPORTS_ACCESSORIES",
    
    [NUGG_AD_TG_CONTENT_SPORTS_EQUIPMENT_BIKE] = @"SPORTS_EQUIPMENT_BIKE",
    
    [NUGG_AD_TG_CONTENT_SPORTS_OUTDOOR] = @"SPORTS_OUTDOOR",
    
    [NUGG_AD_TG_CONTENT_LIFESTYLE_AND_LEISURE] = @"LIFESTYLE_AND_LEISURE",
    
    [NUGG_AD_TG_CONTENT_MARKET_PLACE_JOBS] = @"MARKET_PLACE_JOBS",
    
    [NUGG_AD_TG_CONTENT_MARKET_PLACE_REAL] = @"MARKET_PLACE_REAL",
    
    [NUGG_AD_TG_CONTENT_MARKET_PLACE] = @"MARKET_PLACE",
    
    [NUGG_AD_TG_CONTENT_SERVICE_CUSTOMER_SERVICE] = @"SERVICE_CUSTOMER_SERVICE",
    
    [NUGG_AD_TG_CONTENT_SERVICE_DIRECTORIES] = @"SERVICE_DIRECTORIES",
    
    [NUGG_AD_TG_CONTENT_SERVICE_OBLIGATORY] = @"SERVICE_OBLIGATORY",
    
    [NUGG_AD_TG_CONTENT_TV_COMEDY] = @"TV_COMEDY",
    
    [NUGG_AD_TG_CONTENT_TV_DRAMA] = @"TV_DRAMA",
    
    [NUGG_AD_TG_CONTENT_TV_MYSTERY] = @"TV_MYSTERY",
    
    [NUGG_AD_TG_CONTENT_TV_HORROR] = @"TV_HORROR",
    
    [NUGG_AD_TG_CONTENT_TV_THRILLER] = @"TV_THRILLER",
    
    [NUGG_AD_TG_CONTENT_TV_ACTION] = @"TV_ACTION",
    
    [NUGG_AD_TG_CONTENT_TV_SF_F] = @"TV_SF_F",
    
    [NUGG_AD_TG_CONTENT_TV_WESTERN] = @"TV_WESTERN",
    
    [NUGG_AD_TG_CONTENT_TV_EROTIC] = @"TV_EROTIC",
    
    [NUGG_AD_TG_CONTENT_TV_DOCUMENTARY] = @"TV_DOCUMENTARY",
    
    [NUGG_AD_TG_CONTENT_TV_LIFESTYLE_MAGAZINES] = @"TV_LIFESTYLE_MAGAZINES",
    
    [NUGG_AD_TG_CONTENT_TV_SHOW] = @"TV_SHOW",
    
    [NUGG_AD_TG_CONTENT_TV_TALK_SHOWS] = @"TV_TALK_SHOWS",
    
    [NUGG_AD_TG_CONTENT_TV_TV_PROGRAMME] = @"TV_TV_PROGRAMME",
    
    [NUGG_AD_TG_CONTENT_TV_TV_SERIES] = @"TV_TV_SERIES",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_COMEDY] = @"TV_SERIES_COMEDY",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_WOMEN] = @"TV_SERIES_WOMEN",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_THRILLER] = @"TV_SERIES_THRILLER",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_MYSTERY] = @"TV_SERIES_MYSTERY",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_DRAMA] = @"TV_SERIES_DRAMA",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_HORROR] = @"TV_SERIES_HORROR",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_ACTION] = @"TV_SERIES_ACTION",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_SF_F] = @"TV_SERIES_SF_F",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_WESTERN] = @"TV_SERIES_WESTERN",
    
    [NUGG_AD_TG_CONTENT_TV_SERIES_EROTIC] = @"TV_SERIES_EROTIC",
    
    [NUGG_AD_TG_CONTENT_TELEVISION] = @"TELEVISION",
    
    [NUGG_AD_TG_CONTENT_TRAVEL_ACCOMODATIONS] = @"TRAVEL_ACCOMODATIONS",
    
    [NUGG_AD_TG_CONTENT_TRAVEL_BOOKING] = @"TRAVEL_BOOKING",
    
    [NUGG_AD_TG_CONTENT_TRAVEL_CAR_RENTAL] = @"TRAVEL_CAR_RENTAL",
    
    [NUGG_AD_TG_CONTENT_TRAVEL_LAST_MINUTE] = @"TRAVEL_LAST_MINUTE",
    
    [NUGG_AD_TG_CONTENT_TRAVEL_ROUTE_PLANNER] = @"TRAVEL_ROUTE_PLANNER",
    
    [NUGG_AD_TG_CONTENT_TRAVEL_TICKETS] = @"TRAVEL_TICKETS",
    
    [NUGG_AD_TG_CONTENT_TRAVEL_TRAVEL_PLANNING] = @"TRAVEL_TRAVEL_PLANNING",
    
    [NUGG_AD_TG_CONTENT_TRAVEL] = @"TRAVEL",
    
    [NUGG_AD_TG_CONTENT_VEHICLES_CAMPMOBILES_AND_CARAVANS] = @"VEHICLES_CAMPMOBILES_AND_CARAVANS",
    
    [NUGG_AD_TG_CONTENT_CARS] = @"CARS",
    
    [NUGG_AD_TG_CONTENT_CARS_CAR_SUPPLIES] = @"CARS_CAR_SUPPLIES",
    
    [NUGG_AD_TG_CONTENT_CARS_MARKETPLACE_FOR_CARS] = @"CARS_MARKETPLACE_FOR_CARS",
    
    [NUGG_AD_TG_CONTENT_CARS_MARKETPLACE_NEW] = @"CARS_MARKETPLACE_NEW",
    
    [NUGG_AD_TG_CONTENT_CARS_MARKETPLACE_USED] = @"CARS_MARKETPLACE_USED",
    
    [NUGG_AD_TG_CONTENT_CARS_VINTAGE_CARS] = @"CARS_VINTAGE_CARS",
    
    [NUGG_AD_TG_CONTENT_VEHICLES_MOTOR_BIKE] = @"VEHICLES_MOTOR_BIKE",
    
    [NUGG_AD_TG_CONTENT_VEHICLES_UTILITY_VEHICLE] = @"VEHICLES_UTILITY_VEHICLE"
};

NSString *const NUGG_AD_Style_Name[style_count] = {
    
    [NUGG_AD_TG_STYLE_NONE] = nil,
    
    [NUGG_AD_TG_STYLE_CLASSIFIED] = @"CLASSIFIED",
    
    [NUGG_AD_TG_STYLE_ECOMMERCE] = @"ECOMMERCE",
    
    [NUGG_AD_TG_STYLE_EDITORIAL_CONTENT] = @"EDITORIAL_CONTENT",
    
    [NUGG_AD_TG_STYLE_EDITORIAL_CONT_PICTURE] = @"EDITORIAL_CONT_PICTURE",
    
    [NUGG_AD_TG_STYLE_EDITORIAL_CONT_VIDEO] = @"EDITORIAL_CONT_VIDEO",
    
    [NUGG_AD_TG_STYLE_USER_GENERATED] = @"GENERATED",
    
    [NUGG_AD_TG_STYLE_UGC_FORUM] = @"UGC_FORUM",
    
    [NUGG_AD_TG_STYLE_UGC_IMAGES] = @"UGC_IMAGES",
    
    [NUGG_AD_TG_STYLE_UGC_VIDEO] = @"UGC_VIDEO"
};

@interface NuggAdPrediction(){
    
}

@end

@implementation NuggAdPrediction

#pragma mark - INIT
-(id)init{
    if ((self = [super init])) {
        
        NSString *plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:PLIST_CONFIG_FILE_NAME ofType:@"plist"];
        [self setup:plistPath];
    }
    
    return self;
}


-(id)initWithDelegate:(NSObject<NuggAdPredictionDelegate> *)aDelegate{
    if ((self = [super init])) {
        NSString *plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:PLIST_CONFIG_FILE_NAME ofType:@"plist"];
        
        [self setup:plistPath];
        
        self.delegate = aDelegate;
    }
    return self;
}

-(id)initWithDelegate:(NSObject<NuggAdPredictionDelegate> *)aDelegate andConfigurationPath:(NSString *)plistPath{
    
    if ((self = [super init])) {
        [self setup:plistPath];
        self.delegate = aDelegate;
    }
    return self;
}

-(void)setup:(NSString*)plistPath{
    
    NSDate *start = [NSDate date];
    
    // read plist config
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        NSLog(@"#### NUGG AD ## Config file not found. Please make sure a file named '%@' exists in your apps document directory.",PLIST_CONFIG_FILE_NAME);
    else
    {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        if (dict)
        {
            // set nugg_domain
            NSString *nugg_domain = [[dict valueForKey:PLIST_CONFIG_DOMAIN_KEY] copy];
            NSAssert(nugg_domain, @"#### NUGG AD ## Configuration is missing: Make sure to specify values for the following key(s) '%@'",PLIST_CONFIG_DOMAIN_KEY);
            [[NuggAdService sharedService] setNuggDomain:nugg_domain];
            
            // set nugg_networkid
            NSString *nugg_networkid = [[dict valueForKey:PLIST_CONFIG_NUGGN_KEY] copy];
            NSAssert(nugg_networkid, @"#### NUGG AD ## Configuration is missing: Make sure to specify values for the following key(s) '%@'",PLIST_CONFIG_NUGGN_KEY);
            [[NuggAdService sharedService] setNuggN:nugg_networkid];
            
            // set nugg_app_id
            NSString *nugg_app_id = [[dict valueForKey:PLIST_CONFIG_NUGGSID_KEY] copy];
            NSAssert(nugg_app_id, @"#### NUGG AD ## Configuration is missing: Make sure to specify values for the following key(s) '%@'",PLIST_CONFIG_NUGGSID_KEY);
            [[NuggAdService sharedService] setNuggSid:nugg_app_id];
            
            // dpid for ut call
            if([dict valueForKey:PLIST_CONFIG_NUGG_DPID])
                _nuggDPID = [[dict valueForKey:PLIST_CONFIG_NUGG_DPID] copy];
            
            _nuggAppID = nugg_app_id;
            
            _nuggRid = [[dict valueForKey:PLIST_CONFIG_RID_KEY] copy];
            
            // set nuggad obj
            [[NuggAdService sharedService] setNuggAdPredictionObj:self];
            
        }
        else
            NSLog(@"#### NUGG AD ## Configuration failed ####");
    }
    
    // Logging
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(nuggAd:required:toProcess:)] ) {
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];

        [self.delegate nuggAd:self required:executionTime toProcess:@"setup process"];
    }
}

-(void)setDelegate:(NSObject<NuggAdPredictionDelegate> *)delegate{
    _delegate = delegate;
    
    // test if already registered
    if (_delegate &&
        [_delegate respondsToSelector:@selector(nuggAdFirstCallApproval:)] &&
        ![[NuggAdPermission sharedPermissions] checkFirstCall]) {
        
        [_delegate nuggAdFirstCallApproval:self];
    }
}

#pragma mark - PUBLIC
-(NSString *)currentVersion{
    return @"3-1-0";
}

-(void)retrievePrediction{
    [self retrievePredictionWithReferrerContent:NUGG_AD_TG_CONTENT_NONE andStyle:NUGG_AD_TG_STYLE_NONE];
}

-(void)retrievePredictionWithConfig: (NuggAdPredictionConfig*) config {
    [self retrievePredictionWithReferrerContent:NUGG_AD_TG_CONTENT_NONE andStyle:NUGG_AD_TG_STYLE_NONE withConfig: config];
}

-(void)retrievePredictionWithReferrerContent:(NUGG_AD_TG_CONTENT)content andStyle:(NUGG_AD_TG_STYLE)style{
    
    [self retrievePredictionWithReferrerCustomContent:NUGG_AD_CONTENT_Name[content]
                                       andCustomStyle:NUGG_AD_Style_Name[style]];
}

-(void)retrievePredictionWithReferrerContent:(NUGG_AD_TG_CONTENT)content andStyle:(NUGG_AD_TG_STYLE)style withConfig: (NuggAdPredictionConfig*) config {
    [self retrievePredictionWithReferrerCustomContent:NUGG_AD_CONTENT_Name[content]
                                       andCustomStyle:NUGG_AD_Style_Name[style]
                                            andConfig: config];
}

-(void)retrievePredictionWithReferrerCustomContent:(NSString *)content andCustomStyle:(NSString *)style{
    NuggAdPredictionConfig *config = [NuggAdPredictionConfig defaultConfig];
    [self retrievePredictionWithReferrerCustomContent:content andCustomStyle:style andConfig:config];
}


-(void)retrievePredictionWithReferrerCustomContent:(NSString *)content andCustomStyle:(NSString *)style andConfig: (NuggAdPredictionConfig*) config{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDate *start = [NSDate date];
        
        NSString* content_enc = [[content stringByReplacingOccurrencesOfString:@"," withString:@"_"]
                                 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString* style_enc = [[style stringByReplacingOccurrencesOfString:@"," withString:@"_"]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // check permission
        NSDate *start_permission = [NSDate date];
        
        Boolean agreement = [[NuggAdPermission sharedPermissions] readGlobalPermission];
        
        // Logging
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(nuggAd:required:toProcess:)] ) {
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start_permission];
            
            [self.delegate nuggAd:self required:executionTime toProcess:@"checking permissions"];
        }
        
        // call nugg.ad - send in any case / server method will handle delegate callbacks
        NSString* referrer = (content != NUGG_AD_TG_CONTENT_NONE &&
                              style != NUGG_AD_TG_STYLE_NONE) ? [NSString stringWithFormat:@"%@,%@",content_enc,style_enc] : nil;
        
        [[NuggAdService sharedService] nuggadRC:referrer
                                  andPermission:agreement
                                        andAdID:[NuggAdPermission sharedPermissions].adID ];
        
        // Logging
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(nuggAd:required:toProcess:)] ) {
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
            
            [self.delegate nuggAd:self required:executionTime toProcess:@"first phase preparation of RC request"];
        }
        
    });
}


-(void)didSubmitSurvey:(Boolean)completed{

    NSDate *start = [NSDate date];
    
    // check permission
    Boolean agreement = [[NuggAdPermission sharedPermissions] readGlobalPermission];

    [[NuggAdService sharedService] nuggadFC:completed
                              andPermission:agreement
                                    andAdID:[NuggAdPermission sharedPermissions].adID ];
    
    // Logging
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(nuggAd:required:toProcess:)] ) {
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
        
        [self.delegate nuggAd:self required:executionTime toProcess:@"first phase preparation of FC request"];
    }
    
}

-(void)didSubmitSurvey{
    Boolean didSubmit = ![NuggAdSurveyViewController didUserCancelLastCall];
    [self didSubmitSurvey:didSubmit];
}

-(void)nuggadCI:(NSString *)campaign_id andFormat:(NSString*)format_id{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        // check permission
        Boolean agreement = [[NuggAdPermission sharedPermissions] readGlobalPermission];
        
        [[NuggAdService sharedService] nuggadCI:campaign_id
                                      andFormat:format_id
                                  andPermission:agreement
                                        andAdID:[NuggAdPermission sharedPermissions].adID];
    });
    
}

-(void)nuggadUTwithProductsList:(NSArray *)productslist{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSAssert(_nuggDPID && ![_nuggDPID isEqualToString:@""], @"If you want to call the UT endpoint you have to provide a nugg_data_provider_id in your plist configuration. See docs.");
        
        // check permission
        Boolean agreement = [[NuggAdPermission sharedPermissions] readGlobalPermission];
        
        [[NuggAdService sharedService] nuggadUT:_nuggDPID
                                andProductsList:productslist
                                  andPermission:agreement
                                        andAdID:[NuggAdPermission sharedPermissions].adID];
        
    });
    
}

-(void)nuggadUTFor:(NSString *)data_name withAIDA:(int)aida andTTL:(NSTimeInterval)ttl{
    NuggAdUTProduct* product = [[NuggAdUTProduct alloc] initWithName:data_name AIDA:aida andTTL:ttl];
    
    NSAssert(product, @"some of your supplied parameters seems to be incompatible. Try creating a NuggAdUTProduct with the same params.");

    [self nuggadUTwithProductsList:@[product]];
}

-(void)nuggadUTFor:(NSString *)data_name withAIDA:(int)aida{
    
    [self nuggadUTFor:data_name withAIDA:aida andTTL:NAN];
}

-(void)nuggadUTFor:(NSString *)data_name{
    [self nuggadUTFor:data_name withAIDA:-1 andTTL:NAN];
}

@end
