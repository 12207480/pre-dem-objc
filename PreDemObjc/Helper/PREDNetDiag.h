//
//  PREDNetDiag.h
//  PreDemObjc
//
//  Created by WangSiyu on 24/05/2017.
//  Copyright © 2017 pre-engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreDemObjc.h"
#import "PREDChannel.h"

@interface PREDNetDiag : NSObject

+ (void)diagnose:(NSString *)host
         channel:(PREDChannel *)channel
        complete:(PREDNetDiagCompleteHandler)complete;

@end
