/*
 * Author: Andreas Linde <mail@andreaslinde.de>
 *
 * Copyright (c) 2012-2014 HockeyApp, Bit Stadium GmbH.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPREDS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import "PreDemObjc.h"
#import "PREDPrivate.h"

#import "PREDHelper.h"

#import "PREDBaseManager.h"
#import "PREDBaseManagerPrivate.h"

#import "PREDKeychainUtils.h"

#import <sys/sysctl.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>

#ifndef __IPHONE_6_1
#define __IPHONE_6_1     60100
#endif

@implementation PREDBaseManager {
    UINavigationController *_navController;
}


- (instancetype)init {
    if ((self = [super init])) {
        _serverURL = PRED_URL;
    }
    return self;
}

- (instancetype)initWithAppIdentifier:(NSString *)appIdentifier appEnvironment:(PREDEnvironment)environment {
    if ((self = [self init])) {
        _appIdentifier = appIdentifier;
        _appEnvironment = environment;
    }
    return self;
}


#pragma mark - Private

- (void)reportError:(NSError *)error {
    PREDLogError(@"%@", [error localizedDescription]);
}

- (NSString *)encodedAppIdentifier {
    return [PREDHelper encodeAppIdentifier:_appIdentifier];
}

#pragma mark - Manager Control

- (void)startManager {
}

#pragma mark - Helpers


@end
