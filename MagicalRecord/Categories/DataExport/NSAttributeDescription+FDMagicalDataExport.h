//
//  NSAttributeDescription+FDMagicalDataExport.h
//  MagicalRecord
//
//  Created by Ardian Saidi on 8/8/17.
//  Copyright © 2017 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSAttributeDescription (FDMagicalDataExport)
-(NSString*)MR_exportKey;
-(id)MR_formateValue:(id)valueToFormat;
@end
