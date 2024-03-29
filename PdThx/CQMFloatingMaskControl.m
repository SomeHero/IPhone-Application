//
// CQMFloatingMaskControl.m
// Created by cocopon on 2011/06/03.
//
// Copyright (c) 2012 cocopon <cocopon@me.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "CQMFloatingMaskControl.h"


@implementation CQMFloatingMaskControl {
@private
	id resizeDelegate_;
}


- (void)dealloc {
	[self setResizeDelegate:nil];
	[super dealloc];
}


#pragma mark -
#pragma mark Property


@synthesize resizeDelegate = resizeDelegate_;


- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	SEL selector = @selector(floatingMaskControlDidResize:);
	if ([self.resizeDelegate respondsToSelector:selector]) {
		[self.resizeDelegate performSelector:selector
								  withObject:self];
	}
}


@end
