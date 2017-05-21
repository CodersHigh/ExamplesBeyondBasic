//
//  PosterModel.h
//  CinemaKid-ObjC
//
//  Created by Abraham Park on 5/21/17.
//  Copyright © 2017 ebadaq.com. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void(^BlockAfterUpdate)(NSData  * _Nullable dataImage);

@interface PosterModel : NSObject

/** 이미지 업데이트 연결. */
- (void) requestPoster:(NSString *_Nonnull)posterCode afterUpdate:(BlockAfterUpdate _Nullable) blockUpdate;

@end
