//
//  NSRelationshipDescription+FDMagicalRecordExport.m
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/9/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import "NSRelationshipDescription+FDMagicalRecordExport.h"
#import "NSManagedObject+MagicalDataImport.h"
#import "FDMagicalExportFunctions.h"

@implementation NSRelationshipDescription (FDMagicalRecordExport)
-(NSString*)MR_exportKey{
    NSString * relashionshipName=[self.userInfo objectForKey:kMagicalRecordImportRelationshipMapKey];
    return relashionshipName.length > 0 ? relashionshipName: self.name;
}






@end
