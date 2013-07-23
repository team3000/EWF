//
//  ConventionTools.h
//  Utils
//
//  Created by Adrien Guffens on 10/19/12.
//  Copyright (c) 2012 Adrien Guffens. All rights reserved.
//

@interface ConventionTools : NSObject

+ (BOOL)isNetworkOn;

+ (NSDate *)startTimer;
+ (void)stopTimer:(NSDate *) start;
+ (NSDate *)getDate:(NSString *)date withFormat:(NSString *)format;
+ (NSString *)getStringDate:(NSDate *)date withFormat:(NSString *)format;

//new and ok
+ (BOOL)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath;

//Diff time
+ (NSString *)getDiffTimeInStringFromDate:(NSDate *)baseDate;
+ (NSString *)getDiffTimeInStringFromString:(NSString *)stringDate withFormat:(NSString *)format;

//Translator
+ (BOOL)string:(NSString *)sourceString containsString:(NSString *)string;
+ (NSString *)replace:(NSString *)sourceString with:(NSString *)originalString by:(NSString *)stringToReplace;
+ (NSString *)numberToString:(NSNumber *)number;

//Format
+ (NSString *)formatValue:(int)value forDigits:(int)zeros;

//Sound
+ (void)playSound:(NSString *)aFileName;


@end