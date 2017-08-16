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

-(NSString*)MR_toJSONWithOption:(id<FDMagicalRecord_ExportOptions>)option{
    
    NSDictionary * dictionary=[self MR_toDictionaryWithOption:option];
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


-(NSDictionary*)MR_toDictionaryWithOption:(id<FDMagicalRecord_ExportOptions>)option{
    
    return [self MR_exportedValueWithOption:option];

    
//    NSArray * attributesNameToExport=[self attributesNameToExport:options];
//    NSDictionary * dicAttributes=[self exportAttributes:attributesNameToExport];
//    
//    NSArray * relashionshipsNameToExport=[self relashionshipsToExport:options];
//    NSDictionary * dicRelashionship=[self exportRelashionships:relashionshipsNameToExport withOptions:options];
//    
//    NSMutableDictionary * returnValue=[[NSMutableDictionary alloc] init];
//    [returnValue addEntriesFromDictionary:dicAttributes];
//    [returnValue addEntriesFromDictionary:dicRelashionship];
//    
//    return [returnValue copy];
    
}


-(id)MR_exportedValueWithOption:(id<FDMagicalRecord_ExportOptions>)option{
    NSArray * attributesNameToExport=[self attributesNameToExport:option];
    NSDictionary * dicAttributes=[self exportAttributes:attributesNameToExport];
    
    NSArray * relashionshipsNameToExport=[self relashionshipsToExport:option];
    NSDictionary * dicRelashionship=[self exportRelashionships:relashionshipsNameToExport withOptions:option];
    
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
        @autoreleasepool {
            
            NSAttributeDescription * description=[[self.entity attributesByName] objectForKey:attributeName];
            NSString * key=[description MR_exportKey];
            id value=[description MR_formateValue:[self valueForKey:attributeName]];
            [dictionary setObject:value forKey:key];
            
         
        }
        
    
    }
    
    return [dictionary copy];
}

-(NSArray*)relashionshipsToExport:(id<FDMagicalRecord_ExportOptions>)options{
    NSArray* relashionshipsName=self.entity.relationshipsByName.allKeys;
    
    if(options==nil){
        return relashionshipsName;
    }
    
    NSMutableSet * setRelashionshipName;
    
    if(options.skipInverseRelashionship){
        
        if(setRelashionshipName==nil){
            setRelashionshipName=[NSMutableSet setWithArray:relashionshipsName];
        }
        
        [setRelashionshipName removeObject:[self inverseRelashionShip:options.parentEntityClassName]];
        
        
    }
    
    if(options.skipRelationships != nil && options.skipRelationships.count>0){
        if(setRelashionshipName==nil){
            setRelashionshipName=[NSMutableSet setWithArray:relashionshipsName];
        }
        
        [setRelashionshipName minusSet:options.skipRelationships];
        
    }
    
    if(setRelashionshipName==nil){
        return relashionshipsName;
    }
    
    
    
    
    return [setRelashionshipName allObjects];
}

-(NSString*)inverseRelashionShip:(NSString*)parentEntityClassName{
    __block NSString *  inverseKey=@"";
    [self.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSRelationshipDescription * _Nonnull relashionshipDescription, BOOL * _Nonnull stop) {
        if([relashionshipDescription.destinationEntity.name isEqualToString:parentEntityClassName]){
            inverseKey=key;
            *stop=true;
        }
    }];
    return inverseKey;
}


//how to handle reference cycle in relashionship
// 1: add  relashionship to options and do not handle those that are handled
// 2: every child entity (relashionship) for own subrelashionship has ability to redefine rules (include // exclude , graph )


-(NSDictionary*)exportRelashionships:(NSArray*)relashionshipsName withOptions:(id<FDMagicalRecord_ExportOptions>)options{
    
    if(options!=nil){
        options.parentEntityClassName=self.entity.name;
    }
    
    
    NSMutableDictionary * relashionshipsDictionary=[[NSMutableDictionary alloc] initWithCapacity:relashionshipsName.count];
    
    for( NSString * relashionshipName in relashionshipsName){
        
        @autoreleasepool {
        
        NSRelationshipDescription * description=[[self.entity relationshipsByName] objectForKey:relashionshipName];
        NSString * key=[description MR_exportKey];
        
        
        if([description isToMany]){
            
            id value=nil;
            
            NSSet * relashionshipSet=[self valueForKey:relashionshipName];
            if(relashionshipSet.count==0){
                value=[NSMutableArray array];
            }else{
                id<FDMagicalRecord_ExportOptions> optionForRelashionship;
                
                
                
                value=[[NSMutableArray alloc] initWithCapacity:relashionshipSet.count];
                
                for(NSManagedObject * relashionshipEntity in relashionshipSet){
                    
                    //refactor make a copy of releashionship so child can not edit
                    if([relashionshipEntity respondsToSelector:@selector(optionsFromParentOption:)]){
                        optionForRelashionship=[relashionshipEntity performSelector:@selector(optionsFromParentOption:) withObject:options];
                    }else{
                        optionForRelashionship=options;
                    }
                    
                    if([relashionshipEntity respondsToSelector:@selector(shouldExportWithOptions:)]){
                        if([relashionshipEntity performSelector:@selector(optionsFromParentOption:) withObject:optionForRelashionship] == false){
                            continue;
                        }
                    
                    }
                    id relashionshipValue=[relashionshipEntity MR_exportedValueWithOption:options];
                    
                    if(relashionshipValue==nil){
                        continue;
                    }
                    
                    
                    if([relashionshipValue isKindOfClass:[NSDictionary class]] &&  ((NSDictionary*)relashionshipValue).allKeys.count == 0){
                        continue;
                    }
                        
                    
                    [value addObject:relashionshipValue];
                    
                    
                
                }
                
//                if([value count]==0){
//                    value=[NSNull null];
//                }

            }
            
            [relashionshipsDictionary setObject:value forKey:key];
            
            

        }else{
            
            id<FDMagicalRecord_ExportOptions> optionForRelashionship;
            id relashionshipEntity=[self valueForKey:relashionshipName];
            
            
            
            if([relashionshipEntity respondsToSelector:@selector(optionsFromParentOption:)]){
                optionForRelashionship=[relashionshipEntity performSelector:@selector(optionsFromParentOption:) withObject:options];
            }else{
                optionForRelashionship=options;
            }
            
            
            if([relashionshipEntity respondsToSelector:@selector(shouldExportWithOptions:)]){
                if([relashionshipEntity performSelector:@selector(optionsFromParentOption:) withObject:options] == false){
                    return relashionshipsDictionary;
                }
                
            }
            
            
            id relashionshipValue=[relashionshipEntity MR_exportedValueWithOption:options];
            
            if(relashionshipValue==nil){
                [relashionshipsDictionary setObject:[NSNull null] forKey:key];
                return relashionshipsDictionary;
            }
            
            
            if([relashionshipValue isKindOfClass:[NSDictionary class]] &&  ((NSDictionary*)relashionshipValue).allKeys.count == 0){
                [relashionshipsDictionary setObject:[NSNull null] forKey:key];
                return relashionshipsDictionary;
            }
            
    
            [relashionshipsDictionary setObject:relashionshipValue forKey:key];
            
            
        }
    }
        
    }
    
    return relashionshipsDictionary;
    
}






@end
