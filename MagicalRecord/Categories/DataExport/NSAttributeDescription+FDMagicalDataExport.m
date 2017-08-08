//
//  NSAttributeDescription+FDMagicalDataExport.m
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/8/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import "NSAttributeDescription+FDMagicalDataExport.h"
#import "NSManagedObject+MagicalDataImport.h"
#import "FDMagicalExportFunctions.h"

@implementation NSAttributeDescription (FDMagicalDataExport)

-(NSString *)MR_exportKey{
    NSString * attributeName=[self.userInfo objectForKey:kMagicalRecordImportAttributeKeyMapKey];
    return attributeName.length >0 ? attributeName : self.name;
}

-(id)MR_formateValue:(id)valueToFormat{

    if(valueToFormat == nil)
        return [NSNull null];
    
    id value;
    
    NSAttributeType attributeType = [self attributeType];
    
    if(attributeType == NSDateAttributeType){
        NSString *dateFormat = [[self userInfo] objectForKey:kMagicalRecordImportCustomDateFormatKey];
        value=MR_dateToString(value, dateFormat ?: kMagicalRecordImportDefaultDateFormatString);

    }
    //can be removed
    else if (attributeType == NSInteger16AttributeType ||
             attributeType == NSInteger32AttributeType ||
             attributeType == NSInteger64AttributeType ||
             attributeType == NSDecimalAttributeType ||
             attributeType == NSDoubleAttributeType ||
             attributeType == NSFloatAttributeType) {
        
             value=valueToFormat;
//        if (![valueToFormat isKindOfClass:[NSNumber class]] && value != [NSNull null]) {
//            value =[valueToFormat string];
//        }
    }
    else if (attributeType == NSBooleanAttributeType) {
        value=valueToFormat;
    }
    else if (attributeType == NSStringAttributeType) {
        value=valueToFormat;
    }else {
        value=valueToFormat;
        //1. binary data
        //2. date
        //3. transformable
    }
    

    return value == nil ? [NSNull null] : value;
    

}
@end
