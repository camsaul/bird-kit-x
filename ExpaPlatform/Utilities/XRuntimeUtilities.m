//
//  XRuntimeUtilities.m
//  ExpaPlatform
//
//  Created by Cam Saul on 12/21/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XRuntimeUtilities.h"
#import <objc/runtime.h>

void swizzle_with_block(Class cls, SEL sel, swizzle_with_block_t(^block)(SEL sel, void(*orig_fptr)(id _self, SEL _sel, ...))) {
	Method orig_method = class_getInstanceMethod(cls, sel);
	IMP orig_imp = method_getImplementation(orig_method);
	
	id _swzz_blck = block(sel, (void *)orig_imp);
	
	// store the block as an associated object so it gets copied onto heap
	const char *assoc_key = sel_getName(sel);
	objc_setAssociatedObject(cls, assoc_key, _swzz_blck, OBJC_ASSOCIATION_COPY_NONATOMIC);
	id swzz_blck = objc_getAssociatedObject(cls, assoc_key);
	
	IMP swizz_imp = imp_implementationWithBlock(swzz_blck);
	class_replaceMethod(cls, sel, swizz_imp, method_getTypeEncoding(orig_method));
}

void add_method_with_block(Class cls, const char *name, id _block){
	struct _block_descriptor_t {
		unsigned long reserved;
		unsigned long size;
		void *rest[1];
	};
	
	struct _block_t {
		void *isa;
		int flags;
		int reserved;
		void *invoke;
		struct _block_descriptor_t *descriptor;
	};
	
	static const int flag_copy_dispose = 1 << 25;
    static const int flag_has_signature = 1 << 30;
	
	SEL sel = sel_registerName(name);
	
	const char *assoc_key = sel_getName(sel);
	objc_setAssociatedObject(cls, assoc_key, _block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	id block = objc_getAssociatedObject(cls, assoc_key);
	struct _block_t *block_struct = (__bridge void *)block;
	
	if (!(block_struct->flags & flag_has_signature)) {
		@throw [[NSException alloc] initWithName:[NSString stringWithFormat:@"add_method_with_block(%@, %s, ...) failed", NSStringFromClass(cls), name] reason:@"Block does not have a method signature." userInfo:nil];
	}
	
	const int index = (block_struct->flags & flag_copy_dispose) ? 2 : 0;
    const char *types = block_struct->descriptor->rest[index];
	
	IMP imp = imp_implementationWithBlock(block);
	
	class_addMethod(cls, sel, imp, types);
}


void debug_class_dump_methods(const id cls) {
	unsigned numMethods;
	const Method * const methods = class_copyMethodList(cls, &numMethods);
	for (int i = 0; i < numMethods; i++) {
		const Method m = methods[i];
		printf("%s %s\n", sel_getName(method_getName(m)), method_getTypeEncoding(m));
	}
	
	Class superclass = [cls superclass];
	const char *name = class_getName(superclass);
	printf("\nsuperclass: %s\n", name);
	if (!strcmp(name, "NSObject")) {
		debug_class_dump_methods(superclass);
	} else {
		printf("[END]\n\n\n");
	}
}