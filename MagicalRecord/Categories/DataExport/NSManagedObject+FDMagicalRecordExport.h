//
//  NSManagedObject+FDMagicalRecordExport.h
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/8/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol   FDMagicalRecord_ExportOptions <NSObject>
@property (strong,nonatomic) NSString * ID;
-(NSSet*)skipAttributes;
-(NSSet*)skipRelationship;
@end

@protocol FDMagicalRecord_ExportOptionsDelegate <NSObject>

@optional
-(instancetype)optionsForParentOptions:(id<FDMagicalRecord_ExportOptions>)parentOptions;

@end

@interface NSManagedObject (FDMagicalRecordExport) <FDMagicalRecord_ExportOptionsDelegate>

-(NSString*)MR_toJSONWithOptions:(id<FDMagicalRecord_ExportOptions>)options;
-(NSDictionary*)MR_toDictionaryWithOption:(id<FDMagicalRecord_ExportOptions>)options;


@end
