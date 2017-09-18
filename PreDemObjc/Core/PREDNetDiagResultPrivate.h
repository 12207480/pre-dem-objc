//
//  PREDNetDiagResultPrivate.h
//  PreDemObjc
//
//  Created by WangSiyu on 01/06/2017.
//  Copyright © 2017 pre-engineering. All rights reserved.
//

#import "PREDNetDiagResult.h"
#import "PREDChannel.h"
#import "QNNetDiag.h"

@interface PREDNetDiagResult ()

- (instancetype)initWithComplete:(PREDNetDiagCompleteHandler)complete channel:(PREDChannel *)channel;
- (void)gotTcpResult:(QNNTcpPingResult *)r;
- (void)gotPingResult:(QNNPingResult *)r;
- (void)gotHttpResult:(QNNHttpResult *)r;
- (void)gotTrResult:(QNNTraceRouteResult *)r;
- (void)gotNsLookupResult:(NSArray<QNNRecord *> *) r;
- (NSDictionary *)toDic;

@end
