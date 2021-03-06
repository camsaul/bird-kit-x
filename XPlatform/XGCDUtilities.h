//
//  XGCDUtilities.h
//  XPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#ifdef __cplusplus
	extern "C" {
#endif

/// Shorthand for calling dispatch_after() to dispatch on the main thread after some delay.
void dispatch_after_seconds(const double delayInSeconds, dispatch_block_t block);

/// Shorthand for calling dispatch_after() to dispatch on the main thread after a millisecond.
/// Theoretically, this should be just enough time to make the block get executed on the next run loop, which will give you enough
/// Time to do UI updates, etc. before it is called.
void dispatch_next_run_loop(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block)
void dispatch_async_high_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
void dispatch_async_default_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block)
void dispatch_async_low_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
void dispatch_async_background_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_main_queue(), block)
void dispatch_async_main(dispatch_block_t block);

/// shorthand for dispatch_sync(dispatch_get_main_queue(), block)
void dispatch_sync_main(dispatch_block_t block);
	
/// Guarantees that block will be executed syncronously on the main thread.
void guarantee_on_main_thread(void(^block)());
	
#ifdef __cplusplus
	}
#endif

#ifdef __cplusplus // with C++ enabled make fn a template so we can check that the right type is being used in the weakRef block
	/// Helper method to execute a block with a weak reference to an object. Happens syncronously.
	/// \code
	///		with_weak_ref(self, ^(__weak SearchWithLocationViewController *weakRef) {
	///			...
	///		}
	/// \endcode
	template <typename T>
	void with_weak_ref(T obj, void(^weak_ref_block)(__weak id weakRef)) {
		__block __weak T weakRef = obj;
		weak_ref_block(weakRef);
	}
#else
	typedef void(^weak_ref_block_t)(__weak id weakRef);

	/// Helper method to execute a block with a weak reference to an object. Happens syncronously.
	/// \code
	///		with_weak_ref(self, ^(__weak SearchWithLocationViewController *weakRef) {
	///			...
	///		}
	/// \endcode
	void with_weak_ref(id obj, weak_ref_block_t weak_ref_block);
#endif