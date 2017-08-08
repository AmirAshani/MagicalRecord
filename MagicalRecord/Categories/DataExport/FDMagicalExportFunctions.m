//
//  FDMagicalExportFunctions.m
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/8/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import "FDMagicalExportFunctions.h"


NSString * __MR_nonnull MR_dateToString(NSDate *__MR_nonnull value, NSString *__MR_nonnull format)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    
    NSString *stringDate = [formatter stringFromDate:value];
    
    return stringDate;
}
