//
//  BADate.m
//  BiteApple
//
//  Created by jayhuan on 2020/12/2.
//

#import "BADate.h"

@implementation BADate

- (void)dateConvert {
    NSString *dateStr = @"2020-04-28 08:08:08";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // NSString 转换成 NSDate
    NSDate *photoDate = [formatter dateFromString:dateStr];
    
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    datecomps.year = 1;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *futureDate = [calendar dateByAddingComponents:datecomps toDate:photoDate options:0];
    
    NSComparisonResult result = [photoDate compare:futureDate];
}

@end
