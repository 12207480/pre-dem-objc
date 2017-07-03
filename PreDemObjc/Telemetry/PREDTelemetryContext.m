#import <Foundation/Foundation.h>
#import "PREDTelemetryContext.h"
#import "PREDMetricsManagerPrivate.h"
#import "PREDHelper.h"
#import "PREDPersistence.h"
#import "PREDPersistencePrivate.h"

NSString *const kPREDUserMetaData = @"PREDUserMetaData";

static char *const PREDContextOperationsQueue = "net.hockeyapp.telemetryContextQueue";

@implementation PREDTelemetryContext

@synthesize appIdentifier = _appIdentifier;
@synthesize persistence = _persistence;

#pragma mark - Initialisation

-(instancetype)init {
    
    if(self = [super init]) {
        _operationsQueue = dispatch_queue_create(PREDContextOperationsQueue, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)initWithAppIdentifier:(NSString *)appIdentifier persistence:(PREDPersistence *)persistence {
    
    if ((self = [self init])) {
        _persistence = persistence;
        _appIdentifier = appIdentifier;
        PREDDevice *deviceContext = [PREDDevice new];
        deviceContext.model = PREDHelper.deviceModel;
        deviceContext.type = PREDHelper.deviceType;
        deviceContext.osVersion = PREDHelper.osVersionBuild;
        deviceContext.os = PREDHelper.osPlatform;
        deviceContext.deviceId = PREDHelper.appAnonID;
        deviceContext.locale = PREDHelper.deviceLocale;
        deviceContext.language = PREDHelper.deviceLanguage;
        deviceContext.screenResolution = PREDHelper.screenSize;
        deviceContext.oemName = @"Apple";
        
        PREDInternal *internalContext = [PREDInternal new];
        internalContext.sdkVersion = PREDHelper.sdkVersion;
        
        PREDApplication *applicationContext = [PREDApplication new];
        applicationContext.version = PREDHelper.appVersion;
        
        PREDUser *userContext = [self loadUser];
        if (!userContext) {
            userContext = [self newUser];
            [self saveUser:userContext];
        }
        
        PREDSession *sessionContext = [PREDSession new];
        
        _application = applicationContext;
        _device = deviceContext;
        _user = userContext;
        _internal = internalContext;
        _session = sessionContext;
        _tags = [self tags];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - User

- (PREDUser *)newUser {
    return ({
        PREDUser *user = [PREDUser new];
        user.userId = PREDHelper.appAnonID;
        user;
    });
}

- (void)saveUser:(PREDUser *)user{
    NSDictionary *userMetaData = @{kPREDUserMetaData : user};
    [self.persistence persistMetaData:userMetaData];
}

- (nullable PREDUser *)loadUser{
    NSDictionary *metaData =[self.persistence metaData];
    PREDUser *user = [metaData objectForKey:kPREDUserMetaData];
    return user;
}

#pragma mark - Network

#pragma mark - Getter/Setter properties

- (NSString *)appIdentifier {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _appIdentifier;
    });
    return tmp;
}

- (void)setAppIdentifier:(NSString *)appIdentifier {
    NSString* tmp = [appIdentifier copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _appIdentifier = tmp;
    });
}

- (NSString *)screenResolution {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.screenResolution;
    });
    return tmp;
}

- (void)setScreenResolution:(NSString *)screenResolution {
    NSString* tmp = [screenResolution copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.screenResolution = tmp;
    });
}

- (NSString *)appVersion {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _application.version;
    });
    return tmp;
}

- (void)setAppVersion:(NSString *)appVersion {
    NSString* tmp = [appVersion copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _application.version = tmp;
    });
}

- (NSString *)anonymousUserId {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _user.userId;
    });
    return tmp;
}

- (void)setAnonymousUserId:(NSString *)userId {
    NSString* tmp = [userId copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _user.userId = tmp;
    });
}

- (NSString *)anonymousUserAquisitionDate {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _user.anonUserAcquisitionDate;
    });
    return tmp;
}

- (void)setAnonymousUserAquisitionDate:(NSString *)anonymousUserAquisitionDate {
    NSString* tmp = [anonymousUserAquisitionDate copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _user.anonUserAcquisitionDate = tmp;
    });
}

- (NSString *)sdkVersion {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _internal.sdkVersion;
    });
    return tmp;
}

- (void)setSdkVersion:(NSString *)sdkVersion {
    NSString* tmp = [sdkVersion copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _internal.sdkVersion = tmp;
    });
}

- (NSString *)sessionId {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _session.sessionId;
    });
    return tmp;
}

- (void)setSessionId:(NSString *)sessionId {
    NSString* tmp = [sessionId copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _session.sessionId = tmp;
    });
}

- (NSString *)isFirstSession {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _session.isFirst;
    });
    return tmp;
}

- (void)setIsFirstSession:(NSString *)isFirstSession {
    NSString* tmp = [isFirstSession copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _session.isFirst = tmp;
    });
}

- (NSString *)isNewSession {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _session.isNew;
    });
    return tmp;
}

- (void)setIsNewSession:(NSString *)isNewSession {
    NSString* tmp = [isNewSession copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _session.isNew = tmp;
    });
}

- (NSString *)osVersion {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.osVersion;
    });
    return tmp;
}

- (void)setOsVersion:(NSString *)osVersion {
    NSString* tmp = [osVersion copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.osVersion = tmp;
    });
}

- (NSString *)osName {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.os;
    });
    return tmp;
}

- (void)setOsName:(NSString *)osName {
    NSString* tmp = [osName copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.os = tmp;
    });
}

- (NSString *)deviceModel {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.model;
    });
    return tmp;
}

- (void)setDeviceModel:(NSString *)deviceModel {
    NSString* tmp = [deviceModel copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.model = tmp;
    });
}

- (NSString *)deviceOemName {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.oemName;
    });
    return tmp;
}

- (void)setDeviceOemName:(NSString *)oemName {
    NSString* tmp = [oemName copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.oemName = tmp;
    });
}

- (NSString *)osLocale {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.locale;
    });
    return tmp;
}

- (void)setOsLocale:(NSString *)osLocale {
    NSString* tmp = [osLocale copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.locale = tmp;
    });
}

- (NSString *)osLanguage {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.language;
    });
    return tmp;
}

- (void)setOsLanguage:(NSString *)osLanguage {
    NSString* tmp = [osLanguage copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.language = tmp;
    });
}

- (NSString *)deviceId {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.deviceId;
    });
    return tmp;
}

- (void)setDeviceId:(NSString *)deviceId {
    NSString* tmp = [deviceId copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.deviceId = tmp;
    });
}

- (NSString *)deviceType {
    __block NSString *tmp;
    dispatch_sync(_operationsQueue, ^{
        tmp = _device.type;
    });
    return tmp;
}

- (void)setDeviceType:(NSString *)deviceType {
    NSString* tmp = [deviceType copy];
    dispatch_barrier_async(_operationsQueue, ^{
        _device.type = tmp;
    });
}

#pragma mark - Custom getter
#pragma mark - Helper

- (NSDictionary *)contextDictionary {
    NSMutableDictionary *contextDictionary = [NSMutableDictionary new];
    [contextDictionary addEntriesFromDictionary:self.tags];
    [contextDictionary addEntriesFromDictionary:[self.session serializeToDictionary]];
    [contextDictionary addEntriesFromDictionary:[self.user serializeToDictionary]];
    
    return contextDictionary;
}

- (NSDictionary *)tags {
    if(!_tags){
        NSMutableDictionary *tags = [self.application serializeToDictionary].mutableCopy;
        [tags addEntriesFromDictionary:[self.application serializeToDictionary]];
        [tags addEntriesFromDictionary:[self.internal serializeToDictionary]];
        [tags addEntriesFromDictionary:[self.device serializeToDictionary]];
        _tags = tags;
    }
    return _tags;
}

@end