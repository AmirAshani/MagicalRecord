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
//@property  (MR_nullable,strong,nonatomic) NSString *  ID;

@optional
-(MR_nullable NSSet*)skipAttributes;
-(MR_nullable NSSet*)skipRelationship;
@end


@interface FDMRExportOptions : NSObject <FDMagicalRecord_ExportOptions>
@property (strong,nonatomic) NSString * ID;
-(instancetype)initWithID:(NSString*)ID;
@end

@protocol FDMagicalRecord_ExportOptionsDelegate <NSObject>

@optional
-(MR_nullable FDMRExportOptions*)optionsFromParentOptions:(MR_nullable id<FDMagicalRecord_ExportOptions>)parentOptions;

@end

@interface NSManagedObject (FDMagicalRecordExport) <FDMagicalRecord_ExportOptionsDelegate>

-(MR_nullable NSString*)MR_toJSONWithOptions:(MR_nullable id<FDMagicalRecord_ExportOptions>)options;
-(MR_nullable NSDictionary*)MR_toDictionaryWithOption:(MR_nullable id<FDMagicalRecord_ExportOptions>)options;

@end
