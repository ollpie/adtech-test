//
//  NuggAdPrediction.h
//  NuggAdPrediction
//
//  Created by Benjamin Müller on 05.09.12.
//  Copyright (c) 2012 urbn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NuggAdPredictionConfig.h"

/**
 Filename of configuration plist inside the app directory.
 */
#define PLIST_CONFIG_FILE_NAME @"nuggadconfig"

/**
 Plist key name of domain in the configuration file.
 */
#define PLIST_CONFIG_DOMAIN_KEY @"nugg_domain"

/**
 Plist key name of network id (nuggn) in the configuration file.
 */
#define PLIST_CONFIG_NUGGN_KEY @"nugg_networkid"

/**
 Plist key name of app_id/site_id (nuggsid) in the configuration file.
 */
#define PLIST_CONFIG_NUGGSID_KEY @"nugg_app_id"

/**
 Plist key name of nuggrid in the configuration file.
 */
#define PLIST_CONFIG_RID_KEY @"nuggrid"

/**
 * Plist key name of nugg dpid relevant for UT calls.
 */
#define PLIST_CONFIG_NUGG_DPID @"nugg_data_provider_id"

/***nugg.ad TG parameter 1 - content*/
typedef enum {
    /***Don't use this, but choose the best suiting value from below*/
    NUGG_AD_TG_CONTENT_NONE = 0,
    
    /**Electronic audio products in general*/
    NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_AUDIO,

    /**All kinds of computer hardware*/
    NUGG_AD_TG_CONTENT_COMPUTER_HARDWARE,
    
    /**All kinds of computer software except games*/
    NUGG_AD_TG_CONTENT_COMPUTER_SOFTWARE_NON_GAMES,
    
    /**Any kind of information about computer (hard and software)*/
    NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_COMPUTER,
    
    /**Computer accessories and periphal devices*/
    NUGG_AD_TG_CONTENT_HARDWARE_HARDWARE_EQUIPMENT,
    
    /**Notebooks*/
    NUGG_AD_TG_CONTENT_DEVICES_NOTEBOOK,

    /**PCs*/
    NUGG_AD_TG_CONTENT_DEVICES_PC,
    
    /**Tablet PCs*/
    NUGG_AD_TG_CONTENT_DEVICES_TABLETS_GADGETS,
    
    /**Accessories for cellular phones*/
    NUGG_AD_TG_CONTENT_CELL_PHONE_EQUIPMENT,
    
    /**Cellular phones themselves*/
    NUGG_AD_TG_CONTENT_CELL_PHONE_DEVICES,
    
    /**Any kind of information about cellular phones*/
    NUGG_AD_TG_CONTENT_CELL_PHONE,
    
    /**Anything about photography and cameras*/
    NUGG_AD_TG_CONTENT_PHOTO,
    
    /**Cameras*/
    NUGG_AD_TG_CONTENT_PHOTO_DEVICES,
    
    /**Camera accessories*/
    NUGG_AD_TG_CONTENT_PHOTO_EQUIPMENT,
    
    /**Fernseher*/
    NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_TV,
    
    /**Home-Entertainment-Zubehör außer Player/Rekorder*/
    NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC_TV_EQUIPMENT,
    
    /**Consumer electronics in general*/
    NUGG_AD_TG_CONTENT_CONSUMER_ELECTRONIC,
    
    /**Dating platforms and information about datin in general*/
    NUGG_AD_TG_CONTENT_DATING,
    
    /**Chatting platfoms*/
    NUGG_AD_TG_CONTENT_ENTERTAINMENT_CHAT,
    
    /**Horoscopes*/
    NUGG_AD_TG_CONTENT_ENTERTAINMENT_HOROSCOPE,
    
    /**Lotteries*/
    NUGG_AD_TG_CONTENT_LOTTERY,
    
    /**Cartoons, comic strips, jokes*/
    NUGG_AD_TG_CONTENT_ENTERTAINMENT_HUMOUR,
    
    /**Sports betting*/
    NUGG_AD_TG_CONTENT_LOTTERY_SPORTS_BETTING,
    
    /**Crosswords, puzzles, etc.*/
    NUGG_AD_TG_CONTENT_ENTERTAINMENT_QUIZ,
    
    /**Anything entertaining (but no news, gossip)*/
    NUGG_AD_TG_CONTENT_ENTERTAINMENT,
    
    /**All kinds of erotic content*/
    NUGG_AD_TG_CONTENT_EROTIC,
    
    /**Beauty, care, cosmetics etc.*/
    NUGG_AD_TG_CONTENT_BEAUTY_AND_CARE,
    
    /**Fashion in general*/
    NUGG_AD_TG_CONTENT_FASHION,
    
    /**Mens fashion*/
    NUGG_AD_TG_CONTENT_FASHION_FASHION_MEN,
    
    /**Womens fashion*/
    NUGG_AD_TG_CONTENT_FASHION_FASHION_WOMEN,
    
    /**Anything about health*/
    NUGG_AD_TG_CONTENT_HEALTH,
    
    /**Psychology*/
    NUGG_AD_TG_CONTENT_HEALTH_PSYCHOLOGY,
    
    /**Anything about fashion and beauty*/
    NUGG_AD_TG_CONTENT_FASHION_AND_BEAUTY,
    
    /**Information about kids in general*/
    NUGG_AD_TG_CONTENT_FAMILY_KIDS,
    
    /**All topics about 'family', couples, kids etc.*/
    NUGG_AD_TG_CONTENT_FAMILY,
    
    /**Anything about cooking*/
    NUGG_AD_TG_CONTENT_COOKING,
    
    /**Furniture in general*/
    NUGG_AD_TG_CONTENT_FURNITURE,
    
    /**Decoration, home and garden furnishing etc.*/
    NUGG_AD_TG_CONTENT_FURNISHING,
    
    /**Anything about gardens and gardening*/
    NUGG_AD_TG_CONTENT_GARDEN,
    
    /**Groceries*/
    NUGG_AD_TG_CONTENT_GROCERIES,
    
    /**home improvent*/
    NUGG_AD_TG_CONTENT_HOME_IMPROVEMENT,
    
    /**Household topics in general*/
    NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_HOUSEHOLD,
    
    /**Versicherungen*/
    NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_INSURANCE,
    
    /**Anything about pets*/
    NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_PETS,
    
    /**Rates (household)*/
    NUGG_AD_TG_CONTENT_RATES,
    
    /**Telekommunikation rates (phone and internet access)*/
    NUGG_AD_TG_CONTENT_RATES_TELECOM,
    
    /**Mobile phone rates*/
    NUGG_AD_TG_CONTENT_RATES_MOBILE_PHONE,
    
    /**Phone rates landlines*/
    NUGG_AD_TG_CONTENT_RATES_LANDLINE_PHONE,
    
    /**Internet access rates*/
    NUGG_AD_TG_CONTENT_RATES_INTERNET_ACCESS,
    
    /**Electricity rates*/
    NUGG_AD_TG_CONTENT_RATES_ELECTRICITY,
    
    /**Gas rates*/
    NUGG_AD_TG_CONTENT_RATES_GAS,
    
    /**Home and garden, general and specific advice and consulting*/
    NUGG_AD_TG_CONTENT_HOME_AND_GARDEN_ADVICE_AND_CONSULTING,
    
    /**Anything about home and garden, family, kids, cooking, decoration, furniture, rates*/
    NUGG_AD_TG_CONTENT_HOME_AND_GARDEN,
    
    /**Information/news about economy and business topics*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_ECONOMY,
    
    /**Information/news about warrants and options*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_WARRANTS_AND_OPTIONS,
    
    /**Information/news about credits and loans*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_CREDITS_AND_LOANS,
    
    /**Information/news about finance topics; warrants, options, credits, other investment forms*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_FINANCE,
    
    /**Information/news about science and knowledge in general*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_KNOWLEDGE,
    
    /**News in general*/
    NUGG_AD_TG_CONTENT_INFO_NEWS,
    
    /**News about political topics*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_POLITICS,
    
    /**News about regional topics*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_REGIONAL,
    
    /**News about domestic policy*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_INTERNAL_POLICY,
    
    /**News about foreign policy*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_FOREIGN_POLICY,
    
    /**Information/news about society, celebs, gossip, yellow press topics*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_SOCIETY,
    
    /**Information/news about celebs*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_SOCIETY_VIPS,
    
    /**Information/news about sports topics in general*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_SPORTS,
    
    /**Information/news about motor sports; F1 and other*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_MOTORSPORTS,
    
    /**Information/news about boxing*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_BOXING,
    
    /**Information/news about golf*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_GOLF,
    
    /**Information/news about tennis*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_TENNIS,
    
    /**Information/news about trend sports ( Basketball, Skateboarding, Snowboarding)*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_TREND_SPORTS,
    
    /**Information/news football/soccer in general*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_FOOTBALL,
    
    /**Information/news national football/soccer leagues*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_FOOTBALL_LEAGUES,
    
    /**Information/news about international football/soccer*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_FOOTBALL_INTERNATIONAL,
    
    /**Information/news about 'other' sports*/
    NUGG_AD_TG_CONTENT_INFO_NEWS_SPORT_OTHER,
    
    /**Anything about the arts, culture, museums, galleries*/
    NUGG_AD_TG_CONTENT_ART,
    
    /**Weather information*/
    NUGG_AD_TG_CONTENT_WEATHER,
    
    /**Comic books, cartoons, graphic novels*/
    NUGG_AD_TG_CONTENT_BOOKS_COMIC,
    
    /**Books*/
    NUGG_AD_TG_CONTENT_LIFESTYLE_AND_LEISURE_BOOKS,
    
    /**Anything about gaming consoles and console games*/
    NUGG_AD_TG_CONTENT_COMPUTER_GAMES_CONSOLE,
    
    /**Anything about computer games (PC, consoles, online )*/
    NUGG_AD_TG_CONTENT_COMPUTER_GAMES,
    
    /**Any kind of information about higher education*/
    NUGG_AD_TG_CONTENT_EDUCATION_UNIVERSITY,
    
    /**Any kind of information about education in context of primary & secondary schools*/
    NUGG_AD_TG_CONTENT_EDUCATION_SCHOOL,
    
    /**Information about education in general (school, university, adult education etc.)*/
    NUGG_AD_TG_CONTENT_EDUCATION,
    
    /**Information about events, event lists, calendars etc.*/
    NUGG_AD_TG_CONTENT_EVENTS,
    
    /**Information about restaurants, bistros, pizzerias etc.*/
    NUGG_AD_TG_CONTENT_GASTRONOMY_RESTAURANTS,
    
    /**Information about clubs, bars, discos*/
    NUGG_AD_TG_CONTENT_GASTRONOMY_CLUBBING,
    
    /**Anything about gastronomy (restaurants, bars, clubs, pizzerias etc.)*/
    NUGG_AD_TG_CONTENT_GASTRONOMY,
    
    /**Information about movies, cinemas etc.*/
    NUGG_AD_TG_CONTENT_MOVIES,
    
    /**Anything about radio (stations, programmes - not about hardware!)*/
    NUGG_AD_TG_CONTENT_RADIO,
    
    /**Music/ information about music - Rock*/
    NUGG_AD_TG_CONTENT_MUSIC_ROCK,
    
    /**Music/ information about music - Ppp*/
    NUGG_AD_TG_CONTENT_MUSIC_POP,
    
    /**Music/ information about music - Classical*/
    NUGG_AD_TG_CONTENT_MUSIC_CLASSICAL_MUSIC,
    
    /**Music/ information about music - Hiphop/Rap*/
    NUGG_AD_TG_CONTENT_MUSIC_HIPHOP,
    
    /**Music/ information about musical instruments*/
    NUGG_AD_TG_CONTENT_MUSIC_MUSIC_INSTRUMENTS,
    
    /**Music/ information about music - Raggae*/
    NUGG_AD_TG_CONTENT_MUSIC_REGGAE,
    
    /**Music/ information about music - Techno, house etc.*/
    NUGG_AD_TG_CONTENT_MUSIC_ELECTRO,
    
    /**Music/ information about music - Jazz, Blues*/
    NUGG_AD_TG_CONTENT_MUSIC_BLUES_JAZZ,
    
    /**Music/ information about music - Audio Books*/
    NUGG_AD_TG_CONTENT_MUSIC_AUDIO_BOOK,
    
    /**Music/ information about music - Childrens songs*/
    NUGG_AD_TG_CONTENT_MUSIC_SONGS_CHILDREN,
    
    /**Music/ information about music in general*/
    NUGG_AD_TG_CONTENT_MUSIC,
    
    /**Sports equipment*/
    NUGG_AD_TG_CONTENT_SPORTS_EQUIPMENT,
    
    /**Information about (non-professional) sports activities*/
    NUGG_AD_TG_CONTENT_SPORTS_ACCESSORIES,
    
    /**Bicycles (sports equiment)*/
    NUGG_AD_TG_CONTENT_SPORTS_EQUIPMENT_BIKE,
    
    /**Information about outdoor sports*/
    NUGG_AD_TG_CONTENT_SPORTS_OUTDOOR,
    
    /**Anything about lifestyle and leisure - sports, music, movies, books, the arts, events, nightlife, dining etc.*/
    NUGG_AD_TG_CONTENT_LIFESTYLE_AND_LEISURE,
    
    /**Classifieds - jobs*/
    NUGG_AD_TG_CONTENT_MARKET_PLACE_JOBS,
    
    /**Classifieds - real estate, flats, apartments etc.*/
    NUGG_AD_TG_CONTENT_MARKET_PLACE_REAL,
    
    /**Classifieds*/
    NUGG_AD_TG_CONTENT_MARKET_PLACE,
    
    /**Customer service sections within an app or website*/
    NUGG_AD_TG_CONTENT_SERVICE_CUSTOMER_SERVICE,
    
    /**Directories (as part of customer service)*/
    NUGG_AD_TG_CONTENT_SERVICE_DIRECTORIES,
    
    /**Obligatory information within an app or website - Imprint, Help, TOS*/
    NUGG_AD_TG_CONTENT_SERVICE_OBLIGATORY,
    
    /**What it says ... (but not about comedy series/sitcoms > tv series comedy)*/
    NUGG_AD_TG_CONTENT_TV_COMEDY,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_DRAMA,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_MYSTERY,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_HORROR,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_THRILLER,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_ACTION,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_SF_F,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_WESTERN,
    
    /**What it says ... (but not about the resp TV series/sitcoms > tv series <topic>)*/
    NUGG_AD_TG_CONTENT_TV_EROTIC,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_DOCUMENTARY,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_LIFESTYLE_MAGAZINES,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SHOW,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_TALK_SHOWS,
    
    /**Programme overviews*/
    NUGG_AD_TG_CONTENT_TV_TV_PROGRAMME,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_TV_SERIES,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_COMEDY,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_WOMEN,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_THRILLER,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_MYSTERY,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_DRAMA,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_HORROR,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_ACTION,
    
    /**What it says ... Science Fiction and Fantasy.*/
    NUGG_AD_TG_CONTENT_TV_SERIES_SF_F,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_WESTERN,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TV_SERIES_EROTIC,
    
    /**Anything about television (stations, formats, programmes - not about hardware!)*/
    NUGG_AD_TG_CONTENT_TELEVISION,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TRAVEL_ACCOMODATIONS,
    
    /**Booking sites*/
    NUGG_AD_TG_CONTENT_TRAVEL_BOOKING,
    
    /**Car rental sites*/
    NUGG_AD_TG_CONTENT_TRAVEL_CAR_RENTAL,
    
    /**Last-minute offerings*/
    NUGG_AD_TG_CONTENT_TRAVEL_LAST_MINUTE,
    
    /**What it says ...*/
    NUGG_AD_TG_CONTENT_TRAVEL_ROUTE_PLANNER,
    
    /**Buying tickets online*/
    NUGG_AD_TG_CONTENT_TRAVEL_TICKETS,
    
    /**Travel planning in general*/
    NUGG_AD_TG_CONTENT_TRAVEL_TRAVEL_PLANNING,
    
    /**Any kind of information about travelling*/
    NUGG_AD_TG_CONTENT_TRAVEL,
    
    /**Wohnmobile und Wohnwagen*/
    NUGG_AD_TG_CONTENT_VEHICLES_CAMPMOBILES_AND_CARAVANS,
    
    /**Any kind of information about automobiles*/
    NUGG_AD_TG_CONTENT_CARS,
    
    /**Any about car supplies and accessories*/
    NUGG_AD_TG_CONTENT_CARS_CAR_SUPPLIES,
    
    /**Classifieds and ecommerce - cars in general*/
    NUGG_AD_TG_CONTENT_CARS_MARKETPLACE_FOR_CARS,
    
    /**Classifieds and ecommerce - new cars*/
    NUGG_AD_TG_CONTENT_CARS_MARKETPLACE_NEW,
    
    /**Classifieds and ecommerce - used cars*/
    NUGG_AD_TG_CONTENT_CARS_MARKETPLACE_USED,
    
    /**Any kind of information vintage cars*/
    NUGG_AD_TG_CONTENT_CARS_VINTAGE_CARS,
    
    /**Any kind of information about motor bikes*/
    NUGG_AD_TG_CONTENT_VEHICLES_MOTOR_BIKE,
    
    /**Any kind of information about utility vehicles*/
    NUGG_AD_TG_CONTENT_VEHICLES_UTILITY_VEHICLE,
    
    content_count  // keep track of the enum size automatically
    
} NUGG_AD_TG_CONTENT;

extern NSString *const NUGG_AD_CONTENT_Name[content_count];

/**nugg.ad TG parameter 2 - style*/
typedef enum {
    /**Don't use this, but choose the best suiting value from below*/
    NUGG_AD_TG_STYLE_NONE = 0,
    
    /**Classified ads*/
    NUGG_AD_TG_STYLE_CLASSIFIED,
    
    /**Online shop*/
    NUGG_AD_TG_STYLE_ECOMMERCE,
    
    /**Editoral content (not user-generated)*/
    NUGG_AD_TG_STYLE_EDITORIAL_CONTENT,
    
    /**Editorial content pictures and picture galleries*/
    NUGG_AD_TG_STYLE_EDITORIAL_CONT_PICTURE,
    
    /**Editorial content videos and video galleries*/
    NUGG_AD_TG_STYLE_EDITORIAL_CONT_VIDEO,
    
    /**User-generated content*/
    NUGG_AD_TG_STYLE_USER_GENERATED,
    
    /**Forums, communities, social media platforms*/
    NUGG_AD_TG_STYLE_UGC_FORUM,
    
    /**User-generated images and picture galleries*/
    NUGG_AD_TG_STYLE_UGC_IMAGES,
    
    /**User-generated videos and video galleries*/
    NUGG_AD_TG_STYLE_UGC_VIDEO,
    
    style_count
    
} NUGG_AD_TG_STYLE;
extern NSString *const NUGG_AD_Style_Name[style_count];

    
    
// FORWARD DEKLARATIONS
@protocol NuggAdPredictionDelegate;

/**
 You must assign a delegate implementing the required methods in order to get nugg.ad prediction working.
 
 @note NuggAdPrediction should be initialized only once in app life time and only one delegate can be assigned. Hence you should implement a getter e.g. in your app delegate to serve all your view controllers with access to a single instance of the NuggAdPrediction class. A sample implementation is provided in the Guide document.
 
 @warning  This static library makes use of the
 AdSupport Framework on iOS6 and greater. Make sure to link against this framework when you include the library in your project.
 This library is compiled for iOS devices and Simulator.
 */
@interface NuggAdPrediction : NSObject

/**
 *  @name Properties
 */

/**
 *  returns version of this library
 */
@property (readonly) NSString* currentVersion;

/**
 A single delegate handling configuration and response of prediction calls. This property must be set - you should use the appropriate init method.
 */
@property (nonatomic,strong) NSObject<NuggAdPredictionDelegate>* delegate;

/**
 Use plist configuration instead.
 */
@property (readonly) NSString* nuggAppID;

/**
 Use plist configuration instead.
 */
@property (readonly) NSString* nuggRid;

/**
 Use plist configuration instead.
 */
@property (readonly) NSString* nuggDPID;

/**
 @name Initialization
 */

/**
 Use this init method to ensure a delegate is set. Make sure to place a configuration file "nuggadconfig.plist" inside your app directory.
 @param aDelegate propably your app delegate which implements the NuggAdPredictionDelegate protocol.
 */
-(id)initWithDelegate:(NSObject<NuggAdPredictionDelegate>*)aDelegate;

/**
 *  use this initializer instead of initWithDelegate: if you want to specify an explicit location of the configuration plist.
 *
 *  @param aDelegate aDelegate which implements the NuggAdPredictionDelegate protocol
 *  @param plistPath path to plist
 *
 *  @return instance of NuggAdPrediction.
 */
-(id)initWithDelegate:(NSObject<NuggAdPredictionDelegate> *)aDelegate andConfigurationPath:(NSString*)plistPath;


/**
 @name RC call
 */

/**
 Call this method to load nugg.ad prediction. The request is asynchron and response will be
 given using delegate methods.
 */
-(void)retrievePrediction;

/**
 Call this method to load nugg.ad prediction. The request is asynchron and response will be
 given using delegate methods. Accepts a per-request config.
 @param config (NuggAdPredictionConfig)
 */
-(void)retrievePredictionWithConfig: (NuggAdPredictionConfig*) config;


/**
 Same as retrievePrediction but adds parameters in the API request to describe more precisely what content the user is currently exploring. Call this method whenever this information context is changing.
 @param content see documentation for possible values.
 @param style see documentation for possible values.
 */
-(void)retrievePredictionWithReferrerContent:(NUGG_AD_TG_CONTENT)content andStyle:(NUGG_AD_TG_STYLE)style;


/**
 Same as retrievePrediction but adds parameters in the API request to describe more precisely what content the user is currently exploring. Call this method whenever this information context is changing. 
 Accepts a per-request config.
 @param content see documentation for possible values.
 @param style see documentation for possible values.
@param config (NuggAdPredictionConfig)
 */
-(void)retrievePredictionWithReferrerContent:(NUGG_AD_TG_CONTENT)content andStyle:(NUGG_AD_TG_STYLE)style withConfig: (NuggAdPredictionConfig*) config;

/**
 Same as retrievePredictionWithReferrerContent but you can provide custom string values for content and style. Call this method whenever this information context is changing.
 @param content (String)
 @param style (String)
 */
-(void)retrievePredictionWithReferrerCustomContent:(NSString*)content andCustomStyle:(NSString*)style;


/**
 Same as retrievePredictionWithReferrerContent but you can provide custom string values for content and style. Call this method whenever this information context is changing. Accepts a per-request config.
 @param content (String)
 @param style (String)
 @param config (NuggAdPredictionConfig)
 */
-(void)retrievePredictionWithReferrerCustomContent:(NSString *)content andCustomStyle:(NSString *)style andConfig: (NuggAdPredictionConfig*) config;


/**
 *  Call this method after a user did submit a nugg.ad survey to prevent the system to show up again another survey.
 *
 *  @param set completed to 'false' if the user cancelled the survey invitation, otherwise true.
 */
-(void)didSubmitSurvey:(Boolean)completed;


/**
 *  Call this method after a user did submit a nugg.ad survey to prevent the system to show up again another survey. Use this method in conjunction with the convenient NuggAdSurveyViewController.
 *
 */
-(void)didSubmitSurvey;

/*
 *  @name CI call
 */

/*
 *  calls the CI endpoint. network_id is taken from the properties (plist)
 *
 *  @param campaign_id a campaign id
 *  @param format_id   a format id
 */
-(void)nuggadCI:(NSString*)campaign_id andFormat:(NSString*)format_id;

/**
 *  @name UT call
 */

/**
 *  calls the UT endpoint.
 *
 *  @param productslist list of NuggAdUTProduct
 */
-(void)nuggadUTwithProductsList:(NSArray *)productslist;

/**
 *  Convenience method to supply a single product to the UT endpoint.
 *
 *  @param data_name  product specifier
 *  @param aida       aida, value can be 1 to 9. see documentation
 *  @param ttl        time to live, should not be 0.
 */
-(void)nuggadUTFor:(NSString*)data_name withAIDA:(int)aida andTTL:(NSTimeInterval)ttl;

/**
 *  Convenience method to supply a single product to the UT endpoint.
 *
 *  @param data_name  product specifier
 *  @param aida       aida, value can be 1 to 9. see documentation
 */
-(void)nuggadUTFor:(NSString*)data_name withAIDA:(int)aida;

/**
 *  Convenience method to supply a single product to the UT endpoint.
 *
 *  @param data_name  product specifier
 */
-(void)nuggadUTFor:(NSString*)data_name;

@end


#pragma mark - PROTOCOLS

/**
 @protocol NuggAdPredictionDelegate
 @discussion Implement this delegate protocol in your app to provide nugg.ad with some configuration values and to receive predictions.
 */

@protocol NuggAdPredictionDelegate <NSObject>

/**
 @name Response
 */

/**
 This method will be called on the delegate whenever the nugg.ad server responded with success. The
 body can be empty anyway.
*/
-(void)nuggAd:(NuggAdPrediction*)prediction responseSuccess:(NSDictionary*)body;

/**
 In case of a network error or server side issues this error method will be called instead of success.
 */
-(void)nuggAd:(NuggAdPrediction*)prediction responseError:(NSError*)error;

/**
 This method will be called instead of success or error when the user disallowes the use of nugg.ad prediction.
 @param isGloballyDenied indicates whether nugg.ad permission is turned off for all apps or solely this app.
 */
-(void)nuggAd:(NuggAdPrediction*)prediction responsePermissionDenied:(Boolean)isGloballyDenied;


/**
 @name Configuration and Callbacks
 */

/**
 This method will be called before the first time this app sends a nugg.ad request to give the calling app or framework
 a chance to explictly ask the user for permission. For your convenience a sample implementation is provided in NuggAdNotification class.
 
    -(void)nuggAdFirstCallApproval:(NuggAdPrediction *)prediction{
 
        // create and present alert
        [NuggAdNotification presentNuggadDisclaimer];
    }
*/
-(void)nuggAdFirstCallApproval:(NuggAdPrediction*)prediction;

/**
 This method will be called maximum 2 times in device life time and provides an app developer with the ability to present a survey in a simple webview which a user should fill out to specify more precisely important target informations. For your convenience a sample implementation is provided in NuggAdSurveyViewController.
 
    NuggAdPrediction* _prediction;
    NuggAdSurveyViewController* _surveyCtrl;
 
    ...
 
    -(void)nuggAd:(NuggAdPrediction *)prediction showSurveyWithURL:(NSURL *)url{
 
         if(_surveyCtrl) return;
         
         _surveyCtrl = [NuggAdSurveyViewController presentSurveyWithURL:url
                                                           onCompletion:^(BOOL submit) {
         
            if(submit)
                [_prediction didSubmitSurvey];
         
            _surveyCtrl = nil;
         }];    
    }
*/
-(void)nuggAd:(NuggAdPrediction*)prediction showSurveyWithURL:(NSURL*)url;


@optional

/*
 @name CI Call
 */


/*
 *  is called when ci call succeeded.
 *
 *  @param prediction nuggad prediction
 */
-(void)nuggAdCICallSuccess:(NuggAdPrediction*)prediction;

/*
 *  is called when ci call returned an error.
 *
 *  @param prediction nuggad prediction
 */
-(void)nuggAdCICallError:(NuggAdPrediction*)prediction;


/**
 @name UT Call
 */


/**
 *  is called when ut call succeeded.
 *
 *  @param prediction nuggad prediction
 */
-(void)nuggAdUTCallSuccess:(NuggAdPrediction*)prediction;

/**
 *  is called when ut call returned an error.
 *
 *  @param prediction nuggad prediction
 */
-(void)nuggAdUTCallError:(NuggAdPrediction*)prediction;


/**
 @name Debug
 */


/**
 During development you may enable API request logging by implementing this method to return TRUE. The default value is FALSE.
 */
-(Boolean)nuggAdShouldLogRequests:(NuggAdPrediction*)prediction;

/**
 *  During development you may want to be informed on how long nuggad api tasks last.
 *
 *  @param prediction nuggad prediction
 *  @param time       duration
 *  @param task       description of the processed task
 *
 */
-(void)nuggAd:(NuggAdPrediction*)prediction required:(NSTimeInterval)time toProcess:(NSString*)task;

@end
