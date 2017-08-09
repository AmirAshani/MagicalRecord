//
//  NSManagedObject+FDMagicalRecordExport.m
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/8/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+FDMagicalRecordExport.h"
#import "NSAttributeDescription+FDMagicalDataExport.h"
#import "NSRelationshipDescription+FDMagicalRecordExport.h"



@implementation NSManagedObject (FDMagicalRecordExport)

-(NSString*)MR_toJSONWithOptions:(id<FDMagicalRecord_ExportOptions>)options{
    
    NSDictionary * dictionary=[self MR_toDictionaryWithOption:options];
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
    NSDictionary * dicAttributes=[self exportAttributes:attributesNameToExport];
    
    NSArray * relashionshipsNameToExport=[self relashionshipsToExport:options];
    NSDictionary * dicRelashionship=[self exportRelashionships:relashionshipsNameToExport withOptions:options];
    
    NSMutableDictionary * returnValue=[[NSMutableDictionary alloc] init];
    [returnValue addEntriesFromDictionary:dicAttributes];
    [returnValue addEntriesFromDictionary:dicRelashionship];
    
    return [returnValue copy];
    
}



-(NSArray*)attributesNameToExport:(id<FDMagicalRecord_ExportOptions>)options{
    NSArray* attributesName=self.entity.attributesByName.allKeys;
    
    if(options==nil){
        return attributesName;
    }
    if(![options respondsToSelector:@selector(skipAttributes)]){
        return attributesName;
    }
    
    NSMutableSet * setAttributeName=[NSMutableSet setWithArray:attributesName];
    [setAttributeName minusSet:[options skipAttributes]];
    
    return [setAttributeName allObjects];

}

//faster add dictionary to params
-(NSDictionary*)exportAttributes:(NSArray*)attributesName{
    NSMutableDictionary * dictionary=[[NSMutableDictionary alloc] initWithCapacity:attributesName.count];
    
    for(NSString *attributeName in attributesName){
        //autoreleasepool // move attirbutes name outside for scope access just once
        NSAttributeDescription * description=[[self.entity attributesByName] objectForKey:attributeName];
        NSString * key=[description MR_exportKey];
        id value=[description MR_formateValue:[self valueForKey:attributeName]];
        [dictionary setObject:value forKey:key];
        
    
    }
    
    return [dictionary copy];
}

-(NSArray*)relashionshipsToExport:(id<FDMagicalRecord_ExportOptions>)options{
    NSArray* relashionshipsName=self.entity.relationshipsByName.allKeys;
    
    if(options==nil){
        return relashionshipsName;
    }
    
    if(![options respondsToSelector:@selector(skipRelationship)]){
        return relashionshipsName;
    }
    
    
    NSMutableSet * setRelashionshipName=[NSMutableSet setWithArray:relashionshipsName];
    [setRelashionshipName minusSet:[options skipRelationship]];
    
    return [setRelashionshipName allObjects];
}


//how to handle reference cycle in relashionship
// 1: add  relashionship to options and do not handle those that are handled
// 2: every child entity (relashionship) for own subrelashionship has ability to redefine rules (include // exclude , graph )


-(NSDictionary*)exportRelashionships:(NSArray*)relashionshipsName withOptions:(id<FDMagicalRecord_ExportOptions>)options{
    
    NSMutableDictionary * relashionshipsDictionary=[[NSMutableDictionary alloc] initWithCapacity:relashionshipsName.count];
    
    for( NSString * relashionshipName in relashionshipsName){
        
        NSRelationshipDescription * description=[[self.entity relationshipsByName] objectForKey:relashionshipName];
        NSString * key=[description MR_exportKey];
        
        if([description isToMany]){
            
        }else{
            
            id<FDMagicalRecord_ExportOptions> optionForRelashionship;
            id relashionshipEntity=[self valueForKey:relashionshipName];
            id value=nil;
            
            
            if([relashionshipEntity respondsToSelector:@selector(optionsFromParentOptions:)]){
                optionForRelashionship=[relashionshipEntity performSelector:@selector(optionsFromParentOptions:) withObject:options];
            }else{
                optionForRelashionship=options;
            }
            
            NSDictionary * valueDic=[relashionshipEntity MR_toDictionaryWithOption:optionForRelashionship];
            if(valueDic == nil || valueDic.allKeys.count ==0 ){
                value=[NSNull null];
            }else{
                value=valueDic;
            }
            
            
            [relashionshipsDictionary setObject:value forKey:key];
            
            
        }
        
    }
    
    return relashionshipsDictionary;
    
}






@end
