//
//  NSManagedObject+FDMagicalRecordExport.m
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/8/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+FDMagicalRecordExport.h"
#import "NSAttributeDescription+FDMagicalDataExport.h"



@implementation NSManagedObject (FDMagicalRecordExport)

-(NSString*)MR_toJSONWithOptions:(id<FDMagicalRecord_ExportOptions>)options{
    
    NSDictionary * dictionary=[self toDictionaryWithOption:options];
//    NSData * jsonData=[dictionary data]
    NSError *jsonError = nil;
    NSData * jsonData=[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    if(jsonError){
        NSLog(@"%@",[jsonError localizedDescription]);
        return nil;
    }
    
    NSString * string=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return string;
    

}


-(NSDictionary*)MR_toDictionaryWithOption:(id<FDMagicalRecord_ExportOptions>)options{
    
    NSArray * attributesNameToExport=[self attributesNameToExport:options];
    NSDictionary * dic=[self exportAttributes:attributesNameToExport];
    return dic;
}



-(NSArray*)attributesNameToExport:(id<FDMagicalRecord_ExportOptions>)options{
    NSArray* attributesName=self.entity.attributesByName.allKeys;
    
    if(options==nil){
        return attributesName;
    }
    
    NSSet * setAttributeName=[NSSet setWithArray:attributesName];
    [setAttributeName intersectsSet:[options skipAttributes]];
    
    return [setAttributeName allObjects];

}

//faster add dictionary to params
-(NSDictionary*)exportAttributes:(NSArray*)attributesName{
    NSMutableDictionary * dictionary=[[NSMutableDictionary alloc] initWithCapacity:attributesName.count];
    
    for(NSString *attributeName in attributesName){
        //autoreleasepool
        NSAttributeDescription * description=[[self.entity attributesByName] objectForKey:attributeName];
        NSString * key=[description MR_exportKey];
        id value=[description MR_formateValue:[self valueForKey:attributeName]];
        [dictionary setObject:value forKey:key];
        
    
    }
    
    return [dictionary copy];
}







@end
