

#import <Foundation/Foundation.h>

@interface MPVolumeButtons : NSObject

@property (nonatomic, copy) dispatch_block_t upBlock;
@property (nonatomic, copy) dispatch_block_t downBlock;
@property (nonatomic, readonly) float launchVolume;

- (void)startStealingVolumeButtonEvents;
- (void)stopStealingVolumeButtonEvents;

@end
