//
//  NSManagedObject+FDMagicalRecordExport.h
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/8/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

@protocol   FDMagicalRecord_ExportOptions <NSObject>
@property  (MR_nullable,strong,nonatomic) NSString *  ID;
@property  (MR_nullable,strong,readonly,nonatomic) NSSet  * skipAttributes;
@property  (MR_nullable,strong,readonly,nonatomic) NSSet * skipRelationship;
@property  (MR_nullable,strong,nonatomic) NSNumber* skipInverseRelashionship;



//@optional
//-(MR_nullable NSSet*)skipAttributes; //imputable so one relashionship can not affect others
//-(MR_nullable NSSet*)skipRelationship;
@end




@protocol FDMagicalRecord_ExportOptionsDelegate <NSObject>

@optional
-(MR_nullable id)optionsFromParentOptions:(MR_nullable id<FDMagicalRecord_ExportOptions>)parentOptions;

@end

@interface NSManagedObject (FDMagicalRecordExport) <FDMagicalRecord_ExportOptionsDelegate>

-(MR_nullable NSString*)MR_toJSONWithOptions:(MR_nullable id<FDMagicalRecord_ExportOptions>)options;
-(MR_nullable NSDictionary*)MR_toDictionaryWithOption:(MR_nullable id<FDMagicalRecord_ExportOptions>)options;

@end
