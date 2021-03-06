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
@property  (MR_nullable,strong,readonly,nonatomic) NSSet<NSString*>  * skipAttributes;
@property  (MR_nullable,strong,readonly,nonatomic) NSSet<NSString*> * skipRelationships;

@property  (assign,nonatomic) BOOL skipInverseRelashionship;
@property  (MR_nullable,nonatomic,strong) NSString* parentEntityClassName;



//@optional
//-(MR_nullable NSSet*)skipAttributes; //imputable so one relashionship can not affect others
//-(MR_nullable NSSet*)skipRelationship;
@end




@protocol FDMagicalRecord_ExportOptionsDelegate <NSObject>

@optional
-(MR_nullable id)optionsFromParentOption:(MR_nullable id<FDMagicalRecord_ExportOptions>)parentOptions;
- (BOOL) shouldExportWithOptions:(MR_nullable id<FDMagicalRecord_ExportOptions>)options;
@end

@interface NSManagedObject (FDMagicalRecordExport) <FDMagicalRecord_ExportOptionsDelegate>

-(MR_nullable NSString*)MR_toJSONWithOption:(MR_nullable id<FDMagicalRecord_ExportOptions>)option;
-(MR_nullable NSDictionary*)MR_toDictionaryWithOption:(MR_nullable id<FDMagicalRecord_ExportOptions>)option;
-(MR_nullable id)MR_exportedValueWithOption:(MR_nullable id<FDMagicalRecord_ExportOptions>)option;

@end
