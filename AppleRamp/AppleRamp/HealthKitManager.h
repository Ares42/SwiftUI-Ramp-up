//
//  HealthKitManager.h
//  AppleRamp
//
//  Created by Luke Solomon on 12/16/20.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HealthCompletionBlock)(BOOL success);

@interface HealthKitManager : NSObject

//@property (nonatomic, retain) NSString *property;

+ (id)shared;

- (void)requestAuthorizationWithCompletion:(HealthCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
