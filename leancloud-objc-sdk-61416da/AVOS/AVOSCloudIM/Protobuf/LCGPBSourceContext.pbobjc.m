// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: google/protobuf/source_context.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(LCGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define LCGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if LCGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <protobuf/LCGPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "LCGPBProtocolBuffers_RuntimeSupport.h"
#endif

#if LCGPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <protobuf/SourceContext.pbobjc.h>
#else
 #import "LCGPBSourceContext.pbobjc.h"
#endif
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - LCGPBSourceContextRoot

@implementation LCGPBSourceContextRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - LCGPBSourceContextRoot_FileDescriptor

static LCGPBFileDescriptor *LCGPBSourceContextRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static LCGPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    LCGPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[LCGPBFileDescriptor alloc] initWithPackage:@"google.protobuf"
                                                 objcPrefix:@"LCGPB"
                                                     syntax:LCGPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - LCGPBSourceContext

@implementation LCGPBSourceContext

@dynamic fileName;

typedef struct LCGPBSourceContext__storage_ {
  uint32_t _has_storage_[1];
  NSString *fileName;
} LCGPBSourceContext__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (LCGPBDescriptor *)descriptor {
  static LCGPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static LCGPBMessageFieldDescription fields[] = {
      {
        .name = "fileName",
        .dataTypeSpecific.className = NULL,
        .number = LCGPBSourceContext_FieldNumber_FileName,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LCGPBSourceContext__storage_, fileName),
        .flags = LCGPBFieldOptional,
        .dataType = LCGPBDataTypeString,
      },
    };
    LCGPBDescriptor *localDescriptor =
        [LCGPBDescriptor allocDescriptorForClass:[LCGPBSourceContext class]
                                     rootClass:[LCGPBSourceContextRoot class]
                                          file:LCGPBSourceContextRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(LCGPBMessageFieldDescription))
                                   storageSize:sizeof(LCGPBSourceContext__storage_)
                                         flags:LCGPBDescriptorInitializationFlag_None];
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
