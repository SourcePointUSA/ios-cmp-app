#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

@class SPMCKotlinx_serialization_jsonJsonElement, SPMCSPMessageLanguage, SPMCMessageToDisplay, SPMCSPError, SPMCSPAction, SPMCSPUserData, SPMCSPPropertyName, SPMCSPCampaigns, SPMCState, SPMCRepository, SPMCSPIDFAStatus, SPMCOSName, SPMCKotlinEnumCompanion, SPMCKotlinEnum<E>, SPMCKotlinArray<T>, SPMCKotlinThrowable, SPMCKotlinException, SPMCSPCampaignType, SPMCMessagesResponseMessage, SPMCMessagesResponseMessageMetaData, SPMCMessageToDisplayCompanion, SPMCMessagesResponseCampaign<ConsentClass>, SPMCSPActionType, SPMCSPActionCompanion, SPMCIncludeDataGPPConfig, SPMCSPCampaign, SPMCSPCampaignEnvCompanion, SPMCSPCampaignEnv, SPMCSPCampaignTypeCompanion, SPMCSPIDFAStatusCompanion, SPMCSPMessageLanguageSerializer, SPMCSPPropertyNameCompanion, SPMCSPPropertyNameSerializer, SPMCAttCampaignCompanion, SPMCAttCampaign, SPMCKotlinx_datetimeInstant, SPMCCCPAConsentCCPAConsentStatus, SPMCKotlinx_serialization_jsonJsonPrimitive, SPMCCCPAConsentCompanion, SPMCCCPAConsent, SPMCCCPAConsentCCPAConsentStatusCompanion, SPMCConsentStatusConsentStatusGranularStatus, SPMCConsentStatusCompanion, SPMCConsentStatus, SPMCConsentStatusConsentStatusGranularStatusCompanion, SPMCGDPRConsentVendorGrantsValue, SPMCGDPRConsentGCMStatus, SPMCGDPRConsentCompanion, SPMCGDPRConsent, SPMCGDPRConsentGCMStatusCompanion, SPMCGDPRConsentVendorGrantsValueCompanion, SPMCUserConsents, SPMCGlobalCmpConsentCompanion, SPMCGlobalCmpConsent, SPMCPreferencesConsentPreferencesStatus, SPMCPreferencesConsentCompanion, SPMCPreferencesConsent, SPMCPreferencesConsentPreferencesStatusPreferencesChannels, SPMCPreferencesConsentPreferencesSubType, SPMCPreferencesConsentPreferencesStatusCompanion, SPMCPreferencesConsentPreferencesStatusPreferencesChannelsCompanion, SPMCPreferencesConsentPreferencesSubTypeCompanion, SPMCSPUserDataSPConsent<ConsentType>, SPMCUSNatConsent, SPMCSPUserDataCompanion, SPMCSPUserDataSPWebConsents, SPMCSPUserDataSPConsentCompanion, SPMCSPUserDataSPWebConsentsSPWebConsent, SPMCSPUserDataSPWebConsentsCompanion, SPMCSPUserDataSPWebConsentsSPWebConsentCompanion, SPMCStateGDPRState, SPMCStateCCPAState, SPMCStateUSNatState, SPMCStateGlobalCmpState, SPMCStatePreferencesState, SPMCStateCompanion, SPMCStateCCPAStateCCPAMetaData, SPMCStateCCPAStateCompanion, SPMCStateCCPAStateCCPAMetaDataCompanion, SPMCStateGDPRStateGDPRMetaData, SPMCStateGDPRStateCompanion, SPMCStateGDPRStateGDPRMetaDataCompanion, SPMCStateGlobalCmpStateGlobalCmpMetaData, SPMCStateGlobalCmpStateCompanion, SPMCStateGlobalCmpStateGlobalCmpMetaDataCompanion, SPMCStatePreferencesStatePreferencesMetaData, SPMCStatePreferencesStateCompanion, SPMCStatePreferencesStatePreferencesMetaDataCompanion, SPMCStateUSNatStateUsNatMetaData, SPMCStateUSNatStateCompanion, SPMCStateUSNatStateUsNatMetaDataCompanion, SPMCUSNatConsentUSNatConsentSection, SPMCUSNatConsentCompanion, SPMCUSNatConsentUSNatConsentSectionCompanion, SPMCUserConsentsConsentable, SPMCUserConsentsCompanion, SPMCUserConsentsConsentableCompanion, SPMCErrorMetricsRequestCompanion, SPMCErrorMetricsRequest, SPMCPlatformHttpClientCompanion, SPMCKtor_client_coreHttpClient, SPMCChoiceAllRequestChoiceAllCampaigns, SPMCChoiceAllResponse, SPMCConsentStatusRequestMetaData, SPMCConsentStatusResponse, SPMCMessagesRequest, SPMCMessagesResponse, SPMCMetaDataRequestCampaigns, SPMCMetaDataResponse, SPMCCCPAChoiceRequest, SPMCCCPAChoiceResponse, SPMCGDPRChoiceRequest, SPMCGDPRChoiceResponse, SPMCGlobalCmpChoiceRequest, SPMCGlobalCmpChoiceResponse, SPMCPreferencesChoiceRequest, SPMCPreferencesChoiceResponse, SPMCUSNatChoiceRequest, SPMCUSNatChoiceResponse, SPMCPvDataRequest, SPMCPvDataResponse, SPMCDeviceInformation, SPMCIncludeData, SPMCCCPAChoiceRequestCompanion, SPMCDefaultRequestCompanion, SPMCDefaultRequest, SPMCChoiceAllRequestCompanion, SPMCChoiceAllRequest, SPMCChoiceAllRequestChoiceAllCampaignsCampaign, SPMCChoiceAllRequestChoiceAllCampaignsCompanion, SPMCChoiceAllRequestChoiceAllCampaignsCampaignCompanion, SPMCConsentStatusRequestCompanion, SPMCConsentStatusRequest, SPMCConsentStatusRequestMetaDataCampaign, SPMCConsentStatusRequestMetaDataGlobalCmpCampaign, SPMCConsentStatusRequestMetaDataUSNatCampaign, SPMCConsentStatusRequestMetaDataPreferencesCampaign, SPMCConsentStatusRequestMetaDataCompanion, SPMCConsentStatusRequestMetaDataCampaignCompanion, SPMCConsentStatusRequestMetaDataGlobalCmpCampaignCompanion, SPMCConsentStatusRequestMetaDataPreferencesCampaignCompanion, SPMCConsentStatusRequestMetaDataUSNatCampaignCompanion, SPMCCustomConsentRequestCompanion, SPMCCustomConsentRequest, SPMCDeleteCustomConsentRequestCompanion, SPMCDeleteCustomConsentRequest, SPMCGDPRChoiceRequestCompanion, SPMCGlobalCmpChoiceRequestCompanion, SPMCIDFAStatusReportRequestAppleTrackingPayload, SPMCIDFAStatusReportRequestCompanion, SPMCIDFAStatusReportRequest, SPMCIDFAStatusReportRequestAppleTrackingPayloadCompanion, SPMCIncludeDataTypeString, SPMCIncludeDataCompanion, SPMCIncludeDataMspaBinaryFlag, SPMCIncludeDataMspaTernaryFlag, SPMCIncludeDataGPPConfigCompanion, SPMCIncludeDataMspaBinaryFlagCompanion, SPMCIncludeDataMspaTernaryFlagCompanion, SPMCIncludeDataTypeStringCompanion, SPMCMessagesRequestBody, SPMCMessagesRequestMetaData, SPMCMessagesRequestCompanion, SPMCMessagesRequestBodyCampaigns, SPMCMessagesRequestBodyCompanion, SPMCMessagesRequestBodyCampaignsCampaign, SPMCMessagesRequestBodyCampaignsIOS14Campaign, SPMCMessagesRequestBodyCampaignsCCPACampaign, SPMCMessagesRequestBodyCampaignsCompanion, SPMCMessagesRequestBodyCampaignsCCPACampaignCompanion, SPMCMessagesRequestBodyCampaignsCampaignCompanion, SPMCMessagesRequestBodyCampaignsIOS14CampaignCompanion, SPMCMessagesRequestMetaDataCampaign, SPMCMessagesRequestMetaDataCompanion, SPMCMessagesRequestMetaDataCampaignCompanion, SPMCMetaDataRequestCompanion, SPMCMetaDataRequest, SPMCMetaDataRequestCampaignsCampaign, SPMCMetaDataRequestCampaignsCompanion, SPMCMetaDataRequestCampaignsCampaignCompanion, SPMCPreferencesChoiceRequestCompanion, SPMCPvDataRequestGDPR, SPMCPvDataRequestCCPA, SPMCPvDataRequestUSNat, SPMCPvDataRequestGlobalCmp, SPMCPvDataRequestCompanion, SPMCPvDataRequestCCPACompanion, SPMCPvDataRequestGDPRCompanion, SPMCPvDataRequestGlobalCmpCompanion, SPMCPvDataRequestUSNatCompanion, SPMCUSNatChoiceRequestCompanion, SPMCCCPAChoiceResponseCompanion, SPMCChoiceAllResponseGDPR, SPMCChoiceAllResponseCCPA, SPMCChoiceAllResponseUSNAT, SPMCChoiceAllResponseGLOBALCMP, SPMCChoiceAllResponseCompanion, SPMCChoiceAllResponseCCPACompanion, SPMCChoiceAllResponseGDPRPostPayload, SPMCChoiceAllResponseGDPRCompanion, SPMCChoiceAllResponseGDPRPostPayloadCompanion, SPMCChoiceAllResponseGLOBALCMPCompanion, SPMCChoiceAllResponseUSNATCompanion, SPMCConsentStatusResponseConsentStatusData, SPMCConsentStatusResponseCompanion, SPMCConsentStatusResponseConsentStatusDataCompanion, SPMCGDPRChoiceResponseCompanion, SPMCGlobalCmpChoiceResponseCompanion, SPMCMessagesResponseMessageMetaDataMessageCategory, SPMCMessagesResponseMessageMetaDataMessageSubCategory, SPMCMessagesResponseMessageGDPRCategory, SPMCMessageWithCategorySubCategoryCompanion, SPMCMessageWithCategorySubCategory, SPMCMessagesResponseCompanion, SPMCMessagesResponseCampaignCompanion, SPMCMessagesResponseCCPACompanion, SPMCMessagesResponseCCPA, SPMCMessagesResponseGDPRCompanion, SPMCMessagesResponseGDPR, SPMCMessagesResponseGlobalCmpCompanion, SPMCMessagesResponseGlobalCmp, SPMCKotlinNothing, SPMCMessagesResponseIos14Companion, SPMCMessagesResponseIos14, SPMCMessagesResponseMessageCompanion, SPMCMessagesResponseMessageGDPRCategoryCategoryType, SPMCMessagesResponseMessageGDPRCategoryVendor, SPMCMessagesResponseMessageGDPRCategoryCompanion, SPMCMessagesResponseMessageGDPRCategoryCategoryTypeCompanion, SPMCStringEnumWithDefaultSerializer<T>, SPMCMessagesResponseMessageGDPRCategoryCategoryTypeSerializer, SPMCMessagesResponseMessageGDPRCategoryVendorVendorType, SPMCMessagesResponseMessageGDPRCategoryVendorCompanion, SPMCMessagesResponseMessageGDPRCategoryVendorVendorTypeCompanion, SPMCMessagesResponseMessageGDPRCategoryVendorVendorTypeSerializer, SPMCMessagesResponseMessageMetaDataCompanion, SPMCMessagesResponseMessageMetaDataMessageCategoryCompanion, SPMCIntEnumSerializer<T>, SPMCMessagesResponseMessageMetaDataMessageCategorySerializer, SPMCMessagesResponseMessageMetaDataMessageSubCategoryCompanion, SPMCMessagesResponseMessageMetaDataMessageSubCategorySerializer, SPMCMessagesResponsePreferencesCompanion, SPMCMessagesResponsePreferences, SPMCMessagesResponseUSNatCompanion, SPMCMessagesResponseUSNat, SPMCMetaDataResponseMetaDataResponseGDPR, SPMCMetaDataResponseMetaDataResponseGlobalCmp, SPMCMetaDataResponseMetaDataResponseUSNat, SPMCMetaDataResponseMetaDataResponseCCPA, SPMCMetaDataResponseMetaDataResponsePreferences, SPMCMetaDataResponseCompanion, SPMCMetaDataResponseMetaDataResponseCCPACompanion, SPMCMetaDataResponseMetaDataResponseGDPRCompanion, SPMCMetaDataResponseMetaDataResponseGlobalCmpCompanion, SPMCMetaDataResponseMetaDataResponsePreferencesCompanion, SPMCMetaDataResponseMetaDataResponseUSNatCompanion, SPMCPreferencesChoiceResponseCompanion, SPMCPvDataResponseCampaign, SPMCPvDataResponseCompanion, SPMCPvDataResponseCampaignCompanion, SPMCUSNatChoiceResponseCompanion, SPMCRepositoryCompanion, SPMCKotlinx_datetimeInstantCompanion, SPMCKotlinx_serialization_jsonJson, SPMCKotlinRuntimeException, SPMCKotlinIllegalStateException, SPMCKotlinx_serialization_jsonJsonElementCompanion, SPMCKotlinx_serialization_coreSerializersModule, SPMCKotlinx_serialization_coreSerialKind, SPMCKotlinx_serialization_jsonJsonPrimitiveCompanion, SPMCKtor_client_coreHttpClientEngineConfig, SPMCKtor_client_coreHttpClientConfig<T>, SPMCKtor_eventsEvents, SPMCKtor_client_coreHttpReceivePipeline, SPMCKtor_client_coreHttpRequestPipeline, SPMCKtor_client_coreHttpResponsePipeline, SPMCKtor_client_coreHttpSendPipeline, SPMCKtor_client_coreHttpRequestData, SPMCKtor_client_coreHttpResponseData, SPMCKotlinx_coroutines_coreCoroutineDispatcher, SPMCKotlinx_serialization_jsonJsonDefault, SPMCKotlinx_serialization_jsonJsonConfiguration, SPMCKtor_utilsAttributeKey<T>, SPMCKtor_client_coreProxyConfig, SPMCKtor_eventsEventDefinition<T>, SPMCKtor_utilsPipelinePhase, SPMCKtor_utilsPipeline<TSubject, TContext>, SPMCKtor_client_coreHttpReceivePipelinePhases, SPMCKtor_client_coreHttpResponse, SPMCKotlinUnit, SPMCKtor_client_coreHttpRequestPipelinePhases, SPMCKtor_client_coreHttpRequestBuilder, SPMCKtor_client_coreHttpResponsePipelinePhases, SPMCKtor_client_coreHttpResponseContainer, SPMCKtor_client_coreHttpClientCall, SPMCKtor_client_coreHttpSendPipelinePhases, SPMCKtor_httpUrl, SPMCKtor_httpHttpMethod, SPMCKtor_httpOutgoingContent, SPMCKtor_httpHttpStatusCode, SPMCKtor_utilsGMTDate, SPMCKtor_httpHttpProtocolVersion, SPMCKotlinAbstractCoroutineContextElement, SPMCKotlinx_coroutines_coreCoroutineDispatcherKey, SPMCKotlinx_serialization_jsonClassDiscriminatorMode, SPMCKtor_utilsTypeInfo, SPMCKtor_httpHeadersBuilder, SPMCKtor_client_coreHttpRequestBuilderCompanion, SPMCKtor_httpURLBuilder, SPMCKtor_client_coreHttpClientCallCompanion, SPMCKtor_httpUrlCompanion, SPMCKtor_httpURLProtocol, SPMCKtor_httpHttpMethodCompanion, SPMCKtor_httpContentType, SPMCKotlinCancellationException, SPMCKtor_httpHttpStatusCodeCompanion, SPMCKtor_utilsWeekDay, SPMCKtor_utilsMonth, SPMCKtor_utilsGMTDateCompanion, SPMCKtor_httpHttpProtocolVersionCompanion, SPMCKotlinAbstractCoroutineContextKey<B, E>, SPMCKtor_utilsStringValuesBuilderImpl, SPMCKtor_httpURLBuilderCompanion, SPMCKtor_httpURLProtocolCompanion, SPMCKtor_httpHeaderValueParam, SPMCKtor_httpHeaderValueWithParametersCompanion, SPMCKtor_httpHeaderValueWithParameters, SPMCKtor_httpContentTypeCompanion, SPMCKtor_utilsWeekDayCompanion, SPMCKtor_utilsMonthCompanion, SPMCKotlinKTypeProjection, SPMCKotlinByteArray, SPMCKotlinx_io_coreBuffer, SPMCKotlinKVariance, SPMCKotlinKTypeProjectionCompanion, SPMCKotlinByteIterator;

@protocol SPMCICoordinator, SPMCSPClient, SPMCKotlinSuspendFunction0, SPMCKotlinComparable, SPMCKotlinx_serialization_coreKSerializer, SPMCKotlinx_serialization_coreEncoder, SPMCKotlinx_serialization_coreSerialDescriptor, SPMCKotlinx_serialization_coreSerializationStrategy, SPMCKotlinx_serialization_coreDecoder, SPMCKotlinx_serialization_coreDeserializationStrategy, SPMCStateSPSampleable, SPMCKtor_client_coreHttpClientEngine, SPMCIntEnum, SPMCMultiplatform_settingsSettings, SPMCKtor_client_coreClientPlugin, SPMCKotlinFunction, SPMCKotlinIterator, SPMCKotlinx_serialization_coreCompositeEncoder, SPMCKotlinAnnotation, SPMCKotlinx_serialization_coreCompositeDecoder, SPMCKotlinCoroutineContext, SPMCKotlinx_coroutines_coreCoroutineScope, SPMCKtor_ioCloseable, SPMCKtor_client_coreHttpClientEngineCapability, SPMCKtor_utilsAttributes, SPMCKotlinx_datetimeDateTimeFormat, SPMCKotlinx_serialization_coreSerialFormat, SPMCKotlinx_serialization_coreStringFormat, SPMCKtor_client_coreHttpClientPlugin, SPMCKotlinx_serialization_coreSerializersModuleCollector, SPMCKotlinKClass, SPMCKotlinCoroutineContextElement, SPMCKotlinCoroutineContextKey, SPMCKotlinx_coroutines_coreDisposableHandle, SPMCKotlinSuspendFunction2, SPMCKtor_httpHeaders, SPMCKotlinx_coroutines_coreJob, SPMCKotlinContinuation, SPMCKotlinContinuationInterceptor, SPMCKotlinx_coroutines_coreRunnable, SPMCKotlinAppendable, SPMCKotlinx_serialization_jsonJsonNamingStrategy, SPMCKotlinKDeclarationContainer, SPMCKotlinKAnnotatedElement, SPMCKotlinKClassifier, SPMCKtor_httpHttpMessage, SPMCKtor_ioByteReadChannel, SPMCKtor_httpHttpMessageBuilder, SPMCKtor_client_coreHttpRequest, SPMCKtor_httpParameters, SPMCKotlinMapEntry, SPMCKtor_utilsStringValues, SPMCKotlinx_coroutines_coreChildHandle, SPMCKotlinx_coroutines_coreChildJob, SPMCKotlinSequence, SPMCKotlinx_coroutines_coreSelectClause0, SPMCKotlinKType, SPMCKotlinx_io_coreSource, SPMCKtor_utilsStringValuesBuilder, SPMCKtor_httpParametersBuilder, SPMCKotlinx_coroutines_coreParentJob, SPMCKotlinx_coroutines_coreSelectInstance, SPMCKotlinx_coroutines_coreSelectClause, SPMCKotlinx_io_coreRawSink, SPMCKotlinAutoCloseable, SPMCKotlinx_io_coreRawSource, SPMCKotlinx_io_coreSink;

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-warning-option"
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wnullability"

#pragma push_macro("_Nullable_result")
#if !__has_feature(nullability_nullable_result)
#undef _Nullable_result
#define _Nullable_result _Nullable
#endif

__attribute__((swift_name("KotlinBase")))
@interface SPMCBase : NSObject
- (instancetype)init __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
+ (void)initialize __attribute__((objc_requires_super));
@end

@interface SPMCBase (SPMCBaseCopying) <NSCopying>
@end

__attribute__((swift_name("KotlinMutableSet")))
@interface SPMCMutableSet<ObjectType> : NSMutableSet<ObjectType>
@end

__attribute__((swift_name("KotlinMutableDictionary")))
@interface SPMCMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>
@end

@interface NSError (NSErrorSPMCKotlinException)
@property (readonly) id _Nullable kotlinException;
@end

__attribute__((swift_name("KotlinNumber")))
@interface SPMCNumber : NSNumber
- (instancetype)initWithChar:(char)value __attribute__((unavailable));
- (instancetype)initWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
- (instancetype)initWithShort:(short)value __attribute__((unavailable));
- (instancetype)initWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
- (instancetype)initWithInt:(int)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
- (instancetype)initWithLong:(long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
- (instancetype)initWithLongLong:(long long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
- (instancetype)initWithFloat:(float)value __attribute__((unavailable));
- (instancetype)initWithDouble:(double)value __attribute__((unavailable));
- (instancetype)initWithBool:(BOOL)value __attribute__((unavailable));
- (instancetype)initWithInteger:(NSInteger)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
+ (instancetype)numberWithChar:(char)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
+ (instancetype)numberWithShort:(short)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
+ (instancetype)numberWithInt:(int)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
+ (instancetype)numberWithLong:(long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
+ (instancetype)numberWithLongLong:(long long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
+ (instancetype)numberWithFloat:(float)value __attribute__((unavailable));
+ (instancetype)numberWithDouble:(double)value __attribute__((unavailable));
+ (instancetype)numberWithBool:(BOOL)value __attribute__((unavailable));
+ (instancetype)numberWithInteger:(NSInteger)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
@end

__attribute__((swift_name("KotlinByte")))
@interface SPMCByte : SPMCNumber
- (instancetype)initWithChar:(char)value;
+ (instancetype)numberWithChar:(char)value;
@end

__attribute__((swift_name("KotlinUByte")))
@interface SPMCUByte : SPMCNumber
- (instancetype)initWithUnsignedChar:(unsigned char)value;
+ (instancetype)numberWithUnsignedChar:(unsigned char)value;
@end

__attribute__((swift_name("KotlinShort")))
@interface SPMCShort : SPMCNumber
- (instancetype)initWithShort:(short)value;
+ (instancetype)numberWithShort:(short)value;
@end

__attribute__((swift_name("KotlinUShort")))
@interface SPMCUShort : SPMCNumber
- (instancetype)initWithUnsignedShort:(unsigned short)value;
+ (instancetype)numberWithUnsignedShort:(unsigned short)value;
@end

__attribute__((swift_name("KotlinInt")))
@interface SPMCInt : SPMCNumber
- (instancetype)initWithInt:(int)value;
+ (instancetype)numberWithInt:(int)value;
@end

__attribute__((swift_name("KotlinUInt")))
@interface SPMCUInt : SPMCNumber
- (instancetype)initWithUnsignedInt:(unsigned int)value;
+ (instancetype)numberWithUnsignedInt:(unsigned int)value;
@end

__attribute__((swift_name("KotlinLong")))
@interface SPMCLong : SPMCNumber
- (instancetype)initWithLongLong:(long long)value;
+ (instancetype)numberWithLongLong:(long long)value;
@end

__attribute__((swift_name("KotlinULong")))
@interface SPMCULong : SPMCNumber
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value;
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value;
@end

__attribute__((swift_name("KotlinFloat")))
@interface SPMCFloat : SPMCNumber
- (instancetype)initWithFloat:(float)value;
+ (instancetype)numberWithFloat:(float)value;
@end

__attribute__((swift_name("KotlinDouble")))
@interface SPMCDouble : SPMCNumber
- (instancetype)initWithDouble:(double)value;
+ (instancetype)numberWithDouble:(double)value;
@end

__attribute__((swift_name("KotlinBoolean")))
@interface SPMCBoolean : SPMCNumber
- (instancetype)initWithBool:(BOOL)value;
+ (instancetype)numberWithBool:(BOOL)value;
@end

__attribute__((swift_name("ICoordinator")))
@protocol SPMCICoordinator
@required
- (void)clearLocalData __attribute__((swift_name("clearLocalData()")));

/**
 * @note This method converts instances of InvalidCustomConsentUUIDError, PostCustomConsentGDPRException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)customConsentGDPRVendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("customConsentGDPR(vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of InvalidCustomConsentUUIDError, DeleteCustomConsentGDPRException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)deleteCustomConsentGDPRVendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("deleteCustomConsentGDPR(vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of LoadMessagesException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)loadMessagesAuthId:(NSString * _Nullable)authId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData language:(SPMCSPMessageLanguage *)language completionHandler:(void (^)(NSArray<SPMCMessageToDisplay *> * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("loadMessages(authId:pubData:language:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)logErrorError:(SPMCSPError *)error completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("logError(error:completionHandler:)")));

/**
 * @note This method converts instances of ReportActionException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)reportActionAction:(SPMCSPAction *)action completionHandler:(void (^)(SPMCSPUserData * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("reportAction(action:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)reportIdfaStatusOsVersion:(NSString *)osVersion requestUUID:(NSString *)requestUUID completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("reportIdfaStatus(osVersion:requestUUID:completionHandler:)")));
- (void)setTranslateMessageValue:(BOOL)value __attribute__((swift_name("setTranslateMessage(value:)")));
@property (readonly) SPMCSPUserData *userData __attribute__((swift_name("userData")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Coordinator")))
@interface SPMCCoordinator : SPMCBase <SPMCICoordinator>
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId propertyName:(SPMCSPPropertyName *)propertyName campaigns:(SPMCSPCampaigns *)campaigns timeoutInSeconds:(int32_t)timeoutInSeconds __attribute__((swift_name("init(accountId:propertyId:propertyName:campaigns:timeoutInSeconds:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId propertyName:(SPMCSPPropertyName *)propertyName campaigns:(SPMCSPCampaigns *)campaigns timeoutInSeconds:(int32_t)timeoutInSeconds state:(SPMCState * _Nullable)state __attribute__((swift_name("init(accountId:propertyId:propertyName:campaigns:timeoutInSeconds:state:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId propertyName:(SPMCSPPropertyName *)propertyName campaigns:(SPMCSPCampaigns *)campaigns repository:(SPMCRepository *)repository timeoutInSeconds:(int32_t)timeoutInSeconds spClient:(id<SPMCSPClient>)spClient authId:(NSString * _Nullable)authId state:(SPMCState *)state __attribute__((swift_name("init(accountId:propertyId:propertyName:campaigns:repository:timeoutInSeconds:spClient:authId:state:)"))) __attribute__((objc_designated_initializer));
- (void)clearLocalData __attribute__((swift_name("clearLocalData()")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)consentStatusNext:(id<SPMCKotlinSuspendFunction0>)next completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("consentStatus(next:completionHandler:)")));

/**
 * @note This method converts instances of InvalidCustomConsentUUIDError, PostCustomConsentGDPRException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)customConsentGDPRVendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("customConsentGDPR(vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of InvalidCustomConsentUUIDError, DeleteCustomConsentGDPRException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)deleteCustomConsentGDPRVendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("deleteCustomConsentGDPR(vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of LoadMessagesException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)loadMessagesAuthId:(NSString * _Nullable)authId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData language:(SPMCSPMessageLanguage *)language completionHandler:(void (^)(NSArray<SPMCMessageToDisplay *> * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("loadMessages(authId:pubData:language:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)logErrorError:(SPMCSPError *)error completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("logError(error:completionHandler:)")));

/**
 * @note This method converts instances of ReportActionException, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)reportActionAction:(SPMCSPAction *)action completionHandler:(void (^)(SPMCSPUserData * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("reportAction(action:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)reportIdfaStatusOsVersion:(NSString *)osVersion requestUUID:(NSString *)requestUUID completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("reportIdfaStatus(osVersion:requestUUID:completionHandler:)")));
- (void)setTranslateMessageValue:(BOOL)value __attribute__((swift_name("setTranslateMessage(value:)")));
@property SPMCSPIDFAStatus * _Nullable (^getIDFAStatus)(void) __attribute__((swift_name("getIDFAStatus")));
@property (readonly) SPMCSPUserData *userData __attribute__((swift_name("userData")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DeviceInformation")))
@interface SPMCDeviceInformation : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property (readonly) NSString *deviceFamily __attribute__((swift_name("deviceFamily")));
@property (readonly) SPMCOSName *osName __attribute__((swift_name("osName")));
@property (readonly) NSString *osVersion __attribute__((swift_name("osVersion")));
@end

__attribute__((swift_name("KotlinComparable")))
@protocol SPMCKotlinComparable
@required
- (int32_t)compareToOther:(id _Nullable)other __attribute__((swift_name("compareTo(other:)")));
@end

__attribute__((swift_name("KotlinEnum")))
@interface SPMCKotlinEnum<E> : SPMCBase <SPMCKotlinComparable>
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKotlinEnumCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(E)other __attribute__((swift_name("compareTo(other:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) int32_t ordinal __attribute__((swift_name("ordinal")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("OSName")))
@interface SPMCOSName : SPMCKotlinEnum<SPMCOSName *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) SPMCOSName *ios __attribute__((swift_name("ios")));
@property (class, readonly) SPMCOSName *tvos __attribute__((swift_name("tvos")));
@property (class, readonly) SPMCOSName *android __attribute__((swift_name("android")));
+ (SPMCKotlinArray<SPMCOSName *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCOSName *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((swift_name("KotlinThrowable")))
@interface SPMCKotlinThrowable : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));

/**
 * @note annotations
 *   kotlin.experimental.ExperimentalNativeApi
*/
- (SPMCKotlinArray<NSString *> *)getStackTrace __attribute__((swift_name("getStackTrace()")));
- (void)printStackTrace __attribute__((swift_name("printStackTrace()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinThrowable * _Nullable cause __attribute__((swift_name("cause")));
@property (readonly) NSString * _Nullable message __attribute__((swift_name("message")));
- (NSError *)asError __attribute__((swift_name("asError()")));
@end

__attribute__((swift_name("KotlinException")))
@interface SPMCKotlinException : SPMCKotlinThrowable
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end

__attribute__((swift_name("SPError")))
@interface SPMCSPError : SPMCKotlinException
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithCause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (readonly) SPMCSPCampaignType * _Nullable campaignType __attribute__((swift_name("campaignType")));
@property (readonly) SPMCSPError * _Nullable causedBy __attribute__((swift_name("causedBy")));
@property (readonly) NSString *code __attribute__((swift_name("code")));
@property (readonly) NSString *description_ __attribute__((swift_name("description_")));
@end

__attribute__((swift_name("DeleteCustomConsentGDPRException")))
@interface SPMCDeleteCustomConsentGDPRException : SPMCSPError
- (instancetype)initWithCausedBy:(SPMCSPError *)causedBy __attribute__((swift_name("init(causedBy:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((swift_name("InvalidChoiceAllParamsError")))
@interface SPMCInvalidChoiceAllParamsError : SPMCSPError
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((swift_name("InvalidCustomConsentUUIDError")))
@interface SPMCInvalidCustomConsentUUIDError : SPMCSPError
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((swift_name("InvalidPropertyNameError")))
@interface SPMCInvalidPropertyNameError : SPMCSPError
- (instancetype)initWithPropertyName:(NSString *)propertyName __attribute__((swift_name("init(propertyName:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((swift_name("LoadMessagesException")))
@interface SPMCLoadMessagesException : SPMCSPError
- (instancetype)initWithCausedBy:(SPMCSPError *)causedBy __attribute__((swift_name("init(causedBy:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessageToDisplay")))
@interface SPMCMessageToDisplay : SPMCBase
- (instancetype)initWithMessage:(SPMCMessagesResponseMessage *)message metaData:(SPMCMessagesResponseMessageMetaData *)metaData url:(NSString *)url type:(SPMCSPCampaignType *)type __attribute__((swift_name("init(message:metaData:url:type:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessageToDisplayCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessageToDisplay *)doCopyMessage:(SPMCMessagesResponseMessage *)message metaData:(SPMCMessagesResponseMessageMetaData *)metaData url:(NSString *)url type:(SPMCSPCampaignType *)type __attribute__((swift_name("doCopy(message:metaData:url:type:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCMessagesResponseMessage *message __attribute__((swift_name("message")));
@property (readonly) SPMCMessagesResponseMessageMetaData *metaData __attribute__((swift_name("metaData")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@property (readonly) NSString *url __attribute__((swift_name("url")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessageToDisplay.Companion")))
@interface SPMCMessageToDisplayCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessageToDisplayCompanion *shared __attribute__((swift_name("shared")));
- (SPMCMessageToDisplay * _Nullable)doInitFromCampaignCampaign:(SPMCMessagesResponseCampaign<id> *)campaign __attribute__((swift_name("doInitFromCampaign(campaign:)")));
@end

__attribute__((swift_name("PostCustomConsentGDPRException")))
@interface SPMCPostCustomConsentGDPRException : SPMCSPError
- (instancetype)initWithCausedBy:(SPMCSPError *)causedBy __attribute__((swift_name("init(causedBy:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((swift_name("ReportActionException")))
@interface SPMCReportActionException : SPMCSPError
- (instancetype)initWithActionType:(SPMCSPActionType *)actionType campaignType:(SPMCSPCampaignType * _Nullable)campaignType causedBy:(SPMCSPError *)causedBy __attribute__((swift_name("init(actionType:campaignType:causedBy:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPAction")))
@interface SPMCSPAction : SPMCBase
- (instancetype)initWithType:(SPMCSPActionType *)type campaignType:(SPMCSPCampaignType *)campaignType messageId:(NSString * _Nullable)messageId pmPayload:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmPayload encodablePubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)encodablePubData __attribute__((swift_name("init(type:campaignType:messageId:pmPayload:encodablePubData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCSPActionCompanion *companion __attribute__((swift_name("companion")));
- (SPMCSPAction *)doCopyType:(SPMCSPActionType *)type campaignType:(SPMCSPCampaignType *)campaignType messageId:(NSString * _Nullable)messageId pmPayload:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmPayload encodablePubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)encodablePubData __attribute__((swift_name("doCopy(type:campaignType:messageId:pmPayload:encodablePubData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCSPCampaignType *campaignType __attribute__((swift_name("campaignType")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *encodablePubData __attribute__((swift_name("encodablePubData")));
@property (readonly) NSString * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pmPayload __attribute__((swift_name("pmPayload")));
@property (readonly) SPMCSPActionType *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPAction.Companion")))
@interface SPMCSPActionCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPActionCompanion *shared __attribute__((swift_name("shared")));
- (SPMCSPAction *)doInitType:(SPMCSPActionType *)type campaignType:(SPMCSPCampaignType *)campaignType messageId:(NSString * _Nullable)messageId pmPayload:(NSString * _Nullable)pmPayload encodablePubData:(NSString * _Nullable)encodablePubData __attribute__((swift_name("doInit(type:campaignType:messageId:pmPayload:encodablePubData:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPActionType")))
@interface SPMCSPActionType : SPMCKotlinEnum<SPMCSPActionType *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) SPMCSPActionType *saveandexit __attribute__((swift_name("saveandexit")));
@property (class, readonly) SPMCSPActionType *pmcancel __attribute__((swift_name("pmcancel")));
@property (class, readonly) SPMCSPActionType *custom __attribute__((swift_name("custom")));
@property (class, readonly) SPMCSPActionType *acceptall __attribute__((swift_name("acceptall")));
@property (class, readonly) SPMCSPActionType *showprivacymanager __attribute__((swift_name("showprivacymanager")));
@property (class, readonly) SPMCSPActionType *rejectall __attribute__((swift_name("rejectall")));
@property (class, readonly) SPMCSPActionType *dismiss __attribute__((swift_name("dismiss")));
@property (class, readonly) SPMCSPActionType *requestattaccess __attribute__((swift_name("requestattaccess")));
@property (class, readonly) SPMCSPActionType *idfaaccepted __attribute__((swift_name("idfaaccepted")));
@property (class, readonly) SPMCSPActionType *idfadenied __attribute__((swift_name("idfadenied")));
@property (class, readonly) SPMCSPActionType *unknown __attribute__((swift_name("unknown")));
+ (SPMCKotlinArray<SPMCSPActionType *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCSPActionType *> *entries __attribute__((swift_name("entries")));
@property (readonly) int32_t type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPCampaign")))
@interface SPMCSPCampaign : SPMCBase
- (instancetype)initWithTargetingParams:(NSDictionary<NSString *, NSString *> *)targetingParams groupPmId:(NSString * _Nullable)groupPmId gppConfig:(SPMCIncludeDataGPPConfig * _Nullable)gppConfig transitionCCPAAuth:(SPMCBoolean * _Nullable)transitionCCPAAuth supportLegacyUSPString:(SPMCBoolean * _Nullable)supportLegacyUSPString __attribute__((swift_name("init(targetingParams:groupPmId:gppConfig:transitionCCPAAuth:supportLegacyUSPString:)"))) __attribute__((objc_designated_initializer));
- (SPMCSPCampaign *)doCopyTargetingParams:(NSDictionary<NSString *, NSString *> *)targetingParams groupPmId:(NSString * _Nullable)groupPmId gppConfig:(SPMCIncludeDataGPPConfig * _Nullable)gppConfig transitionCCPAAuth:(SPMCBoolean * _Nullable)transitionCCPAAuth supportLegacyUSPString:(SPMCBoolean * _Nullable)supportLegacyUSPString __attribute__((swift_name("doCopy(targetingParams:groupPmId:gppConfig:transitionCCPAAuth:supportLegacyUSPString:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCIncludeDataGPPConfig * _Nullable gppConfig __attribute__((swift_name("gppConfig")));
@property (readonly) NSString * _Nullable groupPmId __attribute__((swift_name("groupPmId")));
@property (readonly) SPMCBoolean * _Nullable supportLegacyUSPString __attribute__((swift_name("supportLegacyUSPString")));
@property (readonly) NSDictionary<NSString *, NSString *> *targetingParams __attribute__((swift_name("targetingParams")));
@property (readonly) SPMCBoolean * _Nullable transitionCCPAAuth __attribute__((swift_name("transitionCCPAAuth")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPCampaignEnv")))
@interface SPMCSPCampaignEnv : SPMCKotlinEnum<SPMCSPCampaignEnv *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCSPCampaignEnvCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCSPCampaignEnv *stage __attribute__((swift_name("stage")));
@property (class, readonly) SPMCSPCampaignEnv *public_ __attribute__((swift_name("public_")));
+ (SPMCKotlinArray<SPMCSPCampaignEnv *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCSPCampaignEnv *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPCampaignEnv.Companion")))
@interface SPMCSPCampaignEnvCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPCampaignEnvCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPCampaignType")))
@interface SPMCSPCampaignType : SPMCKotlinEnum<SPMCSPCampaignType *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCSPCampaignTypeCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCSPCampaignType *gdpr __attribute__((swift_name("gdpr")));
@property (class, readonly) SPMCSPCampaignType *ccpa __attribute__((swift_name("ccpa")));
@property (class, readonly) SPMCSPCampaignType *usnat __attribute__((swift_name("usnat")));
@property (class, readonly) SPMCSPCampaignType *ios14 __attribute__((swift_name("ios14")));
@property (class, readonly) SPMCSPCampaignType *preferences __attribute__((swift_name("preferences")));
@property (class, readonly) SPMCSPCampaignType *globalcmp __attribute__((swift_name("globalcmp")));
@property (class, readonly) SPMCSPCampaignType *unknown __attribute__((swift_name("unknown")));
+ (SPMCKotlinArray<SPMCSPCampaignType *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCSPCampaignType *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPCampaignType.Companion")))
@interface SPMCSPCampaignTypeCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPCampaignTypeCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPCampaigns")))
@interface SPMCSPCampaigns : SPMCBase
- (instancetype)initWithEnvironment:(SPMCSPCampaignEnv *)environment gdpr:(SPMCSPCampaign * _Nullable)gdpr ccpa:(SPMCSPCampaign * _Nullable)ccpa usnat:(SPMCSPCampaign * _Nullable)usnat globalcmp:(SPMCSPCampaign * _Nullable)globalcmp ios14:(SPMCSPCampaign * _Nullable)ios14 preferences:(SPMCSPCampaign * _Nullable)preferences __attribute__((swift_name("init(environment:gdpr:ccpa:usnat:globalcmp:ios14:preferences:)"))) __attribute__((objc_designated_initializer));
- (SPMCSPCampaigns *)doCopyEnvironment:(SPMCSPCampaignEnv *)environment gdpr:(SPMCSPCampaign * _Nullable)gdpr ccpa:(SPMCSPCampaign * _Nullable)ccpa usnat:(SPMCSPCampaign * _Nullable)usnat globalcmp:(SPMCSPCampaign * _Nullable)globalcmp ios14:(SPMCSPCampaign * _Nullable)ios14 preferences:(SPMCSPCampaign * _Nullable)preferences __attribute__((swift_name("doCopy(environment:gdpr:ccpa:usnat:globalcmp:ios14:preferences:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCSPCampaign * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCSPCampaignEnv *environment __attribute__((swift_name("environment")));
@property (readonly) SPMCSPCampaign * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCSPCampaign * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCSPCampaign * _Nullable ios14 __attribute__((swift_name("ios14")));
@property (readonly) SPMCSPCampaign * _Nullable preferences __attribute__((swift_name("preferences")));
@property (readonly) SPMCSPCampaign * _Nullable usnat __attribute__((swift_name("usnat")));
@end

__attribute__((swift_name("SPClientTimeout")))
@interface SPMCSPClientTimeout : SPMCSPError
- (instancetype)initWithPath:(NSString *)path timeoutInSeconds:(int32_t)timeoutInSeconds httpVerb:(NSString *)httpVerb __attribute__((swift_name("init(path:timeoutInSeconds:httpVerb:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPIDFAStatus")))
@interface SPMCSPIDFAStatus : SPMCKotlinEnum<SPMCSPIDFAStatus *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCSPIDFAStatusCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCSPIDFAStatus *unknown __attribute__((swift_name("unknown")));
@property (class, readonly) SPMCSPIDFAStatus *accepted __attribute__((swift_name("accepted")));
@property (class, readonly) SPMCSPIDFAStatus *denied __attribute__((swift_name("denied")));
@property (class, readonly) SPMCSPIDFAStatus *unavailable __attribute__((swift_name("unavailable")));
+ (SPMCKotlinArray<SPMCSPIDFAStatus *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCSPIDFAStatus *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPIDFAStatus.Companion")))
@interface SPMCSPIDFAStatusCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPIDFAStatusCompanion *shared __attribute__((swift_name("shared")));
- (SPMCSPIDFAStatus * _Nullable)current __attribute__((swift_name("current()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=com/sourcepoint/mobile_core/models/SPMessageLanguage.Serializer))
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPMessageLanguage")))
@interface SPMCSPMessageLanguage : SPMCKotlinEnum<SPMCSPMessageLanguage *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCSPMessageLanguageSerializer *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCSPMessageLanguage *albanian __attribute__((swift_name("albanian")));
@property (class, readonly) SPMCSPMessageLanguage *arabic __attribute__((swift_name("arabic")));
@property (class, readonly) SPMCSPMessageLanguage *basque __attribute__((swift_name("basque")));
@property (class, readonly) SPMCSPMessageLanguage *bosnianLatin __attribute__((swift_name("bosnianLatin")));
@property (class, readonly) SPMCSPMessageLanguage *bulgarian __attribute__((swift_name("bulgarian")));
@property (class, readonly) SPMCSPMessageLanguage *catalan __attribute__((swift_name("catalan")));
@property (class, readonly) SPMCSPMessageLanguage *chineseSimplified __attribute__((swift_name("chineseSimplified")));
@property (class, readonly) SPMCSPMessageLanguage *chineseTraditional __attribute__((swift_name("chineseTraditional")));
@property (class, readonly) SPMCSPMessageLanguage *croatian __attribute__((swift_name("croatian")));
@property (class, readonly) SPMCSPMessageLanguage *czech __attribute__((swift_name("czech")));
@property (class, readonly) SPMCSPMessageLanguage *danish __attribute__((swift_name("danish")));
@property (class, readonly) SPMCSPMessageLanguage *dutch __attribute__((swift_name("dutch")));
@property (class, readonly) SPMCSPMessageLanguage *english __attribute__((swift_name("english")));
@property (class, readonly) SPMCSPMessageLanguage *estonian __attribute__((swift_name("estonian")));
@property (class, readonly) SPMCSPMessageLanguage *finnish __attribute__((swift_name("finnish")));
@property (class, readonly) SPMCSPMessageLanguage *french __attribute__((swift_name("french")));
@property (class, readonly) SPMCSPMessageLanguage *galician __attribute__((swift_name("galician")));
@property (class, readonly) SPMCSPMessageLanguage *georgian __attribute__((swift_name("georgian")));
@property (class, readonly) SPMCSPMessageLanguage *german __attribute__((swift_name("german")));
@property (class, readonly) SPMCSPMessageLanguage *greek __attribute__((swift_name("greek")));
@property (class, readonly) SPMCSPMessageLanguage *hebrew __attribute__((swift_name("hebrew")));
@property (class, readonly) SPMCSPMessageLanguage *hindi __attribute__((swift_name("hindi")));
@property (class, readonly) SPMCSPMessageLanguage *hungarian __attribute__((swift_name("hungarian")));
@property (class, readonly) SPMCSPMessageLanguage *indonesian __attribute__((swift_name("indonesian")));
@property (class, readonly) SPMCSPMessageLanguage *italian __attribute__((swift_name("italian")));
@property (class, readonly) SPMCSPMessageLanguage *japanese __attribute__((swift_name("japanese")));
@property (class, readonly) SPMCSPMessageLanguage *korean __attribute__((swift_name("korean")));
@property (class, readonly) SPMCSPMessageLanguage *latvian __attribute__((swift_name("latvian")));
@property (class, readonly) SPMCSPMessageLanguage *lithuanian __attribute__((swift_name("lithuanian")));
@property (class, readonly) SPMCSPMessageLanguage *macedonian __attribute__((swift_name("macedonian")));
@property (class, readonly) SPMCSPMessageLanguage *malay __attribute__((swift_name("malay")));
@property (class, readonly) SPMCSPMessageLanguage *maltese __attribute__((swift_name("maltese")));
@property (class, readonly) SPMCSPMessageLanguage *norwegian __attribute__((swift_name("norwegian")));
@property (class, readonly) SPMCSPMessageLanguage *polish __attribute__((swift_name("polish")));
@property (class, readonly) SPMCSPMessageLanguage *portugueseBrazil __attribute__((swift_name("portugueseBrazil")));
@property (class, readonly) SPMCSPMessageLanguage *portuguesePortugal __attribute__((swift_name("portuguesePortugal")));
@property (class, readonly) SPMCSPMessageLanguage *romanian __attribute__((swift_name("romanian")));
@property (class, readonly) SPMCSPMessageLanguage *russian __attribute__((swift_name("russian")));
@property (class, readonly) SPMCSPMessageLanguage *serbianCyrillic __attribute__((swift_name("serbianCyrillic")));
@property (class, readonly) SPMCSPMessageLanguage *serbianLatin __attribute__((swift_name("serbianLatin")));
@property (class, readonly) SPMCSPMessageLanguage *slovak __attribute__((swift_name("slovak")));
@property (class, readonly) SPMCSPMessageLanguage *slovenian __attribute__((swift_name("slovenian")));
@property (class, readonly) SPMCSPMessageLanguage *spanish __attribute__((swift_name("spanish")));
@property (class, readonly) SPMCSPMessageLanguage *swahili __attribute__((swift_name("swahili")));
@property (class, readonly) SPMCSPMessageLanguage *swedish __attribute__((swift_name("swedish")));
@property (class, readonly) SPMCSPMessageLanguage *tagalog __attribute__((swift_name("tagalog")));
@property (class, readonly) SPMCSPMessageLanguage *thai __attribute__((swift_name("thai")));
@property (class, readonly) SPMCSPMessageLanguage *turkish __attribute__((swift_name("turkish")));
@property (class, readonly) SPMCSPMessageLanguage *ukrainian __attribute__((swift_name("ukrainian")));
@property (class, readonly) SPMCSPMessageLanguage *vietnamese __attribute__((swift_name("vietnamese")));
@property (class, readonly) SPMCSPMessageLanguage *welsh __attribute__((swift_name("welsh")));
+ (SPMCKotlinArray<SPMCSPMessageLanguage *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCSPMessageLanguage *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *shortCode __attribute__((swift_name("shortCode")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerializationStrategy")))
@protocol SPMCKotlinx_serialization_coreSerializationStrategy
@required
- (void)serializeEncoder:(id<SPMCKotlinx_serialization_coreEncoder>)encoder value:(id _Nullable)value __attribute__((swift_name("serialize(encoder:value:)")));
@property (readonly) id<SPMCKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreDeserializationStrategy")))
@protocol SPMCKotlinx_serialization_coreDeserializationStrategy
@required
- (id _Nullable)deserializeDecoder:(id<SPMCKotlinx_serialization_coreDecoder>)decoder __attribute__((swift_name("deserialize(decoder:)")));
@property (readonly) id<SPMCKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreKSerializer")))
@protocol SPMCKotlinx_serialization_coreKSerializer <SPMCKotlinx_serialization_coreSerializationStrategy, SPMCKotlinx_serialization_coreDeserializationStrategy>
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPMessageLanguage.Serializer")))
@interface SPMCSPMessageLanguageSerializer : SPMCBase <SPMCKotlinx_serialization_coreKSerializer>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)serializer __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPMessageLanguageSerializer *shared __attribute__((swift_name("shared")));
- (SPMCSPMessageLanguage *)deserializeDecoder:(id<SPMCKotlinx_serialization_coreDecoder>)decoder __attribute__((swift_name("deserialize(decoder:)")));
- (void)serializeEncoder:(id<SPMCKotlinx_serialization_coreEncoder>)encoder value:(SPMCSPMessageLanguage *)value __attribute__((swift_name("serialize(encoder:value:)")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@property (readonly) id<SPMCKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("SPNetworkError")))
@interface SPMCSPNetworkError : SPMCSPError
- (instancetype)initWithStatusCode:(SPMCInt * _Nullable)statusCode httpVerb:(NSString *)httpVerb path:(NSString *)path code:(NSString *)code description:(NSString *)description __attribute__((swift_name("init(statusCode:httpVerb:path:code:description:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=com/sourcepoint/mobile_core/models/SPPropertyName.Serializer))
*/
__attribute__((swift_name("SPPropertyName")))
@interface SPMCSPPropertyName : SPMCBase
@property (class, readonly, getter=companion) SPMCSPPropertyNameCompanion *companion __attribute__((swift_name("companion")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *rawValue __attribute__((swift_name("rawValue")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPPropertyName.Companion")))
@interface SPMCSPPropertyNameCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPPropertyNameCompanion *shared __attribute__((swift_name("shared")));

/**
 * @note This method converts instances of InvalidPropertyNameError to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (SPMCSPPropertyName * _Nullable)createRawValue:(NSString *)rawValue error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("create(rawValue:)")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPPropertyName.Serializer")))
@interface SPMCSPPropertyNameSerializer : SPMCBase <SPMCKotlinx_serialization_coreKSerializer>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)serializer __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPPropertyNameSerializer *shared __attribute__((swift_name("shared")));
- (SPMCSPPropertyName *)deserializeDecoder:(id<SPMCKotlinx_serialization_coreDecoder>)decoder __attribute__((swift_name("deserialize(decoder:)")));
- (void)serializeEncoder:(id<SPMCKotlinx_serialization_coreEncoder>)encoder value:(SPMCSPPropertyName *)value __attribute__((swift_name("serialize(encoder:value:)")));
@property (readonly) id<SPMCKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("SPUnableToParseBodyError")))
@interface SPMCSPUnableToParseBodyError : SPMCSPError
- (instancetype)initWithBodyName:(NSString * _Nullable)bodyName __attribute__((swift_name("init(bodyName:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end

__attribute__((swift_name("SPUnknownNetworkError")))
@interface SPMCSPUnknownNetworkError : SPMCSPError
- (instancetype)initWithPath:(NSString *)path __attribute__((swift_name("init(path:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCode:(NSString *)code description:(NSString *)description causedBy:(SPMCSPError * _Nullable)causedBy campaignType:(SPMCSPCampaignType * _Nullable)campaignType __attribute__((swift_name("init(code:description:causedBy:campaignType:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AttCampaign")))
@interface SPMCAttCampaign : SPMCBase
- (instancetype)initWithStatus:(SPMCSPIDFAStatus * _Nullable)status messageId:(SPMCInt * _Nullable)messageId partitionUUID:(NSString * _Nullable)partitionUUID __attribute__((swift_name("init(status:messageId:partitionUUID:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCAttCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCAttCampaign *)doCopyStatus:(SPMCSPIDFAStatus * _Nullable)status messageId:(SPMCInt * _Nullable)messageId partitionUUID:(NSString * _Nullable)partitionUUID __attribute__((swift_name("doCopy(status:messageId:partitionUUID:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCInt * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSString * _Nullable partitionUUID __attribute__((swift_name("partitionUUID")));
@property (readonly) SPMCSPIDFAStatus * _Nullable status __attribute__((swift_name("status")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AttCampaign.Companion")))
@interface SPMCAttCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCAttCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAConsent")))
@interface SPMCCCPAConsent : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate signedLspa:(SPMCBoolean * _Nullable)signedLspa rejectedAll:(BOOL)rejectedAll consentedAll:(BOOL)consentedAll rejectedVendors:(NSArray<NSString *> *)rejectedVendors rejectedCategories:(NSArray<NSString *> *)rejectedCategories status:(SPMCCCPAConsentCCPAConsentStatus * _Nullable)status webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("init(applies:uuid:dateCreated:expirationDate:signedLspa:rejectedAll:consentedAll:rejectedVendors:rejectedCategories:status:webConsentPayload:gppData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCCCPAConsentCompanion *companion __attribute__((swift_name("companion")));
- (SPMCCCPAConsent *)doCopyApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate signedLspa:(SPMCBoolean * _Nullable)signedLspa rejectedAll:(BOOL)rejectedAll consentedAll:(BOOL)consentedAll rejectedVendors:(NSArray<NSString *> *)rejectedVendors rejectedCategories:(NSArray<NSString *> *)rejectedCategories status:(SPMCCCPAConsentCCPAConsentStatus * _Nullable)status webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("doCopy(applies:uuid:dateCreated:expirationDate:signedLspa:rejectedAll:consentedAll:rejectedVendors:rejectedCategories:status:webConsentPayload:gppData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) BOOL consentedAll __attribute__((swift_name("consentedAll")));
@property (readonly) SPMCKotlinx_datetimeInstant *dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant *expirationDate __attribute__((swift_name("expirationDate")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *gppData __attribute__((swift_name("gppData")));
@property (readonly) BOOL rejectedAll __attribute__((swift_name("rejectedAll")));
@property (readonly) NSArray<NSString *> *rejectedCategories __attribute__((swift_name("rejectedCategories")));
@property (readonly) NSArray<NSString *> *rejectedVendors __attribute__((swift_name("rejectedVendors")));
@property (readonly) SPMCBoolean * _Nullable signedLspa __attribute__((swift_name("signedLspa")));
@property (readonly) SPMCCCPAConsentCCPAConsentStatus * _Nullable status __attribute__((swift_name("status")));
@property (readonly) NSString *uspstring __attribute__((swift_name("uspstring")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAConsent.CCPAConsentStatus")))
@interface SPMCCCPAConsentCCPAConsentStatus : SPMCKotlinEnum<SPMCCCPAConsentCCPAConsentStatus *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCCCPAConsentCCPAConsentStatusCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCCCPAConsentCCPAConsentStatus *consentedall __attribute__((swift_name("consentedall")));
@property (class, readonly) SPMCCCPAConsentCCPAConsentStatus *rejectedall __attribute__((swift_name("rejectedall")));
@property (class, readonly) SPMCCCPAConsentCCPAConsentStatus *rejectedsome __attribute__((swift_name("rejectedsome")));
@property (class, readonly) SPMCCCPAConsentCCPAConsentStatus *rejectednone __attribute__((swift_name("rejectednone")));
@property (class, readonly) SPMCCCPAConsentCCPAConsentStatus *linkednoaction __attribute__((swift_name("linkednoaction")));
+ (SPMCKotlinArray<SPMCCCPAConsentCCPAConsentStatus *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCCCPAConsentCCPAConsentStatus *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAConsent.CCPAConsentStatusCompanion")))
@interface SPMCCCPAConsentCCPAConsentStatusCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCCCPAConsentCCPAConsentStatusCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAConsent.Companion")))
@interface SPMCCCPAConsentCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCCCPAConsentCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatus")))
@interface SPMCConsentStatus : SPMCBase
- (instancetype)initWithRejectedAny:(SPMCBoolean * _Nullable)rejectedAny rejectedLI:(SPMCBoolean * _Nullable)rejectedLI rejectedAll:(SPMCBoolean * _Nullable)rejectedAll consentedAll:(SPMCBoolean * _Nullable)consentedAll consentedToAll:(SPMCBoolean * _Nullable)consentedToAll consentedToAny:(SPMCBoolean * _Nullable)consentedToAny hasConsentData:(SPMCBoolean * _Nullable)hasConsentData vendorListAdditions:(SPMCBoolean * _Nullable)vendorListAdditions legalBasisChanges:(SPMCBoolean * _Nullable)legalBasisChanges granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus rejectedVendors:(NSArray<id> * _Nullable)rejectedVendors rejectedCategories:(NSArray<id> * _Nullable)rejectedCategories __attribute__((swift_name("init(rejectedAny:rejectedLI:rejectedAll:consentedAll:consentedToAll:consentedToAny:hasConsentData:vendorListAdditions:legalBasisChanges:granularStatus:rejectedVendors:rejectedCategories:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatus *)doCopyRejectedAny:(SPMCBoolean * _Nullable)rejectedAny rejectedLI:(SPMCBoolean * _Nullable)rejectedLI rejectedAll:(SPMCBoolean * _Nullable)rejectedAll consentedAll:(SPMCBoolean * _Nullable)consentedAll consentedToAll:(SPMCBoolean * _Nullable)consentedToAll consentedToAny:(SPMCBoolean * _Nullable)consentedToAny hasConsentData:(SPMCBoolean * _Nullable)hasConsentData vendorListAdditions:(SPMCBoolean * _Nullable)vendorListAdditions legalBasisChanges:(SPMCBoolean * _Nullable)legalBasisChanges granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus rejectedVendors:(NSArray<id> * _Nullable)rejectedVendors rejectedCategories:(NSArray<id> * _Nullable)rejectedCategories __attribute__((swift_name("doCopy(rejectedAny:rejectedLI:rejectedAll:consentedAll:consentedToAll:consentedToAny:hasConsentData:vendorListAdditions:legalBasisChanges:granularStatus:rejectedVendors:rejectedCategories:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCBoolean * _Nullable consentedAll __attribute__((swift_name("consentedAll")));
@property (readonly) SPMCBoolean * _Nullable consentedToAll __attribute__((swift_name("consentedToAll")));
@property (readonly) SPMCBoolean * _Nullable consentedToAny __attribute__((swift_name("consentedToAny")));
@property SPMCConsentStatusConsentStatusGranularStatus * _Nullable granularStatus __attribute__((swift_name("granularStatus")));
@property (readonly) SPMCBoolean * _Nullable hasConsentData __attribute__((swift_name("hasConsentData")));
@property (readonly) SPMCBoolean * _Nullable legalBasisChanges __attribute__((swift_name("legalBasisChanges")));
@property (readonly) SPMCBoolean * _Nullable rejectedAll __attribute__((swift_name("rejectedAll")));
@property (readonly) SPMCBoolean * _Nullable rejectedAny __attribute__((swift_name("rejectedAny")));
@property (readonly) NSArray<id> * _Nullable rejectedCategories __attribute__((swift_name("rejectedCategories")));
@property (readonly) SPMCBoolean * _Nullable rejectedLI __attribute__((swift_name("rejectedLI")));
@property (readonly) NSArray<id> * _Nullable rejectedVendors __attribute__((swift_name("rejectedVendors")));
@property (readonly) SPMCBoolean * _Nullable vendorListAdditions __attribute__((swift_name("vendorListAdditions")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatus.Companion")))
@interface SPMCConsentStatusCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatus.ConsentStatusGranularStatus")))
@interface SPMCConsentStatusConsentStatusGranularStatus : SPMCBase
- (instancetype)initWithVendorConsent:(NSString * _Nullable)vendorConsent vendorLegInt:(NSString * _Nullable)vendorLegInt purposeConsent:(NSString * _Nullable)purposeConsent purposeLegInt:(NSString * _Nullable)purposeLegInt previousOptInAll:(SPMCBoolean * _Nullable)previousOptInAll defaultConsent:(SPMCBoolean * _Nullable)defaultConsent sellStatus:(SPMCBoolean * _Nullable)sellStatus shareStatus:(SPMCBoolean * _Nullable)shareStatus sensitiveDataStatus:(SPMCBoolean * _Nullable)sensitiveDataStatus gpcStatus:(SPMCBoolean * _Nullable)gpcStatus systemCategories:(SPMCKotlinx_serialization_jsonJsonElement * _Nullable)systemCategories customCategories:(SPMCKotlinx_serialization_jsonJsonElement * _Nullable)customCategories __attribute__((swift_name("init(vendorConsent:vendorLegInt:purposeConsent:purposeLegInt:previousOptInAll:defaultConsent:sellStatus:shareStatus:sensitiveDataStatus:gpcStatus:systemCategories:customCategories:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusConsentStatusGranularStatusCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusConsentStatusGranularStatus *)doCopyVendorConsent:(NSString * _Nullable)vendorConsent vendorLegInt:(NSString * _Nullable)vendorLegInt purposeConsent:(NSString * _Nullable)purposeConsent purposeLegInt:(NSString * _Nullable)purposeLegInt previousOptInAll:(SPMCBoolean * _Nullable)previousOptInAll defaultConsent:(SPMCBoolean * _Nullable)defaultConsent sellStatus:(SPMCBoolean * _Nullable)sellStatus shareStatus:(SPMCBoolean * _Nullable)shareStatus sensitiveDataStatus:(SPMCBoolean * _Nullable)sensitiveDataStatus gpcStatus:(SPMCBoolean * _Nullable)gpcStatus systemCategories:(SPMCKotlinx_serialization_jsonJsonElement * _Nullable)systemCategories customCategories:(SPMCKotlinx_serialization_jsonJsonElement * _Nullable)customCategories __attribute__((swift_name("doCopy(vendorConsent:vendorLegInt:purposeConsent:purposeLegInt:previousOptInAll:defaultConsent:sellStatus:shareStatus:sensitiveDataStatus:gpcStatus:systemCategories:customCategories:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_serialization_jsonJsonElement * _Nullable customCategories __attribute__((swift_name("customCategories")));
@property (readonly) SPMCBoolean * _Nullable defaultConsent __attribute__((swift_name("defaultConsent")));
@property SPMCBoolean * _Nullable gpcStatus __attribute__((swift_name("gpcStatus")));
@property (readonly) SPMCBoolean * _Nullable previousOptInAll __attribute__((swift_name("previousOptInAll")));
@property (readonly) NSString * _Nullable purposeConsent __attribute__((swift_name("purposeConsent")));
@property (readonly) NSString * _Nullable purposeLegInt __attribute__((swift_name("purposeLegInt")));
@property (readonly) SPMCBoolean * _Nullable sellStatus __attribute__((swift_name("sellStatus")));
@property (readonly) SPMCBoolean * _Nullable sensitiveDataStatus __attribute__((swift_name("sensitiveDataStatus")));
@property (readonly) SPMCBoolean * _Nullable shareStatus __attribute__((swift_name("shareStatus")));
@property (readonly) SPMCKotlinx_serialization_jsonJsonElement * _Nullable systemCategories __attribute__((swift_name("systemCategories")));
@property (readonly) NSString * _Nullable vendorConsent __attribute__((swift_name("vendorConsent")));
@property (readonly) NSString * _Nullable vendorLegInt __attribute__((swift_name("vendorLegInt")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatus.ConsentStatusGranularStatusCompanion")))
@interface SPMCConsentStatusConsentStatusGranularStatusCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusConsentStatusGranularStatusCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRConsent")))
@interface SPMCGDPRConsent : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate uuid:(NSString * _Nullable)uuid euconsent:(NSString * _Nullable)euconsent legIntCategories:(NSArray<NSString *> *)legIntCategories legIntVendors:(NSArray<NSString *> *)legIntVendors vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories specialFeatures:(NSArray<NSString *> *)specialFeatures grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> *)grants gcmStatus:(SPMCGDPRConsentGCMStatus * _Nullable)gcmStatus webConsentPayload:(NSString * _Nullable)webConsentPayload consentStatus:(SPMCConsentStatus *)consentStatus tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)tcData __attribute__((swift_name("init(applies:dateCreated:expirationDate:uuid:euconsent:legIntCategories:legIntVendors:vendors:categories:specialFeatures:grants:gcmStatus:webConsentPayload:consentStatus:tcData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGDPRConsentCompanion *companion __attribute__((swift_name("companion")));
- (SPMCGDPRConsent *)doCopyApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate uuid:(NSString * _Nullable)uuid euconsent:(NSString * _Nullable)euconsent legIntCategories:(NSArray<NSString *> *)legIntCategories legIntVendors:(NSArray<NSString *> *)legIntVendors vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories specialFeatures:(NSArray<NSString *> *)specialFeatures grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> *)grants gcmStatus:(SPMCGDPRConsentGCMStatus * _Nullable)gcmStatus webConsentPayload:(NSString * _Nullable)webConsentPayload consentStatus:(SPMCConsentStatus *)consentStatus tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)tcData __attribute__((swift_name("doCopy(applies:dateCreated:expirationDate:uuid:euconsent:legIntCategories:legIntVendors:vendors:categories:specialFeatures:grants:gcmStatus:webConsentPayload:consentStatus:tcData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) NSArray<NSString *> *categories __attribute__((swift_name("categories")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCKotlinx_datetimeInstant *dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) NSString * _Nullable euconsent __attribute__((swift_name("euconsent")));
@property (readonly) SPMCKotlinx_datetimeInstant *expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCGDPRConsentGCMStatus * _Nullable gcmStatus __attribute__((swift_name("gcmStatus")));
@property (readonly) NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> *grants __attribute__((swift_name("grants")));
@property (readonly) NSArray<NSString *> *legIntCategories __attribute__((swift_name("legIntCategories")));
@property (readonly) NSArray<NSString *> *legIntVendors __attribute__((swift_name("legIntVendors")));
@property (readonly) NSArray<NSString *> *specialFeatures __attribute__((swift_name("specialFeatures")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="TCData")
*/
@property NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *tcData __attribute__((swift_name("tcData")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSArray<NSString *> *vendors __attribute__((swift_name("vendors")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRConsent.Companion")))
@interface SPMCGDPRConsentCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGDPRConsentCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRConsent.GCMStatus")))
@interface SPMCGDPRConsentGCMStatus : SPMCBase
- (instancetype)initWithAnalyticsStorage:(NSString * _Nullable)analyticsStorage adStorage:(NSString * _Nullable)adStorage adUserData:(NSString * _Nullable)adUserData adPersonalization:(NSString * _Nullable)adPersonalization __attribute__((swift_name("init(analyticsStorage:adStorage:adUserData:adPersonalization:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGDPRConsentGCMStatusCompanion *companion __attribute__((swift_name("companion")));
- (SPMCGDPRConsentGCMStatus *)doCopyAnalyticsStorage:(NSString * _Nullable)analyticsStorage adStorage:(NSString * _Nullable)adStorage adUserData:(NSString * _Nullable)adUserData adPersonalization:(NSString * _Nullable)adPersonalization __attribute__((swift_name("doCopy(analyticsStorage:adStorage:adUserData:adPersonalization:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="ad_personalization")
*/
@property (readonly) NSString * _Nullable adPersonalization __attribute__((swift_name("adPersonalization")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="ad_storage")
*/
@property (readonly) NSString * _Nullable adStorage __attribute__((swift_name("adStorage")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="ad_user_data")
*/
@property (readonly) NSString * _Nullable adUserData __attribute__((swift_name("adUserData")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="analytics_storage")
*/
@property (readonly) NSString * _Nullable analyticsStorage __attribute__((swift_name("analyticsStorage")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRConsent.GCMStatusCompanion")))
@interface SPMCGDPRConsentGCMStatusCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGDPRConsentGCMStatusCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRConsent.VendorGrantsValue")))
@interface SPMCGDPRConsentVendorGrantsValue : SPMCBase
- (instancetype)initWithVendorGrant:(BOOL)vendorGrant purposeGrants:(NSDictionary<NSString *, SPMCBoolean *> *)purposeGrants __attribute__((swift_name("init(vendorGrant:purposeGrants:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGDPRConsentVendorGrantsValueCompanion *companion __attribute__((swift_name("companion")));
- (SPMCGDPRConsentVendorGrantsValue *)doCopyVendorGrant:(BOOL)vendorGrant purposeGrants:(NSDictionary<NSString *, SPMCBoolean *> *)purposeGrants __attribute__((swift_name("doCopy(vendorGrant:purposeGrants:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSDictionary<NSString *, SPMCBoolean *> *purposeGrants __attribute__((swift_name("purposeGrants")));
@property (readonly) BOOL vendorGrant __attribute__((swift_name("vendorGrant")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRConsent.VendorGrantsValueCompanion")))
@interface SPMCGDPRConsentVendorGrantsValueCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGDPRConsentVendorGrantsValueCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GlobalCmpConsent")))
@interface SPMCGlobalCmpConsent : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies categories:(NSArray<NSString *> *)categories consentStatus:(SPMCConsentStatus *)consentStatus dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled uuid:(NSString * _Nullable)uuid userConsents:(SPMCUserConsents *)userConsents webConsentPayload:(NSString * _Nullable)webConsentPayload __attribute__((swift_name("init(applies:categories:consentStatus:dateCreated:expirationDate:gpcEnabled:uuid:userConsents:webConsentPayload:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGlobalCmpConsentCompanion *companion __attribute__((swift_name("companion")));
- (SPMCGlobalCmpConsent *)doCopyApplies:(BOOL)applies categories:(NSArray<NSString *> *)categories consentStatus:(SPMCConsentStatus *)consentStatus dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled uuid:(NSString * _Nullable)uuid userConsents:(SPMCUserConsents *)userConsents webConsentPayload:(NSString * _Nullable)webConsentPayload __attribute__((swift_name("doCopy(applies:categories:consentStatus:dateCreated:expirationDate:gpcEnabled:uuid:userConsents:webConsentPayload:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) NSArray<NSString *> *categories __attribute__((swift_name("categories")));
@property SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCKotlinx_datetimeInstant *dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant *expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCBoolean * _Nullable gpcEnabled __attribute__((swift_name("gpcEnabled")));
@property (readonly) SPMCUserConsents *userConsents __attribute__((swift_name("userConsents")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GlobalCmpConsent.Companion")))
@interface SPMCGlobalCmpConsentCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGlobalCmpConsentCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent")))
@interface SPMCPreferencesConsent : SPMCBase
- (instancetype)initWithDateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated messageId:(SPMCInt * _Nullable)messageId status:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)status rejectedStatus:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)rejectedStatus uuid:(NSString * _Nullable)uuid __attribute__((swift_name("init(dateCreated:messageId:status:rejectedStatus:uuid:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPreferencesConsentCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPreferencesConsent *)doCopyDateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated messageId:(SPMCInt * _Nullable)messageId status:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)status rejectedStatus:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)rejectedStatus uuid:(NSString * _Nullable)uuid __attribute__((swift_name("doCopy(dateCreated:messageId:status:rejectedStatus:uuid:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCInt * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable rejectedStatus __attribute__((swift_name("rejectedStatus")));
@property (readonly) NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable status __attribute__((swift_name("status")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent.Companion")))
@interface SPMCPreferencesConsentCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPreferencesConsentCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent.PreferencesStatus")))
@interface SPMCPreferencesConsentPreferencesStatus : SPMCBase
- (instancetype)initWithCategoryId:(int32_t)categoryId channels:(NSArray<SPMCPreferencesConsentPreferencesStatusPreferencesChannels *> * _Nullable)channels changed:(SPMCBoolean * _Nullable)changed dateConsented:(SPMCKotlinx_datetimeInstant * _Nullable)dateConsented subType:(SPMCPreferencesConsentPreferencesSubType * _Nullable)subType __attribute__((swift_name("init(categoryId:channels:changed:dateConsented:subType:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPreferencesConsentPreferencesStatusCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPreferencesConsentPreferencesStatus *)doCopyCategoryId:(int32_t)categoryId channels:(NSArray<SPMCPreferencesConsentPreferencesStatusPreferencesChannels *> * _Nullable)channels changed:(SPMCBoolean * _Nullable)changed dateConsented:(SPMCKotlinx_datetimeInstant * _Nullable)dateConsented subType:(SPMCPreferencesConsentPreferencesSubType * _Nullable)subType __attribute__((swift_name("doCopy(categoryId:channels:changed:dateConsented:subType:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t categoryId __attribute__((swift_name("categoryId")));
@property (readonly) SPMCBoolean * _Nullable changed __attribute__((swift_name("changed")));
@property (readonly) NSArray<SPMCPreferencesConsentPreferencesStatusPreferencesChannels *> * _Nullable channels __attribute__((swift_name("channels")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateConsented __attribute__((swift_name("dateConsented")));
@property (readonly) SPMCPreferencesConsentPreferencesSubType * _Nullable subType __attribute__((swift_name("subType")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent.PreferencesStatusCompanion")))
@interface SPMCPreferencesConsentPreferencesStatusCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPreferencesConsentPreferencesStatusCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent.PreferencesStatusPreferencesChannels")))
@interface SPMCPreferencesConsentPreferencesStatusPreferencesChannels : SPMCBase
- (instancetype)initWithChannelId:(int32_t)channelId status:(BOOL)status __attribute__((swift_name("init(channelId:status:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPreferencesConsentPreferencesStatusPreferencesChannelsCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPreferencesConsentPreferencesStatusPreferencesChannels *)doCopyChannelId:(int32_t)channelId status:(BOOL)status __attribute__((swift_name("doCopy(channelId:status:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t channelId __attribute__((swift_name("channelId")));
@property (readonly) BOOL status __attribute__((swift_name("status")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent.PreferencesStatusPreferencesChannelsCompanion")))
@interface SPMCPreferencesConsentPreferencesStatusPreferencesChannelsCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPreferencesConsentPreferencesStatusPreferencesChannelsCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent.PreferencesSubType")))
@interface SPMCPreferencesConsentPreferencesSubType : SPMCKotlinEnum<SPMCPreferencesConsentPreferencesSubType *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCPreferencesConsentPreferencesSubTypeCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCPreferencesConsentPreferencesSubType *unknown __attribute__((swift_name("unknown")));
@property (class, readonly) SPMCPreferencesConsentPreferencesSubType *aipolicy __attribute__((swift_name("aipolicy")));
@property (class, readonly) SPMCPreferencesConsentPreferencesSubType *termsandconditions __attribute__((swift_name("termsandconditions")));
@property (class, readonly) SPMCPreferencesConsentPreferencesSubType *privacypolicy __attribute__((swift_name("privacypolicy")));
@property (class, readonly) SPMCPreferencesConsentPreferencesSubType *legalpolicy __attribute__((swift_name("legalpolicy")));
@property (class, readonly) SPMCPreferencesConsentPreferencesSubType *termsofsale __attribute__((swift_name("termsofsale")));
+ (SPMCKotlinArray<SPMCPreferencesConsentPreferencesSubType *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCPreferencesConsentPreferencesSubType *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesConsent.PreferencesSubTypeCompanion")))
@interface SPMCPreferencesConsentPreferencesSubTypeCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPreferencesConsentPreferencesSubTypeCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserData")))
@interface SPMCSPUserData : SPMCBase
- (instancetype)initWithGdpr:(SPMCSPUserDataSPConsent<SPMCGDPRConsent *> * _Nullable)gdpr ccpa:(SPMCSPUserDataSPConsent<SPMCCCPAConsent *> * _Nullable)ccpa usnat:(SPMCSPUserDataSPConsent<SPMCUSNatConsent *> * _Nullable)usnat preferences:(SPMCSPUserDataSPConsent<SPMCPreferencesConsent *> * _Nullable)preferences globalcmp:(SPMCSPUserDataSPConsent<SPMCGlobalCmpConsent *> * _Nullable)globalcmp __attribute__((swift_name("init(gdpr:ccpa:usnat:preferences:globalcmp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCSPUserDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCSPUserData *)doCopyGdpr:(SPMCSPUserDataSPConsent<SPMCGDPRConsent *> * _Nullable)gdpr ccpa:(SPMCSPUserDataSPConsent<SPMCCCPAConsent *> * _Nullable)ccpa usnat:(SPMCSPUserDataSPConsent<SPMCUSNatConsent *> * _Nullable)usnat preferences:(SPMCSPUserDataSPConsent<SPMCPreferencesConsent *> * _Nullable)preferences globalcmp:(SPMCSPUserDataSPConsent<SPMCGlobalCmpConsent *> * _Nullable)globalcmp __attribute__((swift_name("doCopy(gdpr:ccpa:usnat:preferences:globalcmp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCSPUserDataSPConsent<SPMCCCPAConsent *> * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCSPUserDataSPConsent<SPMCGDPRConsent *> * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCSPUserDataSPConsent<SPMCGlobalCmpConsent *> * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCSPUserDataSPConsent<SPMCPreferencesConsent *> * _Nullable preferences __attribute__((swift_name("preferences")));
@property (readonly) SPMCSPUserDataSPConsent<SPMCUSNatConsent *> * _Nullable usnat __attribute__((swift_name("usnat")));
@property (readonly) SPMCSPUserDataSPWebConsents *webConsents __attribute__((swift_name("webConsents")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserData.Companion")))
@interface SPMCSPUserDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPUserDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserDataSPConsent")))
@interface SPMCSPUserDataSPConsent<ConsentType> : SPMCBase
- (instancetype)initWithConsents:(ConsentType _Nullable)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("init(consents:childPmId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCSPUserDataSPConsentCompanion *companion __attribute__((swift_name("companion")));
- (SPMCSPUserDataSPConsent<ConsentType> *)doCopyConsents:(ConsentType _Nullable)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("doCopy(consents:childPmId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) ConsentType _Nullable consents __attribute__((swift_name("consents")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserDataSPConsentCompanion")))
@interface SPMCSPUserDataSPConsentCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPUserDataSPConsentCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeSerial0:(id<SPMCKotlinx_serialization_coreKSerializer>)typeSerial0 __attribute__((swift_name("serializer(typeSerial0:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserData.SPWebConsents")))
@interface SPMCSPUserDataSPWebConsents : SPMCBase
- (instancetype)initWithGdpr:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)gdpr ccpa:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)ccpa usnat:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)usnat globalcmp:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)globalcmp __attribute__((swift_name("init(gdpr:ccpa:usnat:globalcmp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCSPUserDataSPWebConsentsCompanion *companion __attribute__((swift_name("companion")));
- (SPMCSPUserDataSPWebConsents *)doCopyGdpr:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)gdpr ccpa:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)ccpa usnat:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)usnat globalcmp:(SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable)globalcmp __attribute__((swift_name("doCopy(gdpr:ccpa:usnat:globalcmp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCSPUserDataSPWebConsentsSPWebConsent * _Nullable usnat __attribute__((swift_name("usnat")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserData.SPWebConsentsCompanion")))
@interface SPMCSPUserDataSPWebConsentsCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPUserDataSPWebConsentsCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserData.SPWebConsentsSPWebConsent")))
@interface SPMCSPUserDataSPWebConsentsSPWebConsent : SPMCBase
- (instancetype)initWithUuid:(NSString *)uuid webConsentPayload:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)webConsentPayload __attribute__((swift_name("init(uuid:webConsentPayload:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCSPUserDataSPWebConsentsSPWebConsentCompanion *companion __attribute__((swift_name("companion")));
- (SPMCSPUserDataSPWebConsentsSPWebConsent *)doCopyUuid:(NSString *)uuid webConsentPayload:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)webConsentPayload __attribute__((swift_name("doCopy(uuid:webConsentPayload:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *uuid __attribute__((swift_name("uuid")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SPUserData.SPWebConsentsSPWebConsentCompanion")))
@interface SPMCSPUserDataSPWebConsentsSPWebConsentCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCSPUserDataSPWebConsentsSPWebConsentCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State")))
@interface SPMCState : SPMCBase
- (instancetype)initWithGdpr:(SPMCStateGDPRState *)gdpr ccpa:(SPMCStateCCPAState *)ccpa usNat:(SPMCStateUSNatState *)usNat ios14:(SPMCAttCampaign *)ios14 globalcmp:(SPMCStateGlobalCmpState *)globalcmp preferences:(SPMCStatePreferencesState *)preferences authId:(NSString * _Nullable)authId propertyId:(int32_t)propertyId accountId:(int32_t)accountId localVersion:(int32_t)localVersion localState:(NSString *)localState nonKeyedLocalState:(NSString *)nonKeyedLocalState __attribute__((swift_name("init(gdpr:ccpa:usNat:ios14:globalcmp:preferences:authId:propertyId:accountId:localVersion:localState:nonKeyedLocalState:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateCompanion *companion __attribute__((swift_name("companion")));
- (SPMCState *)doCopyGdpr:(SPMCStateGDPRState *)gdpr ccpa:(SPMCStateCCPAState *)ccpa usNat:(SPMCStateUSNatState *)usNat ios14:(SPMCAttCampaign *)ios14 globalcmp:(SPMCStateGlobalCmpState *)globalcmp preferences:(SPMCStatePreferencesState *)preferences authId:(NSString * _Nullable)authId propertyId:(int32_t)propertyId accountId:(int32_t)accountId localVersion:(int32_t)localVersion localState:(NSString *)localState nonKeyedLocalState:(NSString *)nonKeyedLocalState __attribute__((swift_name("doCopy(gdpr:ccpa:usNat:ios14:globalcmp:preferences:authId:propertyId:accountId:localVersion:localState:nonKeyedLocalState:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
- (void)updateGDPRStatusForVendorListChanges __attribute__((swift_name("updateGDPRStatusForVendorListChanges()")));
- (void)updateGlobaCMPStatusForVendorListChanges __attribute__((swift_name("updateGlobaCMPStatusForVendorListChanges()")));
- (void)updateUSNatStatusForVendorListChanges __attribute__((swift_name("updateUSNatStatusForVendorListChanges()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property NSString * _Nullable authId __attribute__((swift_name("authId")));
@property SPMCStateCCPAState *ccpa __attribute__((swift_name("ccpa")));
@property SPMCStateGDPRState *gdpr __attribute__((swift_name("gdpr")));
@property SPMCStateGlobalCmpState *globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) BOOL hasCCPALocalData __attribute__((swift_name("hasCCPALocalData")));
@property (readonly) BOOL hasGDPRLocalData __attribute__((swift_name("hasGDPRLocalData")));
@property (readonly) BOOL hasGlobalCmpLocalData __attribute__((swift_name("hasGlobalCmpLocalData")));
@property (readonly) BOOL hasPreferencesLocalData __attribute__((swift_name("hasPreferencesLocalData")));
@property (readonly) BOOL hasUSNatLocalData __attribute__((swift_name("hasUSNatLocalData")));
@property SPMCAttCampaign *ios14 __attribute__((swift_name("ios14")));
@property NSString *localState __attribute__((swift_name("localState")));
@property int32_t localVersion __attribute__((swift_name("localVersion")));
@property NSString *nonKeyedLocalState __attribute__((swift_name("nonKeyedLocalState")));
@property SPMCStatePreferencesState *preferences __attribute__((swift_name("preferences")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property SPMCStateUSNatState *usNat __attribute__((swift_name("usNat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.CCPAState")))
@interface SPMCStateCCPAState : SPMCBase
- (instancetype)initWithMetaData:(SPMCStateCCPAStateCCPAMetaData *)metaData consents:(SPMCCCPAConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("init(metaData:consents:childPmId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateCCPAStateCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateCCPAState *)doCopyMetaData:(SPMCStateCCPAStateCCPAMetaData *)metaData consents:(SPMCCCPAConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("doCopy(metaData:consents:childPmId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) SPMCCCPAConsent *consents __attribute__((swift_name("consents")));
@property (readonly) SPMCStateCCPAStateCCPAMetaData *metaData __attribute__((swift_name("metaData")));
@end

__attribute__((swift_name("StateSPSampleable")))
@protocol SPMCStateSPSampleable
@required
- (void)updateSampleFieldsNewSampleRate:(float)newSampleRate __attribute__((swift_name("updateSampleFields(newSampleRate:)")));
@property float sampleRate __attribute__((swift_name("sampleRate")));
@property SPMCBoolean * _Nullable wasSampled __attribute__((swift_name("wasSampled")));
@property SPMCFloat * _Nullable wasSampledAt __attribute__((swift_name("wasSampledAt")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.CCPAStateCCPAMetaData")))
@interface SPMCStateCCPAStateCCPAMetaData : SPMCBase <SPMCStateSPSampleable>
- (instancetype)initWithSampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt __attribute__((swift_name("init(sampleRate:wasSampled:wasSampledAt:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateCCPAStateCCPAMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateCCPAStateCCPAMetaData *)doCopySampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt __attribute__((swift_name("doCopy(sampleRate:wasSampled:wasSampledAt:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property float sampleRate __attribute__((swift_name("sampleRate")));
@property SPMCBoolean * _Nullable wasSampled __attribute__((swift_name("wasSampled")));
@property SPMCFloat * _Nullable wasSampledAt __attribute__((swift_name("wasSampledAt")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.CCPAStateCCPAMetaDataCompanion")))
@interface SPMCStateCCPAStateCCPAMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateCCPAStateCCPAMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.CCPAStateCompanion")))
@interface SPMCStateCCPAStateCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateCCPAStateCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.Companion")))
@interface SPMCStateCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@property (readonly) int32_t VERSION __attribute__((swift_name("VERSION")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GDPRState")))
@interface SPMCStateGDPRState : SPMCBase
- (instancetype)initWithMetaData:(SPMCStateGDPRStateGDPRMetaData *)metaData consents:(SPMCGDPRConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("init(metaData:consents:childPmId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateGDPRStateCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateGDPRState *)doCopyMetaData:(SPMCStateGDPRStateGDPRMetaData *)metaData consents:(SPMCGDPRConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("doCopy(metaData:consents:childPmId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCStateGDPRState *)resetStateIfVendorListChangesNewVendorListId:(NSString *)newVendorListId __attribute__((swift_name("resetStateIfVendorListChanges(newVendorListId:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) SPMCGDPRConsent *consents __attribute__((swift_name("consents")));
@property (readonly) SPMCStateGDPRStateGDPRMetaData *metaData __attribute__((swift_name("metaData")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GDPRStateCompanion")))
@interface SPMCStateGDPRStateCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateGDPRStateCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GDPRStateGDPRMetaData")))
@interface SPMCStateGDPRStateGDPRMetaData : SPMCBase <SPMCStateSPSampleable>
- (instancetype)initWithAdditionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate legalBasisChangeDate:(SPMCKotlinx_datetimeInstant *)legalBasisChangeDate sampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt vendorListId:(NSString * _Nullable)vendorListId __attribute__((swift_name("init(additionsChangeDate:legalBasisChangeDate:sampleRate:wasSampled:wasSampledAt:vendorListId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateGDPRStateGDPRMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateGDPRStateGDPRMetaData *)doCopyAdditionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate legalBasisChangeDate:(SPMCKotlinx_datetimeInstant *)legalBasisChangeDate sampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt vendorListId:(NSString * _Nullable)vendorListId __attribute__((swift_name("doCopy(additionsChangeDate:legalBasisChangeDate:sampleRate:wasSampled:wasSampledAt:vendorListId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant *additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) SPMCKotlinx_datetimeInstant *legalBasisChangeDate __attribute__((swift_name("legalBasisChangeDate")));
@property float sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) NSString * _Nullable vendorListId __attribute__((swift_name("vendorListId")));
@property SPMCBoolean * _Nullable wasSampled __attribute__((swift_name("wasSampled")));
@property SPMCFloat * _Nullable wasSampledAt __attribute__((swift_name("wasSampledAt")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GDPRStateGDPRMetaDataCompanion")))
@interface SPMCStateGDPRStateGDPRMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateGDPRStateGDPRMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GlobalCmpState")))
@interface SPMCStateGlobalCmpState : SPMCBase
- (instancetype)initWithMetaData:(SPMCStateGlobalCmpStateGlobalCmpMetaData *)metaData consents:(SPMCGlobalCmpConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("init(metaData:consents:childPmId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateGlobalCmpStateCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateGlobalCmpState *)doCopyMetaData:(SPMCStateGlobalCmpStateGlobalCmpMetaData *)metaData consents:(SPMCGlobalCmpConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("doCopy(metaData:consents:childPmId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCStateGlobalCmpState *)resetStateIfVendorListChangesNewVendorListId:(NSString *)newVendorListId __attribute__((swift_name("resetStateIfVendorListChanges(newVendorListId:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) SPMCGlobalCmpConsent *consents __attribute__((swift_name("consents")));
@property (readonly) SPMCStateGlobalCmpStateGlobalCmpMetaData *metaData __attribute__((swift_name("metaData")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GlobalCmpStateCompanion")))
@interface SPMCStateGlobalCmpStateCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateGlobalCmpStateCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GlobalCmpStateGlobalCmpMetaData")))
@interface SPMCStateGlobalCmpStateGlobalCmpMetaData : SPMCBase <SPMCStateSPSampleable>
- (instancetype)initWithAdditionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate sampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt vendorListId:(NSString * _Nullable)vendorListId applicableSections:(NSArray<NSString *> *)applicableSections legislation:(NSString * _Nullable)legislation __attribute__((swift_name("init(additionsChangeDate:sampleRate:wasSampled:wasSampledAt:vendorListId:applicableSections:legislation:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateGlobalCmpStateGlobalCmpMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateGlobalCmpStateGlobalCmpMetaData *)doCopyAdditionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate sampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt vendorListId:(NSString * _Nullable)vendorListId applicableSections:(NSArray<NSString *> *)applicableSections legislation:(NSString * _Nullable)legislation __attribute__((swift_name("doCopy(additionsChangeDate:sampleRate:wasSampled:wasSampledAt:vendorListId:applicableSections:legislation:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant *additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) NSArray<NSString *> *applicableSections __attribute__((swift_name("applicableSections")));
@property (readonly) NSString * _Nullable legislation __attribute__((swift_name("legislation")));
@property float sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) NSString * _Nullable vendorListId __attribute__((swift_name("vendorListId")));
@property SPMCBoolean * _Nullable wasSampled __attribute__((swift_name("wasSampled")));
@property SPMCFloat * _Nullable wasSampledAt __attribute__((swift_name("wasSampledAt")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.GlobalCmpStateGlobalCmpMetaDataCompanion")))
@interface SPMCStateGlobalCmpStateGlobalCmpMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateGlobalCmpStateGlobalCmpMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.PreferencesState")))
@interface SPMCStatePreferencesState : SPMCBase
- (instancetype)initWithMetaData:(SPMCStatePreferencesStatePreferencesMetaData *)metaData consents:(SPMCPreferencesConsent *)consents __attribute__((swift_name("init(metaData:consents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStatePreferencesStateCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStatePreferencesState *)doCopyMetaData:(SPMCStatePreferencesStatePreferencesMetaData *)metaData consents:(SPMCPreferencesConsent *)consents __attribute__((swift_name("doCopy(metaData:consents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCPreferencesConsent *consents __attribute__((swift_name("consents")));
@property (readonly) SPMCStatePreferencesStatePreferencesMetaData *metaData __attribute__((swift_name("metaData")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.PreferencesStateCompanion")))
@interface SPMCStatePreferencesStateCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStatePreferencesStateCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.PreferencesStatePreferencesMetaData")))
@interface SPMCStatePreferencesStatePreferencesMetaData : SPMCBase
- (instancetype)initWithConfigurationId:(NSString *)configurationId additionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate legalDocLiveDate:(NSDictionary<SPMCPreferencesConsentPreferencesSubType *, SPMCKotlinx_datetimeInstant *> * _Nullable)legalDocLiveDate __attribute__((swift_name("init(configurationId:additionsChangeDate:legalDocLiveDate:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStatePreferencesStatePreferencesMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStatePreferencesStatePreferencesMetaData *)doCopyConfigurationId:(NSString *)configurationId additionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate legalDocLiveDate:(NSDictionary<SPMCPreferencesConsentPreferencesSubType *, SPMCKotlinx_datetimeInstant *> * _Nullable)legalDocLiveDate __attribute__((swift_name("doCopy(configurationId:additionsChangeDate:legalDocLiveDate:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant *additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) NSString *configurationId __attribute__((swift_name("configurationId")));
@property (readonly) NSDictionary<SPMCPreferencesConsentPreferencesSubType *, SPMCKotlinx_datetimeInstant *> * _Nullable legalDocLiveDate __attribute__((swift_name("legalDocLiveDate")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.PreferencesStatePreferencesMetaDataCompanion")))
@interface SPMCStatePreferencesStatePreferencesMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStatePreferencesStatePreferencesMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.USNatState")))
@interface SPMCStateUSNatState : SPMCBase
- (instancetype)initWithMetaData:(SPMCStateUSNatStateUsNatMetaData *)metaData consents:(SPMCUSNatConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("init(metaData:consents:childPmId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateUSNatStateCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateUSNatState *)doCopyMetaData:(SPMCStateUSNatStateUsNatMetaData *)metaData consents:(SPMCUSNatConsent *)consents childPmId:(NSString * _Nullable)childPmId __attribute__((swift_name("doCopy(metaData:consents:childPmId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCStateUSNatState *)resetStateIfVendorListChangesNewVendorListId:(NSString *)newVendorListId __attribute__((swift_name("resetStateIfVendorListChanges(newVendorListId:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) SPMCUSNatConsent *consents __attribute__((swift_name("consents")));
@property (readonly) SPMCStateUSNatStateUsNatMetaData *metaData __attribute__((swift_name("metaData")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.USNatStateCompanion")))
@interface SPMCStateUSNatStateCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateUSNatStateCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.USNatStateUsNatMetaData")))
@interface SPMCStateUSNatStateUsNatMetaData : SPMCBase <SPMCStateSPSampleable>
- (instancetype)initWithAdditionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate sampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt vendorListId:(NSString * _Nullable)vendorListId applicableSections:(NSArray<SPMCInt *> *)applicableSections __attribute__((swift_name("init(additionsChangeDate:sampleRate:wasSampled:wasSampledAt:vendorListId:applicableSections:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCStateUSNatStateUsNatMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCStateUSNatStateUsNatMetaData *)doCopyAdditionsChangeDate:(SPMCKotlinx_datetimeInstant *)additionsChangeDate sampleRate:(float)sampleRate wasSampled:(SPMCBoolean * _Nullable)wasSampled wasSampledAt:(SPMCFloat * _Nullable)wasSampledAt vendorListId:(NSString * _Nullable)vendorListId applicableSections:(NSArray<SPMCInt *> *)applicableSections __attribute__((swift_name("doCopy(additionsChangeDate:sampleRate:wasSampled:wasSampledAt:vendorListId:applicableSections:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant *additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) NSArray<SPMCInt *> *applicableSections __attribute__((swift_name("applicableSections")));
@property float sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) NSString * _Nullable vendorListId __attribute__((swift_name("vendorListId")));
@property SPMCBoolean * _Nullable wasSampled __attribute__((swift_name("wasSampled")));
@property SPMCFloat * _Nullable wasSampledAt __attribute__((swift_name("wasSampledAt")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("State.USNatStateUsNatMetaDataCompanion")))
@interface SPMCStateUSNatStateUsNatMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCStateUSNatStateUsNatMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatConsent")))
@interface SPMCUSNatConsent : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate uuid:(NSString * _Nullable)uuid webConsentPayload:(NSString * _Nullable)webConsentPayload consentStatus:(SPMCConsentStatus *)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> *)consentStrings userConsents:(SPMCUserConsents *)userConsents gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("init(applies:dateCreated:expirationDate:uuid:webConsentPayload:consentStatus:consentStrings:userConsents:gppData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCUSNatConsentCompanion *companion __attribute__((swift_name("companion")));
- (SPMCUSNatConsent *)doCopyApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant *)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant *)expirationDate uuid:(NSString * _Nullable)uuid webConsentPayload:(NSString * _Nullable)webConsentPayload consentStatus:(SPMCConsentStatus *)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> *)consentStrings userConsents:(SPMCUserConsents *)userConsents gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("doCopy(applies:dateCreated:expirationDate:uuid:webConsentPayload:consentStatus:consentStrings:userConsents:gppData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) NSArray<SPMCUSNatConsentUSNatConsentSection *> *consentStrings __attribute__((swift_name("consentStrings")));
@property (readonly) SPMCKotlinx_datetimeInstant *dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant *expirationDate __attribute__((swift_name("expirationDate")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *gppData __attribute__((swift_name("gppData")));
@property SPMCUserConsents *userConsents __attribute__((swift_name("userConsents")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatConsent.Companion")))
@interface SPMCUSNatConsentCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCUSNatConsentCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatConsent.USNatConsentSection")))
@interface SPMCUSNatConsentUSNatConsentSection : SPMCBase
- (instancetype)initWithSectionId:(int32_t)sectionId sectionName:(NSString *)sectionName consentString:(NSString *)consentString __attribute__((swift_name("init(sectionId:sectionName:consentString:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCUSNatConsentUSNatConsentSectionCompanion *companion __attribute__((swift_name("companion")));
- (SPMCUSNatConsentUSNatConsentSection *)doCopySectionId:(int32_t)sectionId sectionName:(NSString *)sectionName consentString:(NSString *)consentString __attribute__((swift_name("doCopy(sectionId:sectionName:consentString:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *consentString __attribute__((swift_name("consentString")));
@property (readonly) int32_t sectionId __attribute__((swift_name("sectionId")));
@property (readonly) NSString *sectionName __attribute__((swift_name("sectionName")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatConsent.USNatConsentSectionCompanion")))
@interface SPMCUSNatConsentUSNatConsentSectionCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCUSNatConsentUSNatConsentSectionCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UserConsents")))
@interface SPMCUserConsents : SPMCBase
- (instancetype)initWithVendors:(NSArray<SPMCUserConsentsConsentable *> *)vendors categories:(NSArray<SPMCUserConsentsConsentable *> *)categories __attribute__((swift_name("init(vendors:categories:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCUserConsentsCompanion *companion __attribute__((swift_name("companion")));
- (SPMCUserConsents *)doCopyVendors:(NSArray<SPMCUserConsentsConsentable *> *)vendors categories:(NSArray<SPMCUserConsentsConsentable *> *)categories __attribute__((swift_name("doCopy(vendors:categories:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<SPMCUserConsentsConsentable *> *categories __attribute__((swift_name("categories")));
@property (readonly) NSArray<SPMCUserConsentsConsentable *> *vendors __attribute__((swift_name("vendors")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UserConsents.Companion")))
@interface SPMCUserConsentsCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCUserConsentsCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UserConsents.Consentable")))
@interface SPMCUserConsentsConsentable : SPMCBase
- (instancetype)initWithId:(NSString *)id systemId:(SPMCInt * _Nullable)systemId consented:(BOOL)consented __attribute__((swift_name("init(id:systemId:consented:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCUserConsentsConsentableCompanion *companion __attribute__((swift_name("companion")));
- (SPMCUserConsentsConsentable *)doCopyId:(NSString *)id systemId:(SPMCInt * _Nullable)systemId consented:(BOOL)consented __attribute__((swift_name("doCopy(id:systemId:consented:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL consented __attribute__((swift_name("consented")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="_id")
*/
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) SPMCInt * _Nullable systemId __attribute__((swift_name("systemId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UserConsents.ConsentableCompanion")))
@interface SPMCUserConsentsConsentableCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCUserConsentsConsentableCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ErrorMetricsRequest")))
@interface SPMCErrorMetricsRequest : SPMCBase
- (instancetype)initWithCode:(NSString *)code accountId:(NSString *)accountId scriptVersion:(NSString *)scriptVersion legislation:(SPMCSPCampaignType * _Nullable)legislation sdkOsVersion:(NSString *)sdkOsVersion deviceFamily:(NSString *)deviceFamily propertyId:(NSString *)propertyId __attribute__((swift_name("init(code:accountId:scriptVersion:legislation:sdkOsVersion:deviceFamily:propertyId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCErrorMetricsRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCErrorMetricsRequest *)doCopyCode:(NSString *)code accountId:(NSString *)accountId scriptVersion:(NSString *)scriptVersion legislation:(SPMCSPCampaignType * _Nullable)legislation sdkOsVersion:(NSString *)sdkOsVersion deviceFamily:(NSString *)deviceFamily propertyId:(NSString *)propertyId __attribute__((swift_name("doCopy(code:accountId:scriptVersion:legislation:sdkOsVersion:deviceFamily:propertyId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *accountId __attribute__((swift_name("accountId")));
@property (readonly) NSString *code __attribute__((swift_name("code")));
@property (readonly) NSString *deviceFamily __attribute__((swift_name("deviceFamily")));
@property (readonly) SPMCSPCampaignType * _Nullable legislation __attribute__((swift_name("legislation")));
@property (readonly) NSString *propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSString *scriptVersion __attribute__((swift_name("scriptVersion")));
@property (readonly) NSString *sdkOsVersion __attribute__((swift_name("sdkOsVersion")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ErrorMetricsRequest.Companion")))
@interface SPMCErrorMetricsRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCErrorMetricsRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PlatformHttpClient")))
@interface SPMCPlatformHttpClient : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property (class, readonly, getter=companion) SPMCPlatformHttpClientCompanion *companion __attribute__((swift_name("companion")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PlatformHttpClient.Companion")))
@interface SPMCPlatformHttpClientCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPlatformHttpClientCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_client_coreHttpClient *)create __attribute__((swift_name("create()")));
@end

__attribute__((swift_name("SPClient")))
@protocol SPMCSPClient
@required

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)customConsentGDPRConsentUUID:(NSString *)consentUUID propertyId:(int32_t)propertyId vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(SPMCGDPRConsent * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("customConsentGDPR(consentUUID:propertyId:vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)deleteCustomConsentGDPRConsentUUID:(NSString *)consentUUID propertyId:(int32_t)propertyId vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(SPMCGDPRConsent * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("deleteCustomConsentGDPR(consentUUID:propertyId:vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)errorMetricsError:(SPMCSPError *)error completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("errorMetrics(error:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getChoiceAllActionType:(SPMCSPActionType *)actionType campaigns:(SPMCChoiceAllRequestChoiceAllCampaigns *)campaigns completionHandler:(void (^)(SPMCChoiceAllResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getChoiceAll(actionType:campaigns:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getConsentStatusAuthId:(NSString * _Nullable)authId metadata:(SPMCConsentStatusRequestMetaData *)metadata completionHandler:(void (^)(SPMCConsentStatusResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getConsentStatus(authId:metadata:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getMessagesRequest:(SPMCMessagesRequest *)request completionHandler:(void (^)(SPMCMessagesResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getMessages(request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getMetaDataCampaigns:(SPMCMetaDataRequestCampaigns *)campaigns completionHandler:(void (^)(SPMCMetaDataResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getMetaData(campaigns:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceCCPAActionActionType:(SPMCSPActionType *)actionType request:(SPMCCCPAChoiceRequest *)request completionHandler:(void (^)(SPMCCCPAChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceCCPAAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceGDPRActionActionType:(SPMCSPActionType *)actionType request:(SPMCGDPRChoiceRequest *)request completionHandler:(void (^)(SPMCGDPRChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceGDPRAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceGlobalCmpActionActionType:(SPMCSPActionType *)actionType request:(SPMCGlobalCmpChoiceRequest *)request completionHandler:(void (^)(SPMCGlobalCmpChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceGlobalCmpAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoicePreferencesActionActionType:(SPMCSPActionType *)actionType request:(SPMCPreferencesChoiceRequest *)request completionHandler:(void (^)(SPMCPreferencesChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoicePreferencesAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceUSNatActionActionType:(SPMCSPActionType *)actionType request:(SPMCUSNatChoiceRequest *)request completionHandler:(void (^)(SPMCUSNatChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceUSNatAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postPvDataRequest:(SPMCPvDataRequest *)request completionHandler:(void (^)(SPMCPvDataResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postPvData(request:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postReportIdfaStatusPropertyId:(SPMCInt * _Nullable)propertyId uuid:(NSString * _Nullable)uuid requestUUID:(NSString *)requestUUID uuidType:(SPMCSPCampaignType * _Nullable)uuidType messageId:(SPMCInt * _Nullable)messageId idfaStatus:(SPMCSPIDFAStatus *)idfaStatus iosVersion:(NSString *)iosVersion partitionUUID:(NSString * _Nullable)partitionUUID completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("postReportIdfaStatus(propertyId:uuid:requestUUID:uuidType:messageId:idfaStatus:iosVersion:partitionUUID:completionHandler:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SourcepointClient")))
@interface SPMCSourcepointClient : SPMCBase <SPMCSPClient>
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId requestTimeoutInSeconds:(int32_t)requestTimeoutInSeconds __attribute__((swift_name("init(accountId:propertyId:requestTimeoutInSeconds:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId httpEngine:(id<SPMCKtor_client_coreHttpClientEngine>)httpEngine requestTimeoutInSeconds:(int32_t)requestTimeoutInSeconds __attribute__((swift_name("init(accountId:propertyId:httpEngine:requestTimeoutInSeconds:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId httpEngine:(id<SPMCKtor_client_coreHttpClientEngine> _Nullable)httpEngine device:(SPMCDeviceInformation *)device requestTimeoutInSeconds:(int32_t)requestTimeoutInSeconds __attribute__((swift_name("init(accountId:propertyId:httpEngine:device:requestTimeoutInSeconds:)"))) __attribute__((objc_designated_initializer));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)customConsentGDPRConsentUUID:(NSString *)consentUUID propertyId:(int32_t)propertyId vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(SPMCGDPRConsent * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("customConsentGDPR(consentUUID:propertyId:vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)deleteCustomConsentGDPRConsentUUID:(NSString *)consentUUID propertyId:(int32_t)propertyId vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories completionHandler:(void (^)(SPMCGDPRConsent * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("deleteCustomConsentGDPR(consentUUID:propertyId:vendors:categories:legIntCategories:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)errorMetricsError:(SPMCSPError *)error completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("errorMetrics(error:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getChoiceAllActionType:(SPMCSPActionType *)actionType campaigns:(SPMCChoiceAllRequestChoiceAllCampaigns *)campaigns completionHandler:(void (^)(SPMCChoiceAllResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getChoiceAll(actionType:campaigns:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getConsentStatusAuthId:(NSString * _Nullable)authId metadata:(SPMCConsentStatusRequestMetaData *)metadata completionHandler:(void (^)(SPMCConsentStatusResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getConsentStatus(authId:metadata:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getMessagesRequest:(SPMCMessagesRequest *)request completionHandler:(void (^)(SPMCMessagesResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getMessages(request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)getMetaDataCampaigns:(SPMCMetaDataRequestCampaigns *)campaigns completionHandler:(void (^)(SPMCMetaDataResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getMetaData(campaigns:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceCCPAActionActionType:(SPMCSPActionType *)actionType request:(SPMCCCPAChoiceRequest *)request completionHandler:(void (^)(SPMCCCPAChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceCCPAAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceGDPRActionActionType:(SPMCSPActionType *)actionType request:(SPMCGDPRChoiceRequest *)request completionHandler:(void (^)(SPMCGDPRChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceGDPRAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceGlobalCmpActionActionType:(SPMCSPActionType *)actionType request:(SPMCGlobalCmpChoiceRequest *)request completionHandler:(void (^)(SPMCGlobalCmpChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceGlobalCmpAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoicePreferencesActionActionType:(SPMCSPActionType *)actionType request:(SPMCPreferencesChoiceRequest *)request completionHandler:(void (^)(SPMCPreferencesChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoicePreferencesAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postChoiceUSNatActionActionType:(SPMCSPActionType *)actionType request:(SPMCUSNatChoiceRequest *)request completionHandler:(void (^)(SPMCUSNatChoiceResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postChoiceUSNatAction(actionType:request:completionHandler:)")));

/**
 * @note This method converts instances of SPNetworkError, SPUnableToParseBodyError, CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postPvDataRequest:(SPMCPvDataRequest *)request completionHandler:(void (^)(SPMCPvDataResponse * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("postPvData(request:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)postReportIdfaStatusPropertyId:(SPMCInt * _Nullable)propertyId uuid:(NSString * _Nullable)uuid requestUUID:(NSString *)requestUUID uuidType:(SPMCSPCampaignType * _Nullable)uuidType messageId:(SPMCInt * _Nullable)messageId idfaStatus:(SPMCSPIDFAStatus *)idfaStatus iosVersion:(NSString *)iosVersion partitionUUID:(NSString * _Nullable)partitionUUID completionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("postReportIdfaStatus(propertyId:uuid:requestUUID:uuidType:messageId:idfaStatus:iosVersion:partitionUUID:completionHandler:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("WrapHttpTimeoutErrorConfig")))
@interface SPMCWrapHttpTimeoutErrorConfig : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property int32_t timeoutInSeconds __attribute__((swift_name("timeoutInSeconds")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAChoiceRequest")))
@interface SPMCCCPAChoiceRequest : SPMCBase
- (instancetype)initWithAuthId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid messageId:(NSString * _Nullable)messageId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pubData pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables sendPVData:(BOOL)sendPVData propertyId:(int32_t)propertyId sampleRate:(float)sampleRate includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("init(authId:uuid:messageId:pubData:pmSaveAndExitVariables:sendPVData:propertyId:sampleRate:includeData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCCCPAChoiceRequestCompanion *companion __attribute__((swift_name("companion")));
@property (readonly) NSString * _Nullable authId __attribute__((swift_name("authId")));
@property (readonly) SPMCIncludeData *includeData __attribute__((swift_name("includeData")));
@property (readonly) NSString * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pmSaveAndExitVariables __attribute__((swift_name("pmSaveAndExitVariables")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pubData __attribute__((swift_name("pubData")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) BOOL sendPVData __attribute__((swift_name("sendPVData")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAChoiceRequest.Companion")))
@interface SPMCCCPAChoiceRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCCCPAChoiceRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((swift_name("DefaultRequest")))
@interface SPMCDefaultRequest : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithSeen0:(int32_t)seen0 env:(NSString * _Nullable)env scriptType:(NSString * _Nullable)scriptType scriptVersion:(NSString * _Nullable)scriptVersion serializationConstructorMarker:(id _Nullable)serializationConstructorMarker __attribute__((swift_name("init(seen0:env:scriptType:scriptVersion:serializationConstructorMarker:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCDefaultRequestCompanion *companion __attribute__((swift_name("companion")));
@property (readonly) NSString *env __attribute__((swift_name("env")));
@property (readonly) NSString *scriptType __attribute__((swift_name("scriptType")));
@property (readonly) NSString *scriptVersion __attribute__((swift_name("scriptVersion")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllRequest")))
@interface SPMCChoiceAllRequest : SPMCDefaultRequest
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId campaigns:(SPMCChoiceAllRequestChoiceAllCampaigns *)campaigns idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus includeData:(SPMCIncludeData * _Nullable)includeData hasCsp:(BOOL)hasCsp withSiteActions:(BOOL)withSiteActions includeCustomVendorsRes:(BOOL)includeCustomVendorsRes __attribute__((swift_name("init(accountId:propertyId:campaigns:idfaStatus:includeData:hasCsp:withSiteActions:includeCustomVendorsRes:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (instancetype)initWithSeen0:(int32_t)seen0 env:(NSString * _Nullable)env scriptType:(NSString * _Nullable)scriptType scriptVersion:(NSString * _Nullable)scriptVersion serializationConstructorMarker:(id _Nullable)serializationConstructorMarker __attribute__((swift_name("init(seen0:env:scriptType:scriptVersion:serializationConstructorMarker:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCChoiceAllRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllRequest *)doCopyAccountId:(int32_t)accountId propertyId:(int32_t)propertyId campaigns:(SPMCChoiceAllRequestChoiceAllCampaigns *)campaigns idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus includeData:(SPMCIncludeData * _Nullable)includeData hasCsp:(BOOL)hasCsp withSiteActions:(BOOL)withSiteActions includeCustomVendorsRes:(BOOL)includeCustomVendorsRes __attribute__((swift_name("doCopy(accountId:propertyId:campaigns:idfaStatus:includeData:hasCsp:withSiteActions:includeCustomVendorsRes:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="metadata")
*/
@property (readonly) SPMCChoiceAllRequestChoiceAllCampaigns *campaigns __attribute__((swift_name("campaigns")));
@property (readonly) SPMCSPIDFAStatus * _Nullable idfaStatus __attribute__((swift_name("idfaStatus")));
@property (readonly) SPMCIncludeData * _Nullable includeData __attribute__((swift_name("includeData")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllRequest.ChoiceAllCampaigns")))
@interface SPMCChoiceAllRequestChoiceAllCampaigns : SPMCBase
- (instancetype)initWithGdpr:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)gdpr ccpa:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)ccpa usnat:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)usnat globalcmp:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)globalcmp __attribute__((swift_name("init(gdpr:ccpa:usnat:globalcmp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllRequestChoiceAllCampaignsCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllRequestChoiceAllCampaigns *)doCopyGdpr:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)gdpr ccpa:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)ccpa usnat:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)usnat globalcmp:(SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable)globalcmp __attribute__((swift_name("doCopy(gdpr:ccpa:usnat:globalcmp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCChoiceAllRequestChoiceAllCampaignsCampaign * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllRequest.ChoiceAllCampaignsCampaign")))
@interface SPMCChoiceAllRequestChoiceAllCampaignsCampaign : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies __attribute__((swift_name("init(applies:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllRequestChoiceAllCampaignsCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllRequestChoiceAllCampaignsCampaign *)doCopyApplies:(BOOL)applies __attribute__((swift_name("doCopy(applies:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllRequest.ChoiceAllCampaignsCampaignCompanion")))
@interface SPMCChoiceAllRequestChoiceAllCampaignsCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllRequestChoiceAllCampaignsCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllRequest.ChoiceAllCampaignsCompanion")))
@interface SPMCChoiceAllRequestChoiceAllCampaignsCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllRequestChoiceAllCampaignsCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllRequest.Companion")))
@interface SPMCChoiceAllRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest")))
@interface SPMCConsentStatusRequest : SPMCDefaultRequest
- (instancetype)initWithPropertyId:(int32_t)propertyId metadata:(SPMCConsentStatusRequestMetaData *)metadata includeData:(SPMCIncludeData *)includeData authId:(NSString * _Nullable)authId withSiteActions:(BOOL)withSiteActions hasCsp:(BOOL)hasCsp __attribute__((swift_name("init(propertyId:metadata:includeData:authId:withSiteActions:hasCsp:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (instancetype)initWithSeen0:(int32_t)seen0 env:(NSString * _Nullable)env scriptType:(NSString * _Nullable)scriptType scriptVersion:(NSString * _Nullable)scriptVersion serializationConstructorMarker:(id _Nullable)serializationConstructorMarker __attribute__((swift_name("init(seen0:env:scriptType:scriptVersion:serializationConstructorMarker:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCConsentStatusRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusRequest *)doCopyPropertyId:(int32_t)propertyId metadata:(SPMCConsentStatusRequestMetaData *)metadata includeData:(SPMCIncludeData *)includeData authId:(NSString * _Nullable)authId withSiteActions:(BOOL)withSiteActions hasCsp:(BOOL)hasCsp __attribute__((swift_name("doCopy(propertyId:metadata:includeData:authId:withSiteActions:hasCsp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable authId __attribute__((swift_name("authId")));
@property (readonly) BOOL hasCsp __attribute__((swift_name("hasCsp")));
@property (readonly) SPMCIncludeData *includeData __attribute__((swift_name("includeData")));
@property (readonly) SPMCConsentStatusRequestMetaData *metadata __attribute__((swift_name("metadata")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) BOOL withSiteActions __attribute__((swift_name("withSiteActions")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.Companion")))
@interface SPMCConsentStatusRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaData")))
@interface SPMCConsentStatusRequestMetaData : SPMCBase
- (instancetype)initWithGdpr:(SPMCConsentStatusRequestMetaDataCampaign * _Nullable)gdpr globalcmp:(SPMCConsentStatusRequestMetaDataGlobalCmpCampaign * _Nullable)globalcmp usnat:(SPMCConsentStatusRequestMetaDataUSNatCampaign * _Nullable)usnat ccpa:(SPMCConsentStatusRequestMetaDataCampaign * _Nullable)ccpa preferences:(SPMCConsentStatusRequestMetaDataPreferencesCampaign * _Nullable)preferences __attribute__((swift_name("init(gdpr:globalcmp:usnat:ccpa:preferences:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusRequestMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusRequestMetaData *)doCopyGdpr:(SPMCConsentStatusRequestMetaDataCampaign * _Nullable)gdpr globalcmp:(SPMCConsentStatusRequestMetaDataGlobalCmpCampaign * _Nullable)globalcmp usnat:(SPMCConsentStatusRequestMetaDataUSNatCampaign * _Nullable)usnat ccpa:(SPMCConsentStatusRequestMetaDataCampaign * _Nullable)ccpa preferences:(SPMCConsentStatusRequestMetaDataPreferencesCampaign * _Nullable)preferences __attribute__((swift_name("doCopy(gdpr:globalcmp:usnat:ccpa:preferences:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCConsentStatusRequestMetaDataCampaign * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCConsentStatusRequestMetaDataCampaign * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCConsentStatusRequestMetaDataGlobalCmpCampaign * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCConsentStatusRequestMetaDataPreferencesCampaign * _Nullable preferences __attribute__((swift_name("preferences")));
@property (readonly) SPMCConsentStatusRequestMetaDataUSNatCampaign * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataCampaign")))
@interface SPMCConsentStatusRequestMetaDataCampaign : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated uuid:(NSString * _Nullable)uuid hasLocalData:(BOOL)hasLocalData idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus __attribute__((swift_name("init(applies:dateCreated:uuid:hasLocalData:idfaStatus:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusRequestMetaDataCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusRequestMetaDataCampaign *)doCopyApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated uuid:(NSString * _Nullable)uuid hasLocalData:(BOOL)hasLocalData idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus __attribute__((swift_name("doCopy(applies:dateCreated:uuid:hasLocalData:idfaStatus:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) BOOL hasLocalData __attribute__((swift_name("hasLocalData")));
@property (readonly) SPMCSPIDFAStatus * _Nullable idfaStatus __attribute__((swift_name("idfaStatus")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataCampaignCompanion")))
@interface SPMCConsentStatusRequestMetaDataCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusRequestMetaDataCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataCompanion")))
@interface SPMCConsentStatusRequestMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusRequestMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataGlobalCmpCampaign")))
@interface SPMCConsentStatusRequestMetaDataGlobalCmpCampaign : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated uuid:(NSString * _Nullable)uuid hasLocalData:(BOOL)hasLocalData __attribute__((swift_name("init(applies:dateCreated:uuid:hasLocalData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusRequestMetaDataGlobalCmpCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusRequestMetaDataGlobalCmpCampaign *)doCopyApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated uuid:(NSString * _Nullable)uuid hasLocalData:(BOOL)hasLocalData __attribute__((swift_name("doCopy(applies:dateCreated:uuid:hasLocalData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) BOOL hasLocalData __attribute__((swift_name("hasLocalData")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataGlobalCmpCampaignCompanion")))
@interface SPMCConsentStatusRequestMetaDataGlobalCmpCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusRequestMetaDataGlobalCmpCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataPreferencesCampaign")))
@interface SPMCConsentStatusRequestMetaDataPreferencesCampaign : SPMCBase
- (instancetype)initWithHasLocalData:(BOOL)hasLocalData configurationId:(NSString * _Nullable)configurationId __attribute__((swift_name("init(hasLocalData:configurationId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusRequestMetaDataPreferencesCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusRequestMetaDataPreferencesCampaign *)doCopyHasLocalData:(BOOL)hasLocalData configurationId:(NSString * _Nullable)configurationId __attribute__((swift_name("doCopy(hasLocalData:configurationId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable configurationId __attribute__((swift_name("configurationId")));
@property (readonly) BOOL hasLocalData __attribute__((swift_name("hasLocalData")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataPreferencesCampaignCompanion")))
@interface SPMCConsentStatusRequestMetaDataPreferencesCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusRequestMetaDataPreferencesCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataUSNatCampaign")))
@interface SPMCConsentStatusRequestMetaDataUSNatCampaign : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated uuid:(NSString * _Nullable)uuid hasLocalData:(BOOL)hasLocalData idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus transitionCCPAAuth:(SPMCBoolean * _Nullable)transitionCCPAAuth optedOut:(SPMCBoolean * _Nullable)optedOut __attribute__((swift_name("init(applies:dateCreated:uuid:hasLocalData:idfaStatus:transitionCCPAAuth:optedOut:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusRequestMetaDataUSNatCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusRequestMetaDataUSNatCampaign *)doCopyApplies:(BOOL)applies dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated uuid:(NSString * _Nullable)uuid hasLocalData:(BOOL)hasLocalData idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus transitionCCPAAuth:(SPMCBoolean * _Nullable)transitionCCPAAuth optedOut:(SPMCBoolean * _Nullable)optedOut __attribute__((swift_name("doCopy(applies:dateCreated:uuid:hasLocalData:idfaStatus:transitionCCPAAuth:optedOut:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) BOOL hasLocalData __attribute__((swift_name("hasLocalData")));
@property (readonly) SPMCSPIDFAStatus * _Nullable idfaStatus __attribute__((swift_name("idfaStatus")));
@property (readonly) SPMCBoolean * _Nullable optedOut __attribute__((swift_name("optedOut")));
@property (readonly) SPMCBoolean * _Nullable transitionCCPAAuth __attribute__((swift_name("transitionCCPAAuth")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusRequest.MetaDataUSNatCampaignCompanion")))
@interface SPMCConsentStatusRequestMetaDataUSNatCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusRequestMetaDataUSNatCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CustomConsentRequest")))
@interface SPMCCustomConsentRequest : SPMCBase
- (instancetype)initWithConsentUUID:(NSString *)consentUUID propertyId:(int32_t)propertyId vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories __attribute__((swift_name("init(consentUUID:propertyId:vendors:categories:legIntCategories:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCCustomConsentRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCCustomConsentRequest *)doCopyConsentUUID:(NSString *)consentUUID propertyId:(int32_t)propertyId vendors:(NSArray<NSString *> *)vendors categories:(NSArray<NSString *> *)categories legIntCategories:(NSArray<NSString *> *)legIntCategories __attribute__((swift_name("doCopy(consentUUID:propertyId:vendors:categories:legIntCategories:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<NSString *> *categories __attribute__((swift_name("categories")));
@property (readonly) NSString *consentUUID __attribute__((swift_name("consentUUID")));
@property (readonly) NSArray<NSString *> *legIntCategories __attribute__((swift_name("legIntCategories")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSArray<NSString *> *vendors __attribute__((swift_name("vendors")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CustomConsentRequest.Companion")))
@interface SPMCCustomConsentRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCCustomConsentRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DefaultRequest.Companion")))
@interface SPMCDefaultRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCDefaultRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DeleteCustomConsentRequest")))
@interface SPMCDeleteCustomConsentRequest : SPMCDefaultRequest
- (instancetype)initWithConsentUUID:(NSString *)consentUUID __attribute__((swift_name("init(consentUUID:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (instancetype)initWithSeen0:(int32_t)seen0 env:(NSString * _Nullable)env scriptType:(NSString * _Nullable)scriptType scriptVersion:(NSString * _Nullable)scriptVersion serializationConstructorMarker:(id _Nullable)serializationConstructorMarker __attribute__((swift_name("init(seen0:env:scriptType:scriptVersion:serializationConstructorMarker:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCDeleteCustomConsentRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCDeleteCustomConsentRequest *)doCopyConsentUUID:(NSString *)consentUUID __attribute__((swift_name("doCopy(consentUUID:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *consentUUID __attribute__((swift_name("consentUUID")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DeleteCustomConsentRequest.Companion")))
@interface SPMCDeleteCustomConsentRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCDeleteCustomConsentRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRChoiceRequest")))
@interface SPMCGDPRChoiceRequest : SPMCBase
- (instancetype)initWithAuthId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid messageId:(NSString * _Nullable)messageId consentAllRef:(NSString * _Nullable)consentAllRef vendorListId:(NSString * _Nullable)vendorListId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pubData pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables sendPVData:(BOOL)sendPVData propertyId:(int32_t)propertyId sampleRate:(float)sampleRate idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("init(authId:uuid:messageId:consentAllRef:vendorListId:pubData:pmSaveAndExitVariables:sendPVData:propertyId:sampleRate:idfaStatus:granularStatus:includeData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGDPRChoiceRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCGDPRChoiceRequest *)doCopyAuthId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid messageId:(NSString * _Nullable)messageId consentAllRef:(NSString * _Nullable)consentAllRef vendorListId:(NSString * _Nullable)vendorListId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pubData pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables sendPVData:(BOOL)sendPVData propertyId:(int32_t)propertyId sampleRate:(float)sampleRate idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("doCopy(authId:uuid:messageId:consentAllRef:vendorListId:pubData:pmSaveAndExitVariables:sendPVData:propertyId:sampleRate:idfaStatus:granularStatus:includeData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable authId __attribute__((swift_name("authId")));
@property (readonly) NSString * _Nullable consentAllRef __attribute__((swift_name("consentAllRef")));
@property (readonly) SPMCConsentStatusConsentStatusGranularStatus * _Nullable granularStatus __attribute__((swift_name("granularStatus")));
@property (readonly) SPMCSPIDFAStatus * _Nullable idfaStatus __attribute__((swift_name("idfaStatus")));
@property (readonly) SPMCIncludeData *includeData __attribute__((swift_name("includeData")));
@property (readonly) NSString * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pmSaveAndExitVariables __attribute__((swift_name("pmSaveAndExitVariables")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pubData __attribute__((swift_name("pubData")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) BOOL sendPVData __attribute__((swift_name("sendPVData")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable vendorListId __attribute__((swift_name("vendorListId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRChoiceRequest.Companion")))
@interface SPMCGDPRChoiceRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGDPRChoiceRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GlobalCmpChoiceRequest")))
@interface SPMCGlobalCmpChoiceRequest : SPMCBase
- (instancetype)initWithAuthId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid messageId:(NSString * _Nullable)messageId vendorListId:(NSString * _Nullable)vendorListId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pubData pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables sendPVData:(BOOL)sendPVData propertyId:(int32_t)propertyId sampleRate:(float)sampleRate granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("init(authId:uuid:messageId:vendorListId:pubData:pmSaveAndExitVariables:sendPVData:propertyId:sampleRate:granularStatus:includeData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGlobalCmpChoiceRequestCompanion *companion __attribute__((swift_name("companion")));
@property (readonly) NSString * _Nullable authId __attribute__((swift_name("authId")));
@property (readonly) SPMCConsentStatusConsentStatusGranularStatus * _Nullable granularStatus __attribute__((swift_name("granularStatus")));
@property (readonly) SPMCIncludeData *includeData __attribute__((swift_name("includeData")));
@property (readonly) NSString * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pmSaveAndExitVariables __attribute__((swift_name("pmSaveAndExitVariables")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pubData __attribute__((swift_name("pubData")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) BOOL sendPVData __attribute__((swift_name("sendPVData")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable vendorListId __attribute__((swift_name("vendorListId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GlobalCmpChoiceRequest.Companion")))
@interface SPMCGlobalCmpChoiceRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGlobalCmpChoiceRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IDFAStatusReportRequest")))
@interface SPMCIDFAStatusReportRequest : SPMCBase
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(SPMCInt * _Nullable)propertyId uuid:(NSString * _Nullable)uuid uuidType:(SPMCSPCampaignType * _Nullable)uuidType requestUUID:(NSString *)requestUUID iosVersion:(NSString *)iosVersion appleTracking:(SPMCIDFAStatusReportRequestAppleTrackingPayload *)appleTracking __attribute__((swift_name("init(accountId:propertyId:uuid:uuidType:requestUUID:iosVersion:appleTracking:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCIDFAStatusReportRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCIDFAStatusReportRequest *)doCopyAccountId:(int32_t)accountId propertyId:(SPMCInt * _Nullable)propertyId uuid:(NSString * _Nullable)uuid uuidType:(SPMCSPCampaignType * _Nullable)uuidType requestUUID:(NSString *)requestUUID iosVersion:(NSString *)iosVersion appleTracking:(SPMCIDFAStatusReportRequestAppleTrackingPayload *)appleTracking __attribute__((swift_name("doCopy(accountId:propertyId:uuid:uuidType:requestUUID:iosVersion:appleTracking:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) SPMCIDFAStatusReportRequestAppleTrackingPayload *appleTracking __attribute__((swift_name("appleTracking")));
@property (readonly) NSString *iosVersion __attribute__((swift_name("iosVersion")));
@property (readonly) SPMCInt * _Nullable propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSString *requestUUID __attribute__((swift_name("requestUUID")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) SPMCSPCampaignType * _Nullable uuidType __attribute__((swift_name("uuidType")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IDFAStatusReportRequest.AppleTrackingPayload")))
@interface SPMCIDFAStatusReportRequestAppleTrackingPayload : SPMCBase
- (instancetype)initWithAppleChoice:(SPMCSPIDFAStatus *)appleChoice appleMsgId:(SPMCInt * _Nullable)appleMsgId messagePartitionUUID:(NSString * _Nullable)messagePartitionUUID __attribute__((swift_name("init(appleChoice:appleMsgId:messagePartitionUUID:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCIDFAStatusReportRequestAppleTrackingPayloadCompanion *companion __attribute__((swift_name("companion")));
- (SPMCIDFAStatusReportRequestAppleTrackingPayload *)doCopyAppleChoice:(SPMCSPIDFAStatus *)appleChoice appleMsgId:(SPMCInt * _Nullable)appleMsgId messagePartitionUUID:(NSString * _Nullable)messagePartitionUUID __attribute__((swift_name("doCopy(appleChoice:appleMsgId:messagePartitionUUID:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCSPIDFAStatus *appleChoice __attribute__((swift_name("appleChoice")));
@property (readonly) SPMCInt * _Nullable appleMsgId __attribute__((swift_name("appleMsgId")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="partition_uuid")
*/
@property (readonly) NSString * _Nullable messagePartitionUUID __attribute__((swift_name("messagePartitionUUID")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IDFAStatusReportRequest.AppleTrackingPayloadCompanion")))
@interface SPMCIDFAStatusReportRequestAppleTrackingPayloadCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCIDFAStatusReportRequestAppleTrackingPayloadCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IDFAStatusReportRequest.Companion")))
@interface SPMCIDFAStatusReportRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCIDFAStatusReportRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData")))
@interface SPMCIncludeData : SPMCBase
- (instancetype)initWithTcData:(SPMCIncludeDataTypeString *)tcData webConsentPayload:(SPMCIncludeDataTypeString *)webConsentPayload localState:(SPMCIncludeDataTypeString *)localState categories:(BOOL)categories translateMessage:(SPMCBoolean * _Nullable)translateMessage gppData:(SPMCIncludeDataGPPConfig *)gppData __attribute__((swift_name("init(tcData:webConsentPayload:localState:categories:translateMessage:gppData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCIncludeDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCIncludeData *)doCopyTcData:(SPMCIncludeDataTypeString *)tcData webConsentPayload:(SPMCIncludeDataTypeString *)webConsentPayload localState:(SPMCIncludeDataTypeString *)localState categories:(BOOL)categories translateMessage:(SPMCBoolean * _Nullable)translateMessage gppData:(SPMCIncludeDataGPPConfig *)gppData __attribute__((swift_name("doCopy(tcData:webConsentPayload:localState:categories:translateMessage:gppData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL categories __attribute__((swift_name("categories")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) SPMCIncludeDataGPPConfig *gppData __attribute__((swift_name("gppData")));
@property (readonly) SPMCIncludeDataTypeString *localState __attribute__((swift_name("localState")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="TCData")
*/
@property (readonly) SPMCIncludeDataTypeString *tcData __attribute__((swift_name("tcData")));
@property SPMCBoolean * _Nullable translateMessage __attribute__((swift_name("translateMessage")));
@property (readonly) SPMCIncludeDataTypeString *webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.Companion")))
@interface SPMCIncludeDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCIncludeDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.GPPConfig")))
@interface SPMCIncludeDataGPPConfig : SPMCBase
- (instancetype)initWithMspaCoveredTransaction:(SPMCIncludeDataMspaBinaryFlag * _Nullable)MspaCoveredTransaction MspaOptOutOptionMode:(SPMCIncludeDataMspaTernaryFlag * _Nullable)MspaOptOutOptionMode MspaServiceProviderMode:(SPMCIncludeDataMspaTernaryFlag * _Nullable)MspaServiceProviderMode uspString:(SPMCBoolean * _Nullable)uspString __attribute__((swift_name("init(MspaCoveredTransaction:MspaOptOutOptionMode:MspaServiceProviderMode:uspString:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCIncludeDataGPPConfigCompanion *companion __attribute__((swift_name("companion")));
- (SPMCIncludeDataGPPConfig *)doCopyMspaCoveredTransaction:(SPMCIncludeDataMspaBinaryFlag * _Nullable)MspaCoveredTransaction MspaOptOutOptionMode:(SPMCIncludeDataMspaTernaryFlag * _Nullable)MspaOptOutOptionMode MspaServiceProviderMode:(SPMCIncludeDataMspaTernaryFlag * _Nullable)MspaServiceProviderMode uspString:(SPMCBoolean * _Nullable)uspString __attribute__((swift_name("doCopy(MspaCoveredTransaction:MspaOptOutOptionMode:MspaServiceProviderMode:uspString:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCIncludeDataMspaBinaryFlag * _Nullable MspaCoveredTransaction __attribute__((swift_name("MspaCoveredTransaction")));
@property (readonly) SPMCIncludeDataMspaTernaryFlag * _Nullable MspaOptOutOptionMode __attribute__((swift_name("MspaOptOutOptionMode")));
@property (readonly) SPMCIncludeDataMspaTernaryFlag * _Nullable MspaServiceProviderMode __attribute__((swift_name("MspaServiceProviderMode")));
@property (readonly) SPMCBoolean * _Nullable uspString __attribute__((swift_name("uspString")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.GPPConfigCompanion")))
@interface SPMCIncludeDataGPPConfigCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCIncludeDataGPPConfigCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.MspaBinaryFlag")))
@interface SPMCIncludeDataMspaBinaryFlag : SPMCKotlinEnum<SPMCIncludeDataMspaBinaryFlag *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCIncludeDataMspaBinaryFlagCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCIncludeDataMspaBinaryFlag *yes __attribute__((swift_name("yes")));
@property (class, readonly) SPMCIncludeDataMspaBinaryFlag *no __attribute__((swift_name("no")));
+ (SPMCKotlinArray<SPMCIncludeDataMspaBinaryFlag *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCIncludeDataMspaBinaryFlag *> *entries __attribute__((swift_name("entries")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.MspaBinaryFlagCompanion")))
@interface SPMCIncludeDataMspaBinaryFlagCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCIncludeDataMspaBinaryFlagCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.MspaTernaryFlag")))
@interface SPMCIncludeDataMspaTernaryFlag : SPMCKotlinEnum<SPMCIncludeDataMspaTernaryFlag *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCIncludeDataMspaTernaryFlagCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCIncludeDataMspaTernaryFlag *yes __attribute__((swift_name("yes")));
@property (class, readonly) SPMCIncludeDataMspaTernaryFlag *no __attribute__((swift_name("no")));
@property (class, readonly) SPMCIncludeDataMspaTernaryFlag *na __attribute__((swift_name("na")));
+ (SPMCKotlinArray<SPMCIncludeDataMspaTernaryFlag *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCIncludeDataMspaTernaryFlag *> *entries __attribute__((swift_name("entries")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.MspaTernaryFlagCompanion")))
@interface SPMCIncludeDataMspaTernaryFlagCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCIncludeDataMspaTernaryFlagCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.TypeString")))
@interface SPMCIncludeDataTypeString : SPMCBase
- (instancetype)initWithType:(NSString *)type __attribute__((swift_name("init(type:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCIncludeDataTypeStringCompanion *companion __attribute__((swift_name("companion")));
- (SPMCIncludeDataTypeString *)doCopyType:(NSString *)type __attribute__((swift_name("doCopy(type:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IncludeData.TypeStringCompanion")))
@interface SPMCIncludeDataTypeStringCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCIncludeDataTypeStringCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest")))
@interface SPMCMessagesRequest : SPMCDefaultRequest
- (instancetype)initWithBody:(SPMCMessagesRequestBody *)body metadata:(SPMCMessagesRequestMetaData *)metadata nonKeyedLocalState:(NSString * _Nullable)nonKeyedLocalState localState:(NSString * _Nullable)localState __attribute__((swift_name("init(body:metadata:nonKeyedLocalState:localState:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (instancetype)initWithSeen0:(int32_t)seen0 env:(NSString * _Nullable)env scriptType:(NSString * _Nullable)scriptType scriptVersion:(NSString * _Nullable)scriptVersion serializationConstructorMarker:(id _Nullable)serializationConstructorMarker __attribute__((swift_name("init(seen0:env:scriptType:scriptVersion:serializationConstructorMarker:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCMessagesRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequest *)doCopyBody:(SPMCMessagesRequestBody *)body metadata:(SPMCMessagesRequestMetaData *)metadata nonKeyedLocalState:(NSString * _Nullable)nonKeyedLocalState localState:(NSString * _Nullable)localState __attribute__((swift_name("doCopy(body:metadata:nonKeyedLocalState:localState:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCMessagesRequestBody *body __attribute__((swift_name("body")));
@property (readonly) NSString * _Nullable localState __attribute__((swift_name("localState")));
@property (readonly) SPMCMessagesRequestMetaData *metadata __attribute__((swift_name("metadata")));
@property (readonly) NSString * _Nullable nonKeyedLocalState __attribute__((swift_name("nonKeyedLocalState")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.Body")))
@interface SPMCMessagesRequestBody : SPMCBase
- (instancetype)initWithPropertyHref:(SPMCSPPropertyName *)propertyHref accountId:(int32_t)accountId campaigns:(SPMCMessagesRequestBodyCampaigns *)campaigns consentLanguage:(SPMCSPMessageLanguage * _Nullable)consentLanguage hasCSP:(BOOL)hasCSP campaignEnv:(SPMCSPCampaignEnv *)campaignEnv idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("init(propertyHref:accountId:campaigns:consentLanguage:hasCSP:campaignEnv:idfaStatus:includeData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesRequestBodyCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequestBody *)doCopyPropertyHref:(SPMCSPPropertyName *)propertyHref accountId:(int32_t)accountId campaigns:(SPMCMessagesRequestBodyCampaigns *)campaigns consentLanguage:(SPMCSPMessageLanguage * _Nullable)consentLanguage hasCSP:(BOOL)hasCSP campaignEnv:(SPMCSPCampaignEnv *)campaignEnv idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("doCopy(propertyHref:accountId:campaigns:consentLanguage:hasCSP:campaignEnv:idfaStatus:includeData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) SPMCSPCampaignEnv *campaignEnv __attribute__((swift_name("campaignEnv")));
@property (readonly) SPMCMessagesRequestBodyCampaigns *campaigns __attribute__((swift_name("campaigns")));
@property (readonly) SPMCSPMessageLanguage * _Nullable consentLanguage __attribute__((swift_name("consentLanguage")));
@property (readonly) BOOL hasCSP __attribute__((swift_name("hasCSP")));
@property (readonly) SPMCSPIDFAStatus * _Nullable idfaStatus __attribute__((swift_name("idfaStatus")));
@property (readonly) SPMCIncludeData *includeData __attribute__((swift_name("includeData")));
@property (readonly) SPMCSPPropertyName *propertyHref __attribute__((swift_name("propertyHref")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaigns")))
@interface SPMCMessagesRequestBodyCampaigns : SPMCBase
- (instancetype)initWithGdpr:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)gdpr ios14:(SPMCMessagesRequestBodyCampaignsIOS14Campaign * _Nullable)ios14 ccpa:(SPMCMessagesRequestBodyCampaignsCCPACampaign * _Nullable)ccpa globalcmp:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)globalcmp usnat:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)usnat preferences:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)preferences __attribute__((swift_name("init(gdpr:ios14:ccpa:globalcmp:usnat:preferences:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesRequestBodyCampaignsCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequestBodyCampaigns *)doCopyGdpr:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)gdpr ios14:(SPMCMessagesRequestBodyCampaignsIOS14Campaign * _Nullable)ios14 ccpa:(SPMCMessagesRequestBodyCampaignsCCPACampaign * _Nullable)ccpa globalcmp:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)globalcmp usnat:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)usnat preferences:(SPMCMessagesRequestBodyCampaignsCampaign * _Nullable)preferences __attribute__((swift_name("doCopy(gdpr:ios14:ccpa:globalcmp:usnat:preferences:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCMessagesRequestBodyCampaignsCCPACampaign * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCMessagesRequestBodyCampaignsCampaign * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCMessagesRequestBodyCampaignsCampaign * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCMessagesRequestBodyCampaignsIOS14Campaign * _Nullable ios14 __attribute__((swift_name("ios14")));
@property (readonly) SPMCMessagesRequestBodyCampaignsCampaign * _Nullable preferences __attribute__((swift_name("preferences")));
@property (readonly) SPMCMessagesRequestBodyCampaignsCampaign * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaignsCCPACampaign")))
@interface SPMCMessagesRequestBodyCampaignsCCPACampaign : SPMCBase
- (instancetype)initWithTargetingParams:(NSDictionary<NSString *, NSString *> * _Nullable)targetingParams hasLocalData:(BOOL)hasLocalData status:(SPMCCCPAConsentCCPAConsentStatus * _Nullable)status __attribute__((swift_name("init(targetingParams:hasLocalData:status:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesRequestBodyCampaignsCCPACampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequestBodyCampaignsCCPACampaign *)doCopyTargetingParams:(NSDictionary<NSString *, NSString *> * _Nullable)targetingParams hasLocalData:(BOOL)hasLocalData status:(SPMCCCPAConsentCCPAConsentStatus * _Nullable)status __attribute__((swift_name("doCopy(targetingParams:hasLocalData:status:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL hasLocalData __attribute__((swift_name("hasLocalData")));
@property (readonly) SPMCCCPAConsentCCPAConsentStatus * _Nullable status __attribute__((swift_name("status")));
@property (readonly) NSDictionary<NSString *, NSString *> * _Nullable targetingParams __attribute__((swift_name("targetingParams")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaignsCCPACampaignCompanion")))
@interface SPMCMessagesRequestBodyCampaignsCCPACampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestBodyCampaignsCCPACampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaignsCampaign")))
@interface SPMCMessagesRequestBodyCampaignsCampaign : SPMCBase
- (instancetype)initWithTargetingParams:(NSDictionary<NSString *, NSString *> * _Nullable)targetingParams hasLocalData:(BOOL)hasLocalData consentStatus:(SPMCConsentStatus *)consentStatus __attribute__((swift_name("init(targetingParams:hasLocalData:consentStatus:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesRequestBodyCampaignsCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequestBodyCampaignsCampaign *)doCopyTargetingParams:(NSDictionary<NSString *, NSString *> * _Nullable)targetingParams hasLocalData:(BOOL)hasLocalData consentStatus:(SPMCConsentStatus *)consentStatus __attribute__((swift_name("doCopy(targetingParams:hasLocalData:consentStatus:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) BOOL hasLocalData __attribute__((swift_name("hasLocalData")));
@property (readonly) NSDictionary<NSString *, NSString *> * _Nullable targetingParams __attribute__((swift_name("targetingParams")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaignsCampaignCompanion")))
@interface SPMCMessagesRequestBodyCampaignsCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestBodyCampaignsCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaignsCompanion")))
@interface SPMCMessagesRequestBodyCampaignsCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestBodyCampaignsCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaignsIOS14Campaign")))
@interface SPMCMessagesRequestBodyCampaignsIOS14Campaign : SPMCBase
- (instancetype)initWithTargetingParams:(NSDictionary<NSString *, NSString *> * _Nullable)targetingParams idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus __attribute__((swift_name("init(targetingParams:idfaStatus:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesRequestBodyCampaignsIOS14CampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequestBodyCampaignsIOS14Campaign *)doCopyTargetingParams:(NSDictionary<NSString *, NSString *> * _Nullable)targetingParams idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus __attribute__((swift_name("doCopy(targetingParams:idfaStatus:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCSPIDFAStatus * _Nullable idfaStatus __attribute__((swift_name("idfaStatus")));
@property (readonly) NSDictionary<NSString *, NSString *> * _Nullable targetingParams __attribute__((swift_name("targetingParams")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCampaignsIOS14CampaignCompanion")))
@interface SPMCMessagesRequestBodyCampaignsIOS14CampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestBodyCampaignsIOS14CampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.BodyCompanion")))
@interface SPMCMessagesRequestBodyCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestBodyCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.Companion")))
@interface SPMCMessagesRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.MetaData")))
@interface SPMCMessagesRequestMetaData : SPMCBase
- (instancetype)initWithGdpr:(SPMCMessagesRequestMetaDataCampaign * _Nullable)gdpr globalcmp:(SPMCMessagesRequestMetaDataCampaign * _Nullable)globalcmp usnat:(SPMCMessagesRequestMetaDataCampaign * _Nullable)usnat ccpa:(SPMCMessagesRequestMetaDataCampaign * _Nullable)ccpa __attribute__((swift_name("init(gdpr:globalcmp:usnat:ccpa:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesRequestMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequestMetaData *)doCopyGdpr:(SPMCMessagesRequestMetaDataCampaign * _Nullable)gdpr globalcmp:(SPMCMessagesRequestMetaDataCampaign * _Nullable)globalcmp usnat:(SPMCMessagesRequestMetaDataCampaign * _Nullable)usnat ccpa:(SPMCMessagesRequestMetaDataCampaign * _Nullable)ccpa __attribute__((swift_name("doCopy(gdpr:globalcmp:usnat:ccpa:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCMessagesRequestMetaDataCampaign * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCMessagesRequestMetaDataCampaign * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCMessagesRequestMetaDataCampaign * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCMessagesRequestMetaDataCampaign * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.MetaDataCampaign")))
@interface SPMCMessagesRequestMetaDataCampaign : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies __attribute__((swift_name("init(applies:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesRequestMetaDataCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesRequestMetaDataCampaign *)doCopyApplies:(BOOL)applies __attribute__((swift_name("doCopy(applies:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.MetaDataCampaignCompanion")))
@interface SPMCMessagesRequestMetaDataCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestMetaDataCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesRequest.MetaDataCompanion")))
@interface SPMCMessagesRequestMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesRequestMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataRequest")))
@interface SPMCMetaDataRequest : SPMCDefaultRequest
- (instancetype)initWithAccountId:(int32_t)accountId propertyId:(int32_t)propertyId metadata:(SPMCMetaDataRequestCampaigns *)metadata __attribute__((swift_name("init(accountId:propertyId:metadata:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (instancetype)initWithSeen0:(int32_t)seen0 env:(NSString * _Nullable)env scriptType:(NSString * _Nullable)scriptType scriptVersion:(NSString * _Nullable)scriptVersion serializationConstructorMarker:(id _Nullable)serializationConstructorMarker __attribute__((swift_name("init(seen0:env:scriptType:scriptVersion:serializationConstructorMarker:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCMetaDataRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataRequest *)doCopyAccountId:(int32_t)accountId propertyId:(int32_t)propertyId metadata:(SPMCMetaDataRequestCampaigns *)metadata __attribute__((swift_name("doCopy(accountId:propertyId:metadata:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) SPMCMetaDataRequestCampaigns *metadata __attribute__((swift_name("metadata")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataRequest.Campaigns")))
@interface SPMCMetaDataRequestCampaigns : SPMCBase
- (instancetype)initWithGdpr:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)gdpr globalcmp:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)globalcmp usnat:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)usnat ccpa:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)ccpa preferences:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)preferences __attribute__((swift_name("init(gdpr:globalcmp:usnat:ccpa:preferences:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataRequestCampaignsCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataRequestCampaigns *)doCopyGdpr:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)gdpr globalcmp:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)globalcmp usnat:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)usnat ccpa:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)ccpa preferences:(SPMCMetaDataRequestCampaignsCampaign * _Nullable)preferences __attribute__((swift_name("doCopy(gdpr:globalcmp:usnat:ccpa:preferences:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCMetaDataRequestCampaignsCampaign * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCMetaDataRequestCampaignsCampaign * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCMetaDataRequestCampaignsCampaign * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCMetaDataRequestCampaignsCampaign * _Nullable preferences __attribute__((swift_name("preferences")));
@property (readonly) SPMCMetaDataRequestCampaignsCampaign * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataRequest.CampaignsCampaign")))
@interface SPMCMetaDataRequestCampaignsCampaign : SPMCBase
- (instancetype)initWithGroupPmId:(NSString * _Nullable)groupPmId __attribute__((swift_name("init(groupPmId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataRequestCampaignsCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataRequestCampaignsCampaign *)doCopyGroupPmId:(NSString * _Nullable)groupPmId __attribute__((swift_name("doCopy(groupPmId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable groupPmId __attribute__((swift_name("groupPmId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataRequest.CampaignsCampaignCompanion")))
@interface SPMCMetaDataRequestCampaignsCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataRequestCampaignsCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataRequest.CampaignsCompanion")))
@interface SPMCMetaDataRequestCampaignsCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataRequestCampaignsCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataRequest.Companion")))
@interface SPMCMetaDataRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesChoiceRequest")))
@interface SPMCPreferencesChoiceRequest : SPMCBase
- (instancetype)initWithAccountId:(int32_t)accountId messageId:(NSString * _Nullable)messageId propertyId:(int32_t)propertyId authId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("init(accountId:messageId:propertyId:authId:uuid:pmSaveAndExitVariables:includeData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPreferencesChoiceRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPreferencesChoiceRequest *)doCopyAccountId:(int32_t)accountId messageId:(NSString * _Nullable)messageId propertyId:(int32_t)propertyId authId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("doCopy(accountId:messageId:propertyId:authId:uuid:pmSaveAndExitVariables:includeData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) NSString * _Nullable authId __attribute__((swift_name("authId")));
@property (readonly) SPMCIncludeData *includeData __attribute__((swift_name("includeData")));
@property (readonly) NSString * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pmSaveAndExitVariables __attribute__((swift_name("pmSaveAndExitVariables")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesChoiceRequest.Companion")))
@interface SPMCPreferencesChoiceRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPreferencesChoiceRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest")))
@interface SPMCPvDataRequest : SPMCBase
- (instancetype)initWithGdpr:(SPMCPvDataRequestGDPR * _Nullable)gdpr ccpa:(SPMCPvDataRequestCCPA * _Nullable)ccpa usnat:(SPMCPvDataRequestUSNat * _Nullable)usnat globalcmp:(SPMCPvDataRequestGlobalCmp * _Nullable)globalcmp __attribute__((swift_name("init(gdpr:ccpa:usnat:globalcmp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPvDataRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPvDataRequest *)doCopyGdpr:(SPMCPvDataRequestGDPR * _Nullable)gdpr ccpa:(SPMCPvDataRequestCCPA * _Nullable)ccpa usnat:(SPMCPvDataRequestUSNat * _Nullable)usnat globalcmp:(SPMCPvDataRequestGlobalCmp * _Nullable)globalcmp __attribute__((swift_name("doCopy(gdpr:ccpa:usnat:globalcmp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCPvDataRequestCCPA * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCPvDataRequestGDPR * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCPvDataRequestGlobalCmp * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCPvDataRequestUSNat * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.CCPA")))
@interface SPMCPvDataRequestCCPA : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData messageId:(SPMCInt * _Nullable)messageId sampleRate:(SPMCFloat * _Nullable)sampleRate __attribute__((swift_name("init(applies:uuid:accountId:propertyId:consentStatus:pubData:messageId:sampleRate:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPvDataRequestCCPACompanion *companion __attribute__((swift_name("companion")));
- (SPMCPvDataRequestCCPA *)doCopyApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData messageId:(SPMCInt * _Nullable)messageId sampleRate:(SPMCFloat * _Nullable)sampleRate __attribute__((swift_name("doCopy(applies:uuid:accountId:propertyId:consentStatus:pubData:messageId:sampleRate:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCInt * _Nullable messageId __attribute__((swift_name("messageId")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="siteId")
*/
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable pubData __attribute__((swift_name("pubData")));
@property (readonly) SPMCFloat * _Nullable sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.CCPACompanion")))
@interface SPMCPvDataRequestCCPACompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPvDataRequestCCPACompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.Companion")))
@interface SPMCPvDataRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPvDataRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.GDPR")))
@interface SPMCPvDataRequestGDPR : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData sampleRate:(SPMCFloat * _Nullable)sampleRate euconsent:(NSString * _Nullable)euconsent msgId:(SPMCInt * _Nullable)msgId categoryId:(SPMCInt * _Nullable)categoryId subCategoryId:(SPMCInt * _Nullable)subCategoryId prtnUUID:(NSString * _Nullable)prtnUUID __attribute__((swift_name("init(applies:uuid:accountId:propertyId:consentStatus:pubData:sampleRate:euconsent:msgId:categoryId:subCategoryId:prtnUUID:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPvDataRequestGDPRCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPvDataRequestGDPR *)doCopyApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData sampleRate:(SPMCFloat * _Nullable)sampleRate euconsent:(NSString * _Nullable)euconsent msgId:(SPMCInt * _Nullable)msgId categoryId:(SPMCInt * _Nullable)categoryId subCategoryId:(SPMCInt * _Nullable)subCategoryId prtnUUID:(NSString * _Nullable)prtnUUID __attribute__((swift_name("doCopy(applies:uuid:accountId:propertyId:consentStatus:pubData:sampleRate:euconsent:msgId:categoryId:subCategoryId:prtnUUID:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) SPMCInt * _Nullable categoryId __attribute__((swift_name("categoryId")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) NSString * _Nullable euconsent __attribute__((swift_name("euconsent")));
@property (readonly) SPMCInt * _Nullable msgId __attribute__((swift_name("msgId")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="siteId")
*/
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSString * _Nullable prtnUUID __attribute__((swift_name("prtnUUID")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable pubData __attribute__((swift_name("pubData")));
@property (readonly) SPMCFloat * _Nullable sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) SPMCInt * _Nullable subCategoryId __attribute__((swift_name("subCategoryId")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.GDPRCompanion")))
@interface SPMCPvDataRequestGDPRCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPvDataRequestGDPRCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.GlobalCmp")))
@interface SPMCPvDataRequestGlobalCmp : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData sampleRate:(SPMCFloat * _Nullable)sampleRate msgId:(SPMCInt * _Nullable)msgId categoryId:(SPMCInt * _Nullable)categoryId subCategoryId:(SPMCInt * _Nullable)subCategoryId prtnUUID:(NSString * _Nullable)prtnUUID __attribute__((swift_name("init(applies:uuid:accountId:propertyId:consentStatus:pubData:sampleRate:msgId:categoryId:subCategoryId:prtnUUID:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPvDataRequestGlobalCmpCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPvDataRequestGlobalCmp *)doCopyApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData sampleRate:(SPMCFloat * _Nullable)sampleRate msgId:(SPMCInt * _Nullable)msgId categoryId:(SPMCInt * _Nullable)categoryId subCategoryId:(SPMCInt * _Nullable)subCategoryId prtnUUID:(NSString * _Nullable)prtnUUID __attribute__((swift_name("doCopy(applies:uuid:accountId:propertyId:consentStatus:pubData:sampleRate:msgId:categoryId:subCategoryId:prtnUUID:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) SPMCInt * _Nullable categoryId __attribute__((swift_name("categoryId")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCInt * _Nullable msgId __attribute__((swift_name("msgId")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="siteId")
*/
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSString * _Nullable prtnUUID __attribute__((swift_name("prtnUUID")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable pubData __attribute__((swift_name("pubData")));
@property (readonly) SPMCFloat * _Nullable sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) SPMCInt * _Nullable subCategoryId __attribute__((swift_name("subCategoryId")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.GlobalCmpCompanion")))
@interface SPMCPvDataRequestGlobalCmpCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPvDataRequestGlobalCmpCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.USNat")))
@interface SPMCPvDataRequestUSNat : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData sampleRate:(SPMCFloat * _Nullable)sampleRate msgId:(SPMCInt * _Nullable)msgId categoryId:(SPMCInt * _Nullable)categoryId subCategoryId:(SPMCInt * _Nullable)subCategoryId prtnUUID:(NSString * _Nullable)prtnUUID __attribute__((swift_name("init(applies:uuid:accountId:propertyId:consentStatus:pubData:sampleRate:msgId:categoryId:subCategoryId:prtnUUID:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPvDataRequestUSNatCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPvDataRequestUSNat *)doCopyApplies:(BOOL)applies uuid:(NSString * _Nullable)uuid accountId:(int32_t)accountId propertyId:(int32_t)propertyId consentStatus:(SPMCConsentStatus *)consentStatus pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)pubData sampleRate:(SPMCFloat * _Nullable)sampleRate msgId:(SPMCInt * _Nullable)msgId categoryId:(SPMCInt * _Nullable)categoryId subCategoryId:(SPMCInt * _Nullable)subCategoryId prtnUUID:(NSString * _Nullable)prtnUUID __attribute__((swift_name("doCopy(applies:uuid:accountId:propertyId:consentStatus:pubData:sampleRate:msgId:categoryId:subCategoryId:prtnUUID:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t accountId __attribute__((swift_name("accountId")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) SPMCInt * _Nullable categoryId __attribute__((swift_name("categoryId")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCInt * _Nullable msgId __attribute__((swift_name("msgId")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="siteId")
*/
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSString * _Nullable prtnUUID __attribute__((swift_name("prtnUUID")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable pubData __attribute__((swift_name("pubData")));
@property (readonly) SPMCFloat * _Nullable sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) SPMCInt * _Nullable subCategoryId __attribute__((swift_name("subCategoryId")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataRequest.USNatCompanion")))
@interface SPMCPvDataRequestUSNatCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPvDataRequestUSNatCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatChoiceRequest")))
@interface SPMCUSNatChoiceRequest : SPMCBase
- (instancetype)initWithAuthId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid messageId:(NSString * _Nullable)messageId vendorListId:(NSString * _Nullable)vendorListId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pubData pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables sendPVData:(BOOL)sendPVData propertyId:(int32_t)propertyId sampleRate:(float)sampleRate idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("init(authId:uuid:messageId:vendorListId:pubData:pmSaveAndExitVariables:sendPVData:propertyId:sampleRate:idfaStatus:granularStatus:includeData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCUSNatChoiceRequestCompanion *companion __attribute__((swift_name("companion")));
- (SPMCUSNatChoiceRequest *)doCopyAuthId:(NSString * _Nullable)authId uuid:(NSString * _Nullable)uuid messageId:(NSString * _Nullable)messageId vendorListId:(NSString * _Nullable)vendorListId pubData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pubData pmSaveAndExitVariables:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)pmSaveAndExitVariables sendPVData:(BOOL)sendPVData propertyId:(int32_t)propertyId sampleRate:(float)sampleRate idfaStatus:(SPMCSPIDFAStatus * _Nullable)idfaStatus granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus includeData:(SPMCIncludeData *)includeData __attribute__((swift_name("doCopy(authId:uuid:messageId:vendorListId:pubData:pmSaveAndExitVariables:sendPVData:propertyId:sampleRate:idfaStatus:granularStatus:includeData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable authId __attribute__((swift_name("authId")));
@property (readonly) SPMCConsentStatusConsentStatusGranularStatus * _Nullable granularStatus __attribute__((swift_name("granularStatus")));
@property (readonly) SPMCSPIDFAStatus * _Nullable idfaStatus __attribute__((swift_name("idfaStatus")));
@property (readonly) SPMCIncludeData *includeData __attribute__((swift_name("includeData")));
@property (readonly) NSString * _Nullable messageId __attribute__((swift_name("messageId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pmSaveAndExitVariables __attribute__((swift_name("pmSaveAndExitVariables")));
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *pubData __attribute__((swift_name("pubData")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));
@property (readonly) BOOL sendPVData __attribute__((swift_name("sendPVData")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable vendorListId __attribute__((swift_name("vendorListId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatChoiceRequest.Companion")))
@interface SPMCUSNatChoiceRequestCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCUSNatChoiceRequestCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAChoiceResponse")))
@interface SPMCCCPAChoiceResponse : SPMCBase
- (instancetype)initWithUuid:(NSString *)uuid dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated consentedAll:(SPMCBoolean * _Nullable)consentedAll rejectedAll:(SPMCBoolean * _Nullable)rejectedAll status:(SPMCCCPAConsentCCPAConsentStatus * _Nullable)status gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled rejectedVendors:(NSArray<NSString *> * _Nullable)rejectedVendors rejectedCategories:(NSArray<NSString *> * _Nullable)rejectedCategories webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("init(uuid:dateCreated:consentedAll:rejectedAll:status:gpcEnabled:rejectedVendors:rejectedCategories:webConsentPayload:gppData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCCCPAChoiceResponseCompanion *companion __attribute__((swift_name("companion")));
@property (readonly) SPMCBoolean * _Nullable consentedAll __attribute__((swift_name("consentedAll")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCBoolean * _Nullable gpcEnabled __attribute__((swift_name("gpcEnabled")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *gppData __attribute__((swift_name("gppData")));
@property (readonly) SPMCBoolean * _Nullable rejectedAll __attribute__((swift_name("rejectedAll")));
@property (readonly) NSArray<NSString *> * _Nullable rejectedCategories __attribute__((swift_name("rejectedCategories")));
@property (readonly) NSArray<NSString *> * _Nullable rejectedVendors __attribute__((swift_name("rejectedVendors")));
@property (readonly) SPMCCCPAConsentCCPAConsentStatus * _Nullable status __attribute__((swift_name("status")));
@property (readonly) NSString *uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CCPAChoiceResponse.Companion")))
@interface SPMCCCPAChoiceResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCCCPAChoiceResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse")))
@interface SPMCChoiceAllResponse : SPMCBase
- (instancetype)initWithGdpr:(SPMCChoiceAllResponseGDPR * _Nullable)gdpr ccpa:(SPMCChoiceAllResponseCCPA * _Nullable)ccpa usnat:(SPMCChoiceAllResponseUSNAT * _Nullable)usnat globalcmp:(SPMCChoiceAllResponseGLOBALCMP * _Nullable)globalcmp __attribute__((swift_name("init(gdpr:ccpa:usnat:globalcmp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllResponse *)doCopyGdpr:(SPMCChoiceAllResponseGDPR * _Nullable)gdpr ccpa:(SPMCChoiceAllResponseCCPA * _Nullable)ccpa usnat:(SPMCChoiceAllResponseUSNAT * _Nullable)usnat globalcmp:(SPMCChoiceAllResponseGLOBALCMP * _Nullable)globalcmp __attribute__((swift_name("doCopy(gdpr:ccpa:usnat:globalcmp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCChoiceAllResponseCCPA * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCChoiceAllResponseGDPR * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCChoiceAllResponseGLOBALCMP * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCChoiceAllResponseUSNAT * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.CCPA")))
@interface SPMCChoiceAllResponseCCPA : SPMCBase
- (instancetype)initWithConsentedAll:(BOOL)consentedAll dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate rejectedAll:(BOOL)rejectedAll status:(SPMCCCPAConsentCCPAConsentStatus *)status rejectedVendors:(NSArray<NSString *> *)rejectedVendors rejectedCategories:(NSArray<NSString *> *)rejectedCategories gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("init(consentedAll:dateCreated:expirationDate:rejectedAll:status:rejectedVendors:rejectedCategories:gpcEnabled:webConsentPayload:gppData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllResponseCCPACompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllResponseCCPA *)doCopyConsentedAll:(BOOL)consentedAll dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate rejectedAll:(BOOL)rejectedAll status:(SPMCCCPAConsentCCPAConsentStatus *)status rejectedVendors:(NSArray<NSString *> *)rejectedVendors rejectedCategories:(NSArray<NSString *> *)rejectedCategories gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("doCopy(consentedAll:dateCreated:expirationDate:rejectedAll:status:rejectedVendors:rejectedCategories:gpcEnabled:webConsentPayload:gppData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL consentedAll __attribute__((swift_name("consentedAll")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCBoolean * _Nullable gpcEnabled __attribute__((swift_name("gpcEnabled")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *gppData __attribute__((swift_name("gppData")));
@property (readonly) BOOL rejectedAll __attribute__((swift_name("rejectedAll")));
@property (readonly) NSArray<NSString *> *rejectedCategories __attribute__((swift_name("rejectedCategories")));
@property (readonly) NSArray<NSString *> *rejectedVendors __attribute__((swift_name("rejectedVendors")));
@property (readonly) SPMCCCPAConsentCCPAConsentStatus *status __attribute__((swift_name("status")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.CCPACompanion")))
@interface SPMCChoiceAllResponseCCPACompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllResponseCCPACompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.Companion")))
@interface SPMCChoiceAllResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.GDPR")))
@interface SPMCChoiceAllResponseGDPR : SPMCBase
- (instancetype)initWithAddtlConsent:(NSString * _Nullable)addtlConsent childPmId:(NSString * _Nullable)childPmId euconsent:(NSString *)euconsent hasLocalData:(SPMCBoolean * _Nullable)hasLocalData dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)tcData consentStatus:(SPMCConsentStatus *)consentStatus grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> *)grants postPayload:(SPMCChoiceAllResponseGDPRPostPayload * _Nullable)postPayload webConsentPayload:(NSString * _Nullable)webConsentPayload gcmStatus:(SPMCGDPRConsentGCMStatus * _Nullable)gcmStatus acceptedLegIntCategories:(NSArray<NSString *> *)acceptedLegIntCategories acceptedLegIntVendors:(NSArray<NSString *> *)acceptedLegIntVendors acceptedVendors:(NSArray<NSString *> *)acceptedVendors acceptedCategories:(NSArray<NSString *> *)acceptedCategories acceptedSpecialFeatures:(NSArray<NSString *> *)acceptedSpecialFeatures __attribute__((swift_name("init(addtlConsent:childPmId:euconsent:hasLocalData:dateCreated:expirationDate:tcData:consentStatus:grants:postPayload:webConsentPayload:gcmStatus:acceptedLegIntCategories:acceptedLegIntVendors:acceptedVendors:acceptedCategories:acceptedSpecialFeatures:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllResponseGDPRCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllResponseGDPR *)doCopyAddtlConsent:(NSString * _Nullable)addtlConsent childPmId:(NSString * _Nullable)childPmId euconsent:(NSString *)euconsent hasLocalData:(SPMCBoolean * _Nullable)hasLocalData dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)tcData consentStatus:(SPMCConsentStatus *)consentStatus grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> *)grants postPayload:(SPMCChoiceAllResponseGDPRPostPayload * _Nullable)postPayload webConsentPayload:(NSString * _Nullable)webConsentPayload gcmStatus:(SPMCGDPRConsentGCMStatus * _Nullable)gcmStatus acceptedLegIntCategories:(NSArray<NSString *> *)acceptedLegIntCategories acceptedLegIntVendors:(NSArray<NSString *> *)acceptedLegIntVendors acceptedVendors:(NSArray<NSString *> *)acceptedVendors acceptedCategories:(NSArray<NSString *> *)acceptedCategories acceptedSpecialFeatures:(NSArray<NSString *> *)acceptedSpecialFeatures __attribute__((swift_name("doCopy(addtlConsent:childPmId:euconsent:hasLocalData:dateCreated:expirationDate:tcData:consentStatus:grants:postPayload:webConsentPayload:gcmStatus:acceptedLegIntCategories:acceptedLegIntVendors:acceptedVendors:acceptedCategories:acceptedSpecialFeatures:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="categories")
*/
@property (readonly) NSArray<NSString *> *acceptedCategories __attribute__((swift_name("acceptedCategories")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="legIntCategories")
*/
@property (readonly) NSArray<NSString *> *acceptedLegIntCategories __attribute__((swift_name("acceptedLegIntCategories")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="legIntVendors")
*/
@property (readonly) NSArray<NSString *> *acceptedLegIntVendors __attribute__((swift_name("acceptedLegIntVendors")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="specialFeatures")
*/
@property (readonly) NSArray<NSString *> *acceptedSpecialFeatures __attribute__((swift_name("acceptedSpecialFeatures")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="vendors")
*/
@property (readonly) NSArray<NSString *> *acceptedVendors __attribute__((swift_name("acceptedVendors")));
@property (readonly) NSString * _Nullable addtlConsent __attribute__((swift_name("addtlConsent")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) NSString *euconsent __attribute__((swift_name("euconsent")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCGDPRConsentGCMStatus * _Nullable gcmStatus __attribute__((swift_name("gcmStatus")));
@property (readonly) NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> *grants __attribute__((swift_name("grants")));
@property (readonly) SPMCBoolean * _Nullable hasLocalData __attribute__((swift_name("hasLocalData")));
@property (readonly) SPMCChoiceAllResponseGDPRPostPayload * _Nullable postPayload __attribute__((swift_name("postPayload")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="TCData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable tcData __attribute__((swift_name("tcData")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.GDPRCompanion")))
@interface SPMCChoiceAllResponseGDPRCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllResponseGDPRCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.GDPRPostPayload")))
@interface SPMCChoiceAllResponseGDPRPostPayload : SPMCBase
- (instancetype)initWithConsentAllRef:(NSString * _Nullable)consentAllRef vendorListId:(NSString *)vendorListId granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus __attribute__((swift_name("init(consentAllRef:vendorListId:granularStatus:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllResponseGDPRPostPayloadCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllResponseGDPRPostPayload *)doCopyConsentAllRef:(NSString * _Nullable)consentAllRef vendorListId:(NSString *)vendorListId granularStatus:(SPMCConsentStatusConsentStatusGranularStatus * _Nullable)granularStatus __attribute__((swift_name("doCopy(consentAllRef:vendorListId:granularStatus:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable consentAllRef __attribute__((swift_name("consentAllRef")));
@property (readonly) SPMCConsentStatusConsentStatusGranularStatus * _Nullable granularStatus __attribute__((swift_name("granularStatus")));
@property (readonly) NSString *vendorListId __attribute__((swift_name("vendorListId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.GDPRPostPayloadCompanion")))
@interface SPMCChoiceAllResponseGDPRPostPayloadCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllResponseGDPRPostPayloadCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.GLOBALCMP")))
@interface SPMCChoiceAllResponseGLOBALCMP : SPMCBase
- (instancetype)initWithCategories:(NSArray<NSString *> *)categories consentStatus:(SPMCConsentStatus *)consentStatus consentedToAll:(BOOL)consentedToAll dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate rejectedAny:(BOOL)rejectedAny gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload __attribute__((swift_name("init(categories:consentStatus:consentedToAll:dateCreated:expirationDate:rejectedAny:gpcEnabled:webConsentPayload:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllResponseGLOBALCMPCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllResponseGLOBALCMP *)doCopyCategories:(NSArray<NSString *> *)categories consentStatus:(SPMCConsentStatus *)consentStatus consentedToAll:(BOOL)consentedToAll dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate rejectedAny:(BOOL)rejectedAny gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload __attribute__((swift_name("doCopy(categories:consentStatus:consentedToAll:dateCreated:expirationDate:rejectedAny:gpcEnabled:webConsentPayload:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<NSString *> *categories __attribute__((swift_name("categories")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) BOOL consentedToAll __attribute__((swift_name("consentedToAll")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCBoolean * _Nullable gpcEnabled __attribute__((swift_name("gpcEnabled")));
@property (readonly) BOOL rejectedAny __attribute__((swift_name("rejectedAny")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.GLOBALCMPCompanion")))
@interface SPMCChoiceAllResponseGLOBALCMPCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllResponseGLOBALCMPCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.USNAT")))
@interface SPMCChoiceAllResponseUSNAT : SPMCBase
- (instancetype)initWithCategories:(NSArray<NSString *> *)categories consentStatus:(SPMCConsentStatus *)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> *)consentStrings consentedToAll:(BOOL)consentedToAll dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate rejectedAny:(BOOL)rejectedAny gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("init(categories:consentStatus:consentStrings:consentedToAll:dateCreated:expirationDate:rejectedAny:gpcEnabled:webConsentPayload:gppData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCChoiceAllResponseUSNATCompanion *companion __attribute__((swift_name("companion")));
- (SPMCChoiceAllResponseUSNAT *)doCopyCategories:(NSArray<NSString *> *)categories consentStatus:(SPMCConsentStatus *)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> *)consentStrings consentedToAll:(BOOL)consentedToAll dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate rejectedAny:(BOOL)rejectedAny gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData __attribute__((swift_name("doCopy(categories:consentStatus:consentStrings:consentedToAll:dateCreated:expirationDate:rejectedAny:gpcEnabled:webConsentPayload:gppData:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<NSString *> *categories __attribute__((swift_name("categories")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) NSArray<SPMCUSNatConsentUSNatConsentSection *> *consentStrings __attribute__((swift_name("consentStrings")));
@property (readonly) BOOL consentedToAll __attribute__((swift_name("consentedToAll")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCBoolean * _Nullable gpcEnabled __attribute__((swift_name("gpcEnabled")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *gppData __attribute__((swift_name("gppData")));
@property (readonly) BOOL rejectedAny __attribute__((swift_name("rejectedAny")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ChoiceAllResponse.USNATCompanion")))
@interface SPMCChoiceAllResponseUSNATCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCChoiceAllResponseUSNATCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusResponse")))
@interface SPMCConsentStatusResponse : SPMCBase
- (instancetype)initWithConsentStatusData:(SPMCConsentStatusResponseConsentStatusData *)consentStatusData localState:(NSString *)localState __attribute__((swift_name("init(consentStatusData:localState:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusResponse *)doCopyConsentStatusData:(SPMCConsentStatusResponseConsentStatusData *)consentStatusData localState:(NSString *)localState __attribute__((swift_name("doCopy(consentStatusData:localState:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCConsentStatusResponseConsentStatusData *consentStatusData __attribute__((swift_name("consentStatusData")));
@property (readonly) NSString *localState __attribute__((swift_name("localState")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusResponse.Companion")))
@interface SPMCConsentStatusResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusResponse.ConsentStatusData")))
@interface SPMCConsentStatusResponseConsentStatusData : SPMCBase
- (instancetype)initWithGdpr:(SPMCGDPRConsent * _Nullable)gdpr usnat:(SPMCUSNatConsent * _Nullable)usnat ccpa:(SPMCCCPAConsent * _Nullable)ccpa preferences:(SPMCPreferencesConsent * _Nullable)preferences globalcmp:(SPMCGlobalCmpConsent * _Nullable)globalcmp __attribute__((swift_name("init(gdpr:usnat:ccpa:preferences:globalcmp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCConsentStatusResponseConsentStatusDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCConsentStatusResponseConsentStatusData *)doCopyGdpr:(SPMCGDPRConsent * _Nullable)gdpr usnat:(SPMCUSNatConsent * _Nullable)usnat ccpa:(SPMCCCPAConsent * _Nullable)ccpa preferences:(SPMCPreferencesConsent * _Nullable)preferences globalcmp:(SPMCGlobalCmpConsent * _Nullable)globalcmp __attribute__((swift_name("doCopy(gdpr:usnat:ccpa:preferences:globalcmp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCCCPAConsent * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCGDPRConsent * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCGlobalCmpConsent * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCPreferencesConsent * _Nullable preferences __attribute__((swift_name("preferences")));
@property (readonly) SPMCUSNatConsent * _Nullable usnat __attribute__((swift_name("usnat")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ConsentStatusResponse.ConsentStatusDataCompanion")))
@interface SPMCConsentStatusResponseConsentStatusDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCConsentStatusResponseConsentStatusDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRChoiceResponse")))
@interface SPMCGDPRChoiceResponse : SPMCBase
- (instancetype)initWithUuid:(NSString *)uuid dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)tcData euconsent:(NSString * _Nullable)euconsent consentStatus:(SPMCConsentStatus * _Nullable)consentStatus grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> * _Nullable)grants webConsentPayload:(NSString * _Nullable)webConsentPayload gcmStatus:(SPMCGDPRConsentGCMStatus * _Nullable)gcmStatus acceptedLegIntCategories:(NSArray<NSString *> * _Nullable)acceptedLegIntCategories acceptedLegIntVendors:(NSArray<NSString *> * _Nullable)acceptedLegIntVendors acceptedVendors:(NSArray<NSString *> * _Nullable)acceptedVendors acceptedCategories:(NSArray<NSString *> * _Nullable)acceptedCategories acceptedSpecialFeatures:(NSArray<NSString *> * _Nullable)acceptedSpecialFeatures __attribute__((swift_name("init(uuid:dateCreated:expirationDate:tcData:euconsent:consentStatus:grants:webConsentPayload:gcmStatus:acceptedLegIntCategories:acceptedLegIntVendors:acceptedVendors:acceptedCategories:acceptedSpecialFeatures:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGDPRChoiceResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCGDPRChoiceResponse *)doCopyUuid:(NSString *)uuid dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)tcData euconsent:(NSString * _Nullable)euconsent consentStatus:(SPMCConsentStatus * _Nullable)consentStatus grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> * _Nullable)grants webConsentPayload:(NSString * _Nullable)webConsentPayload gcmStatus:(SPMCGDPRConsentGCMStatus * _Nullable)gcmStatus acceptedLegIntCategories:(NSArray<NSString *> * _Nullable)acceptedLegIntCategories acceptedLegIntVendors:(NSArray<NSString *> * _Nullable)acceptedLegIntVendors acceptedVendors:(NSArray<NSString *> * _Nullable)acceptedVendors acceptedCategories:(NSArray<NSString *> * _Nullable)acceptedCategories acceptedSpecialFeatures:(NSArray<NSString *> * _Nullable)acceptedSpecialFeatures __attribute__((swift_name("doCopy(uuid:dateCreated:expirationDate:tcData:euconsent:consentStatus:grants:webConsentPayload:gcmStatus:acceptedLegIntCategories:acceptedLegIntVendors:acceptedVendors:acceptedCategories:acceptedSpecialFeatures:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="categories")
*/
@property (readonly) NSArray<NSString *> * _Nullable acceptedCategories __attribute__((swift_name("acceptedCategories")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="legIntCategories")
*/
@property (readonly) NSArray<NSString *> * _Nullable acceptedLegIntCategories __attribute__((swift_name("acceptedLegIntCategories")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="legIntVendors")
*/
@property (readonly) NSArray<NSString *> * _Nullable acceptedLegIntVendors __attribute__((swift_name("acceptedLegIntVendors")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="specialFeatures")
*/
@property (readonly) NSArray<NSString *> * _Nullable acceptedSpecialFeatures __attribute__((swift_name("acceptedSpecialFeatures")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="vendors")
*/
@property (readonly) NSArray<NSString *> * _Nullable acceptedVendors __attribute__((swift_name("acceptedVendors")));
@property (readonly) SPMCConsentStatus * _Nullable consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) NSString * _Nullable euconsent __attribute__((swift_name("euconsent")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCGDPRConsentGCMStatus * _Nullable gcmStatus __attribute__((swift_name("gcmStatus")));
@property (readonly) NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> * _Nullable grants __attribute__((swift_name("grants")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="TCData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable tcData __attribute__((swift_name("tcData")));
@property (readonly) NSString *uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GDPRChoiceResponse.Companion")))
@interface SPMCGDPRChoiceResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGDPRChoiceResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GlobalCmpChoiceResponse")))
@interface SPMCGlobalCmpChoiceResponse : SPMCBase
- (instancetype)initWithUuid:(NSString * _Nullable)uuid consentStatus:(SPMCConsentStatus *)consentStatus dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled userConsents:(SPMCUserConsents *)userConsents webConsentPayload:(NSString * _Nullable)webConsentPayload __attribute__((swift_name("init(uuid:consentStatus:dateCreated:expirationDate:gpcEnabled:userConsents:webConsentPayload:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCGlobalCmpChoiceResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCGlobalCmpChoiceResponse *)doCopyUuid:(NSString * _Nullable)uuid consentStatus:(SPMCConsentStatus *)consentStatus dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled userConsents:(SPMCUserConsents *)userConsents webConsentPayload:(NSString * _Nullable)webConsentPayload __attribute__((swift_name("doCopy(uuid:consentStatus:dateCreated:expirationDate:gpcEnabled:userConsents:webConsentPayload:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCBoolean * _Nullable gpcEnabled __attribute__((swift_name("gpcEnabled")));
@property (readonly) SPMCUserConsents *userConsents __attribute__((swift_name("userConsents")));
@property (readonly) NSString * _Nullable uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("GlobalCmpChoiceResponse.Companion")))
@interface SPMCGlobalCmpChoiceResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCGlobalCmpChoiceResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessageWithCategorySubCategory")))
@interface SPMCMessageWithCategorySubCategory : SPMCBase
- (instancetype)initWithCategoryId:(SPMCMessagesResponseMessageMetaDataMessageCategory *)categoryId subCategoryId:(SPMCMessagesResponseMessageMetaDataMessageSubCategory *)subCategoryId categories:(NSArray<SPMCMessagesResponseMessageGDPRCategory *> * _Nullable)categories language:(SPMCSPMessageLanguage * _Nullable)language messageJson:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)messageJson messageChoices:(NSArray<NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *> *)messageChoices propertyId:(int32_t)propertyId __attribute__((swift_name("init(categoryId:subCategoryId:categories:language:messageJson:messageChoices:propertyId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessageWithCategorySubCategoryCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessageWithCategorySubCategory *)doCopyCategoryId:(SPMCMessagesResponseMessageMetaDataMessageCategory *)categoryId subCategoryId:(SPMCMessagesResponseMessageMetaDataMessageSubCategory *)subCategoryId categories:(NSArray<SPMCMessagesResponseMessageGDPRCategory *> * _Nullable)categories language:(SPMCSPMessageLanguage * _Nullable)language messageJson:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)messageJson messageChoices:(NSArray<NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *> *)messageChoices propertyId:(int32_t)propertyId __attribute__((swift_name("doCopy(categoryId:subCategoryId:categories:language:messageJson:messageChoices:propertyId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<SPMCMessagesResponseMessageGDPRCategory *> * _Nullable categories __attribute__((swift_name("categories")));
@property (readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *categoryId __attribute__((swift_name("categoryId")));
@property (readonly) SPMCSPMessageLanguage * _Nullable language __attribute__((swift_name("language")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="message_choice")
*/
@property (readonly) NSArray<NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *> *messageChoices __attribute__((swift_name("messageChoices")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="message_json")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *messageJson __attribute__((swift_name("messageJson")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="site_id")
*/
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@property (readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *subCategoryId __attribute__((swift_name("subCategoryId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessageWithCategorySubCategory.Companion")))
@interface SPMCMessageWithCategorySubCategoryCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessageWithCategorySubCategoryCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse")))
@interface SPMCMessagesResponse : SPMCBase
- (instancetype)initWithCampaigns:(NSArray<SPMCMessagesResponseCampaign<id> *> *)campaigns localState:(NSString *)localState nonKeyedLocalState:(NSString *)nonKeyedLocalState __attribute__((swift_name("init(campaigns:localState:nonKeyedLocalState:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponse *)doCopyCampaigns:(NSArray<SPMCMessagesResponseCampaign<id> *> *)campaigns localState:(NSString *)localState nonKeyedLocalState:(NSString *)nonKeyedLocalState __attribute__((swift_name("doCopy(campaigns:localState:nonKeyedLocalState:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<SPMCMessagesResponseCampaign<id> *> *campaigns __attribute__((swift_name("campaigns")));
@property (readonly) NSString *localState __attribute__((swift_name("localState")));
@property (readonly) NSString *nonKeyedLocalState __attribute__((swift_name("nonKeyedLocalState")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((swift_name("MessagesResponseCampaign")))
@interface SPMCMessagesResponseCampaign<ConsentClass> : SPMCBase
@property (class, readonly, getter=companion) SPMCMessagesResponseCampaignCompanion *companion __attribute__((swift_name("companion")));
- (ConsentClass _Nullable)toConsentDefault:(ConsentClass _Nullable)default_ __attribute__((swift_name("toConsent(default:)")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) ConsentClass _Nullable derivedConsents __attribute__((swift_name("derivedConsents")));
@property (readonly) SPMCMessagesResponseMessage * _Nullable message __attribute__((swift_name("message")));
@property (readonly) SPMCMessagesResponseMessageMetaData * _Nullable messageMetaData __attribute__((swift_name("messageMetaData")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@property (readonly) NSString * _Nullable url __attribute__((swift_name("url")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="CCPA")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.CCPA")))
@interface SPMCMessagesResponseCCPA : SPMCMessagesResponseCampaign<SPMCCCPAConsent *>
- (instancetype)initWithType:(SPMCSPCampaignType *)type status:(SPMCCCPAConsentCCPAConsentStatus * _Nullable)status signedLspa:(SPMCBoolean * _Nullable)signedLspa rejectedVendors:(NSArray<NSString *> * _Nullable)rejectedVendors rejectedCategories:(NSArray<NSString *> * _Nullable)rejectedCategories dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)gppData derivedConsents:(SPMCCCPAConsent * _Nullable)derivedConsents __attribute__((swift_name("init(type:status:signedLspa:rejectedVendors:rejectedCategories:dateCreated:expirationDate:webConsentPayload:gppData:derivedConsents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseCCPACompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseCCPA *)doCopyType:(SPMCSPCampaignType *)type status:(SPMCCCPAConsentCCPAConsentStatus * _Nullable)status signedLspa:(SPMCBoolean * _Nullable)signedLspa rejectedVendors:(NSArray<NSString *> * _Nullable)rejectedVendors rejectedCategories:(NSArray<NSString *> * _Nullable)rejectedCategories dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)gppData derivedConsents:(SPMCCCPAConsent * _Nullable)derivedConsents __attribute__((swift_name("doCopy(type:status:signedLspa:rejectedVendors:rejectedCategories:dateCreated:expirationDate:webConsentPayload:gppData:derivedConsents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCCCPAConsent * _Nullable)toConsentDefault:(SPMCCCPAConsent * _Nullable)default_ __attribute__((swift_name("toConsent(default:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCCCPAConsent * _Nullable derivedConsents __attribute__((swift_name("derivedConsents")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable gppData __attribute__((swift_name("gppData")));
@property (readonly) NSArray<NSString *> * _Nullable rejectedCategories __attribute__((swift_name("rejectedCategories")));
@property (readonly) NSArray<NSString *> * _Nullable rejectedVendors __attribute__((swift_name("rejectedVendors")));
@property (readonly) SPMCBoolean * _Nullable signedLspa __attribute__((swift_name("signedLspa")));
@property (readonly) SPMCCCPAConsentCCPAConsentStatus * _Nullable status __attribute__((swift_name("status")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.CCPACompanion")))
@interface SPMCMessagesResponseCCPACompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseCCPACompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponseCampaignCompanion")))
@interface SPMCMessagesResponseCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeSerial0:(id<SPMCKotlinx_serialization_coreKSerializer>)typeSerial0 __attribute__((swift_name("serializer(typeSerial0:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.Companion")))
@interface SPMCMessagesResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="GDPR")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.GDPR")))
@interface SPMCMessagesResponseGDPR : SPMCMessagesResponseCampaign<SPMCGDPRConsent *>
- (instancetype)initWithType:(SPMCSPCampaignType *)type euconsent:(NSString * _Nullable)euconsent grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> * _Nullable)grants consentStatus:(SPMCConsentStatus * _Nullable)consentStatus dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)tcData derivedConsents:(SPMCGDPRConsent * _Nullable)derivedConsents __attribute__((swift_name("init(type:euconsent:grants:consentStatus:dateCreated:expirationDate:webConsentPayload:tcData:derivedConsents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseGDPRCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseGDPR *)doCopyType:(SPMCSPCampaignType *)type euconsent:(NSString * _Nullable)euconsent grants:(NSDictionary<NSString *, SPMCGDPRConsentVendorGrantsValue *> * _Nullable)grants consentStatus:(SPMCConsentStatus * _Nullable)consentStatus dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload tcData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)tcData derivedConsents:(SPMCGDPRConsent * _Nullable)derivedConsents __attribute__((swift_name("doCopy(type:euconsent:grants:consentStatus:dateCreated:expirationDate:webConsentPayload:tcData:derivedConsents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCGDPRConsent * _Nullable)toConsentDefault:(SPMCGDPRConsent * _Nullable)default_ __attribute__((swift_name("toConsent(default:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCGDPRConsent * _Nullable derivedConsents __attribute__((swift_name("derivedConsents")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="TCData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable tcData __attribute__((swift_name("tcData")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.GDPRCompanion")))
@interface SPMCMessagesResponseGDPRCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseGDPRCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="globalcmp")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.GlobalCmp")))
@interface SPMCMessagesResponseGlobalCmp : SPMCMessagesResponseCampaign<SPMCGlobalCmpConsent *>
- (instancetype)initWithType:(SPMCSPCampaignType *)type consentStatus:(SPMCConsentStatus * _Nullable)consentStatus userConsents:(SPMCUserConsents * _Nullable)userConsents dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload derivedConsents:(SPMCGlobalCmpConsent * _Nullable)derivedConsents __attribute__((swift_name("init(type:consentStatus:userConsents:dateCreated:expirationDate:webConsentPayload:derivedConsents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseGlobalCmpCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseGlobalCmp *)doCopyType:(SPMCSPCampaignType *)type consentStatus:(SPMCConsentStatus * _Nullable)consentStatus userConsents:(SPMCUserConsents * _Nullable)userConsents dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload derivedConsents:(SPMCGlobalCmpConsent * _Nullable)derivedConsents __attribute__((swift_name("doCopy(type:consentStatus:userConsents:dateCreated:expirationDate:webConsentPayload:derivedConsents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCGlobalCmpConsent * _Nullable)toConsentDefault:(SPMCGlobalCmpConsent * _Nullable)default_ __attribute__((swift_name("toConsent(default:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCGlobalCmpConsent * _Nullable derivedConsents __attribute__((swift_name("derivedConsents")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.GlobalCmpCompanion")))
@interface SPMCMessagesResponseGlobalCmpCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseGlobalCmpCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="ios14")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.Ios14")))
@interface SPMCMessagesResponseIos14 : SPMCMessagesResponseCampaign<SPMCAttCampaign *>
- (instancetype)initWithType:(SPMCSPCampaignType *)type derivedConsents:(SPMCKotlinNothing * _Nullable)derivedConsents __attribute__((swift_name("init(type:derivedConsents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseIos14Companion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseIos14 *)doCopyType:(SPMCSPCampaignType *)type derivedConsents:(SPMCKotlinNothing * _Nullable)derivedConsents __attribute__((swift_name("doCopy(type:derivedConsents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCAttCampaign * _Nullable)toConsentDefault:(SPMCAttCampaign * _Nullable)default_ __attribute__((swift_name("toConsent(default:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinNothing * _Nullable derivedConsents __attribute__((swift_name("derivedConsents")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.Ios14Companion")))
@interface SPMCMessagesResponseIos14Companion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseIos14Companion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.Message")))
@interface SPMCMessagesResponseMessage : SPMCBase
- (instancetype)initWithCategories:(NSArray<SPMCMessagesResponseMessageGDPRCategory *> * _Nullable)categories language:(SPMCSPMessageLanguage * _Nullable)language messageJson:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)messageJson messageChoices:(NSArray<NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *> *)messageChoices propertyId:(int32_t)propertyId __attribute__((swift_name("init(categories:language:messageJson:messageChoices:propertyId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseMessage *)doCopyCategories:(NSArray<SPMCMessagesResponseMessageGDPRCategory *> * _Nullable)categories language:(SPMCSPMessageLanguage * _Nullable)language messageJson:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *)messageJson messageChoices:(NSArray<NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *> *)messageChoices propertyId:(int32_t)propertyId __attribute__((swift_name("doCopy(categories:language:messageJson:messageChoices:propertyId:)")));
- (NSString *)encodeToJsonCategoryId:(SPMCMessagesResponseMessageMetaDataMessageCategory *)categoryId subCategoryId:(SPMCMessagesResponseMessageMetaDataMessageSubCategory *)subCategoryId __attribute__((swift_name("encodeToJson(categoryId:subCategoryId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<SPMCMessagesResponseMessageGDPRCategory *> * _Nullable categories __attribute__((swift_name("categories")));
@property (readonly) SPMCSPMessageLanguage * _Nullable language __attribute__((swift_name("language")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="message_choice")
*/
@property (readonly) NSArray<NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *> *messageChoices __attribute__((swift_name("messageChoices")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="message_json")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> *messageJson __attribute__((swift_name("messageJson")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="site_id")
*/
@property (readonly) int32_t propertyId __attribute__((swift_name("propertyId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageCompanion")))
@interface SPMCMessagesResponseMessageCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategory")))
@interface SPMCMessagesResponseMessageGDPRCategory : SPMCBase
- (instancetype)initWithIabId:(SPMCInt * _Nullable)iabId id:(NSString *)id name:(NSString *)name description:(NSString *)description friendlyDescription:(NSString * _Nullable)friendlyDescription type:(SPMCMessagesResponseMessageGDPRCategoryCategoryType * _Nullable)type disclosureOnly:(SPMCBoolean * _Nullable)disclosureOnly requireConsent:(SPMCBoolean * _Nullable)requireConsent legIntVendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)legIntVendors requiringConsentVendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)requiringConsentVendors disclosureOnlyVendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)disclosureOnlyVendors vendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)vendors __attribute__((swift_name("init(iabId:id:name:description:friendlyDescription:type:disclosureOnly:requireConsent:legIntVendors:requiringConsentVendors:disclosureOnlyVendors:vendors:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageGDPRCategoryCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseMessageGDPRCategory *)doCopyIabId:(SPMCInt * _Nullable)iabId id:(NSString *)id name:(NSString *)name description:(NSString *)description friendlyDescription:(NSString * _Nullable)friendlyDescription type:(SPMCMessagesResponseMessageGDPRCategoryCategoryType * _Nullable)type disclosureOnly:(SPMCBoolean * _Nullable)disclosureOnly requireConsent:(SPMCBoolean * _Nullable)requireConsent legIntVendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)legIntVendors requiringConsentVendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)requiringConsentVendors disclosureOnlyVendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)disclosureOnlyVendors vendors:(NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable)vendors __attribute__((swift_name("doCopy(iabId:id:name:description:friendlyDescription:type:disclosureOnly:requireConsent:legIntVendors:requiringConsentVendors:disclosureOnlyVendors:vendors:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *description_ __attribute__((swift_name("description_")));
@property (readonly) SPMCBoolean * _Nullable disclosureOnly __attribute__((swift_name("disclosureOnly")));
@property (readonly) NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable disclosureOnlyVendors __attribute__((swift_name("disclosureOnlyVendors")));
@property (readonly) NSString * _Nullable friendlyDescription __attribute__((swift_name("friendlyDescription")));
@property (readonly) SPMCInt * _Nullable iabId __attribute__((swift_name("iabId")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="_id")
*/
@property (readonly) NSString *id __attribute__((swift_name("id")));
@property (readonly) NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable legIntVendors __attribute__((swift_name("legIntVendors")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) SPMCBoolean * _Nullable requireConsent __attribute__((swift_name("requireConsent")));
@property (readonly) NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable requiringConsentVendors __attribute__((swift_name("requiringConsentVendors")));
@property (readonly) SPMCMessagesResponseMessageGDPRCategoryCategoryType * _Nullable type __attribute__((swift_name("type")));
@property (readonly) NSArray<SPMCMessagesResponseMessageGDPRCategoryVendor *> * _Nullable vendors __attribute__((swift_name("vendors")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=com/sourcepoint/mobile_core/network/responses/MessagesResponse.Message.GDPRCategory.CategoryType.Serializer))
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryCategoryType")))
@interface SPMCMessagesResponseMessageGDPRCategoryCategoryType : SPMCKotlinEnum<SPMCMessagesResponseMessageGDPRCategoryCategoryType *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageGDPRCategoryCategoryTypeCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCMessagesResponseMessageGDPRCategoryCategoryType *iabPurpose __attribute__((swift_name("iabPurpose")));
@property (class, readonly) SPMCMessagesResponseMessageGDPRCategoryCategoryType *iab __attribute__((swift_name("iab")));
@property (class, readonly) SPMCMessagesResponseMessageGDPRCategoryCategoryType *unknown __attribute__((swift_name("unknown")));
@property (class, readonly) SPMCMessagesResponseMessageGDPRCategoryCategoryType *custom __attribute__((swift_name("custom")));
+ (SPMCKotlinArray<SPMCMessagesResponseMessageGDPRCategoryCategoryType *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCMessagesResponseMessageGDPRCategoryCategoryType *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryCategoryTypeCompanion")))
@interface SPMCMessagesResponseMessageGDPRCategoryCategoryTypeCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageGDPRCategoryCategoryTypeCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end

__attribute__((swift_name("StringEnumWithDefaultSerializer")))
@interface SPMCStringEnumWithDefaultSerializer<T> : SPMCBase <SPMCKotlinx_serialization_coreKSerializer>
- (instancetype)initWithValues:(NSArray<T> *)values default:(T)default_ __attribute__((swift_name("init(values:default:)"))) __attribute__((objc_designated_initializer));
- (T)deserializeDecoder:(id<SPMCKotlinx_serialization_coreDecoder>)decoder __attribute__((swift_name("deserialize(decoder:)")));
- (void)serializeEncoder:(id<SPMCKotlinx_serialization_coreEncoder>)encoder value:(T)value __attribute__((swift_name("serialize(encoder:value:)")));
@property (readonly) id<SPMCKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryCategoryTypeSerializer")))
@interface SPMCMessagesResponseMessageGDPRCategoryCategoryTypeSerializer : SPMCStringEnumWithDefaultSerializer<SPMCMessagesResponseMessageGDPRCategoryCategoryType *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithValues:(NSArray<SPMCKotlinEnum *> *)values default:(SPMCKotlinEnum *)default_ __attribute__((swift_name("init(values:default:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)serializer __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageGDPRCategoryCategoryTypeSerializer *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryCompanion")))
@interface SPMCMessagesResponseMessageGDPRCategoryCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageGDPRCategoryCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryVendor")))
@interface SPMCMessagesResponseMessageGDPRCategoryVendor : SPMCBase
- (instancetype)initWithName:(NSString *)name vendorId:(NSString * _Nullable)vendorId policyUrl:(NSString * _Nullable)policyUrl vendorType:(SPMCMessagesResponseMessageGDPRCategoryVendorVendorType * _Nullable)vendorType __attribute__((swift_name("init(name:vendorId:policyUrl:vendorType:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageGDPRCategoryVendorCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseMessageGDPRCategoryVendor *)doCopyName:(NSString *)name vendorId:(NSString * _Nullable)vendorId policyUrl:(NSString * _Nullable)policyUrl vendorType:(SPMCMessagesResponseMessageGDPRCategoryVendorVendorType * _Nullable)vendorType __attribute__((swift_name("doCopy(name:vendorId:policyUrl:vendorType:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) NSString * _Nullable policyUrl __attribute__((swift_name("policyUrl")));
@property (readonly) NSString * _Nullable vendorId __attribute__((swift_name("vendorId")));
@property (readonly) SPMCMessagesResponseMessageGDPRCategoryVendorVendorType * _Nullable vendorType __attribute__((swift_name("vendorType")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryVendorCompanion")))
@interface SPMCMessagesResponseMessageGDPRCategoryVendorCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageGDPRCategoryVendorCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=com/sourcepoint/mobile_core/network/responses/MessagesResponse.Message.GDPRCategory.Vendor.VendorType.Serializer))
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryVendorVendorType")))
@interface SPMCMessagesResponseMessageGDPRCategoryVendorVendorType : SPMCKotlinEnum<SPMCMessagesResponseMessageGDPRCategoryVendorVendorType *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageGDPRCategoryVendorVendorTypeCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCMessagesResponseMessageGDPRCategoryVendorVendorType *iab __attribute__((swift_name("iab")));
@property (class, readonly) SPMCMessagesResponseMessageGDPRCategoryVendorVendorType *custom __attribute__((swift_name("custom")));
@property (class, readonly) SPMCMessagesResponseMessageGDPRCategoryVendorVendorType *unknown __attribute__((swift_name("unknown")));
+ (SPMCKotlinArray<SPMCMessagesResponseMessageGDPRCategoryVendorVendorType *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCMessagesResponseMessageGDPRCategoryVendorVendorType *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryVendorVendorTypeCompanion")))
@interface SPMCMessagesResponseMessageGDPRCategoryVendorVendorTypeCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageGDPRCategoryVendorVendorTypeCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageGDPRCategoryVendorVendorTypeSerializer")))
@interface SPMCMessagesResponseMessageGDPRCategoryVendorVendorTypeSerializer : SPMCStringEnumWithDefaultSerializer<SPMCMessagesResponseMessageGDPRCategoryVendorVendorType *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithValues:(NSArray<SPMCKotlinEnum *> *)values default:(SPMCKotlinEnum *)default_ __attribute__((swift_name("init(values:default:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)serializer __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageGDPRCategoryVendorVendorTypeSerializer *shared __attribute__((swift_name("shared")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaData")))
@interface SPMCMessagesResponseMessageMetaData : SPMCBase
- (instancetype)initWithCategoryId:(SPMCMessagesResponseMessageMetaDataMessageCategory *)categoryId subCategoryId:(SPMCMessagesResponseMessageMetaDataMessageSubCategory *)subCategoryId messageId:(int32_t)messageId messagePartitionUUID:(NSString * _Nullable)messagePartitionUUID __attribute__((swift_name("init(categoryId:subCategoryId:messageId:messagePartitionUUID:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageMetaDataCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseMessageMetaData *)doCopyCategoryId:(SPMCMessagesResponseMessageMetaDataMessageCategory *)categoryId subCategoryId:(SPMCMessagesResponseMessageMetaDataMessageSubCategory *)subCategoryId messageId:(int32_t)messageId messagePartitionUUID:(NSString * _Nullable)messagePartitionUUID __attribute__((swift_name("doCopy(categoryId:subCategoryId:messageId:messagePartitionUUID:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *categoryId __attribute__((swift_name("categoryId")));
@property (readonly) int32_t messageId __attribute__((swift_name("messageId")));
@property (readonly) NSString * _Nullable messagePartitionUUID __attribute__((swift_name("messagePartitionUUID")));
@property (readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *subCategoryId __attribute__((swift_name("subCategoryId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaDataCompanion")))
@interface SPMCMessagesResponseMessageMetaDataCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageMetaDataCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((swift_name("IntEnum")))
@protocol SPMCIntEnum
@required
@property (readonly) int32_t rawValue_ __attribute__((swift_name("rawValue_")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=com/sourcepoint/mobile_core/network/responses/MessagesResponse.MessageMetaData.MessageCategory.Serializer))
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaDataMessageCategory")))
@interface SPMCMessagesResponseMessageMetaDataMessageCategory : SPMCKotlinEnum<SPMCMessagesResponseMessageMetaDataMessageCategory *> <SPMCIntEnum>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageMetaDataMessageCategoryCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *gdpr __attribute__((swift_name("gdpr")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *ccpa __attribute__((swift_name("ccpa")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *adblock __attribute__((swift_name("adblock")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *ios14 __attribute__((swift_name("ios14")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *custom __attribute__((swift_name("custom")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *usnat __attribute__((swift_name("usnat")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *preferences __attribute__((swift_name("preferences")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageCategory *unknown __attribute__((swift_name("unknown")));
+ (SPMCKotlinArray<SPMCMessagesResponseMessageMetaDataMessageCategory *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCMessagesResponseMessageMetaDataMessageCategory *> *entries __attribute__((swift_name("entries")));
@property (readonly) int32_t rawValue_ __attribute__((swift_name("rawValue_")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaDataMessageCategoryCompanion")))
@interface SPMCMessagesResponseMessageMetaDataMessageCategoryCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageMetaDataMessageCategoryCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end

__attribute__((swift_name("IntEnumSerializer")))
@interface SPMCIntEnumSerializer<T> : SPMCBase <SPMCKotlinx_serialization_coreKSerializer>
- (instancetype)initWithValues:(NSArray<T> *)values default:(T _Nullable)default_ __attribute__((swift_name("init(values:default:)"))) __attribute__((objc_designated_initializer));
- (T)deserializeDecoder:(id<SPMCKotlinx_serialization_coreDecoder>)decoder __attribute__((swift_name("deserialize(decoder:)")));
- (void)serializeEncoder:(id<SPMCKotlinx_serialization_coreEncoder>)encoder value:(T)value __attribute__((swift_name("serialize(encoder:value:)")));
@property (readonly) id<SPMCKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaDataMessageCategorySerializer")))
@interface SPMCMessagesResponseMessageMetaDataMessageCategorySerializer : SPMCIntEnumSerializer<SPMCMessagesResponseMessageMetaDataMessageCategory *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithValues:(NSArray<SPMCKotlinEnum *> *)values default:(SPMCKotlinEnum * _Nullable)default_ __attribute__((swift_name("init(values:default:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)serializer __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageMetaDataMessageCategorySerializer *shared __attribute__((swift_name("shared")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=com/sourcepoint/mobile_core/network/responses/MessagesResponse.MessageMetaData.MessageSubCategory.Serializer))
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaDataMessageSubCategory")))
@interface SPMCMessagesResponseMessageMetaDataMessageSubCategory : SPMCKotlinEnum<SPMCMessagesResponseMessageMetaDataMessageSubCategory *> <SPMCIntEnum>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCMessagesResponseMessageMetaDataMessageSubCategoryCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *notice __attribute__((swift_name("notice")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *privacymanager __attribute__((swift_name("privacymanager")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *subjectaccessrequest __attribute__((swift_name("subjectaccessrequest")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *dsar __attribute__((swift_name("dsar")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *noticetcfv2 __attribute__((swift_name("noticetcfv2")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *noticenative __attribute__((swift_name("noticenative")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *privacymanagerott __attribute__((swift_name("privacymanagerott")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *noticenoniab __attribute__((swift_name("noticenoniab")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *privacymanagernoniab __attribute__((swift_name("privacymanagernoniab")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *ios __attribute__((swift_name("ios")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *ccpaott __attribute__((swift_name("ccpaott")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *privacymanagerccpa __attribute__((swift_name("privacymanagerccpa")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *custom __attribute__((swift_name("custom")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *nativeott __attribute__((swift_name("nativeott")));
@property (class, readonly) SPMCMessagesResponseMessageMetaDataMessageSubCategory *unknown __attribute__((swift_name("unknown")));
+ (SPMCKotlinArray<SPMCMessagesResponseMessageMetaDataMessageSubCategory *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCMessagesResponseMessageMetaDataMessageSubCategory *> *entries __attribute__((swift_name("entries")));
@property (readonly) int32_t rawValue_ __attribute__((swift_name("rawValue_")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaDataMessageSubCategoryCompanion")))
@interface SPMCMessagesResponseMessageMetaDataMessageSubCategoryCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageMetaDataMessageSubCategoryCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(SPMCKotlinArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.MessageMetaDataMessageSubCategorySerializer")))
@interface SPMCMessagesResponseMessageMetaDataMessageSubCategorySerializer : SPMCIntEnumSerializer<SPMCMessagesResponseMessageMetaDataMessageSubCategory *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithValues:(NSArray<SPMCKotlinEnum *> *)values default:(SPMCKotlinEnum * _Nullable)default_ __attribute__((swift_name("init(values:default:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)serializer __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseMessageMetaDataMessageSubCategorySerializer *shared __attribute__((swift_name("shared")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="preferences")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.Preferences")))
@interface SPMCMessagesResponsePreferences : SPMCMessagesResponseCampaign<SPMCPreferencesConsent *>
- (instancetype)initWithType:(SPMCSPCampaignType *)type derivedConsents:(SPMCKotlinNothing * _Nullable)derivedConsents __attribute__((swift_name("init(type:derivedConsents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponsePreferencesCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponsePreferences *)doCopyType:(SPMCSPCampaignType *)type derivedConsents:(SPMCKotlinNothing * _Nullable)derivedConsents __attribute__((swift_name("doCopy(type:derivedConsents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCPreferencesConsent * _Nullable)toConsentDefault:(SPMCPreferencesConsent * _Nullable)default_ __attribute__((swift_name("toConsent(default:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinNothing * _Nullable derivedConsents __attribute__((swift_name("derivedConsents")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.PreferencesCompanion")))
@interface SPMCMessagesResponsePreferencesCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponsePreferencesCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="usnat")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.USNat")))
@interface SPMCMessagesResponseUSNat : SPMCMessagesResponseCampaign<SPMCUSNatConsent *>
- (instancetype)initWithType:(SPMCSPCampaignType *)type consentStatus:(SPMCConsentStatus * _Nullable)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> * _Nullable)consentStrings userConsents:(SPMCUserConsents * _Nullable)userConsents dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)gppData derivedConsents:(SPMCUSNatConsent * _Nullable)derivedConsents __attribute__((swift_name("init(type:consentStatus:consentStrings:userConsents:dateCreated:expirationDate:webConsentPayload:gppData:derivedConsents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMessagesResponseUSNatCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMessagesResponseUSNat *)doCopyType:(SPMCSPCampaignType *)type consentStatus:(SPMCConsentStatus * _Nullable)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> * _Nullable)consentStrings userConsents:(SPMCUserConsents * _Nullable)userConsents dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable)gppData derivedConsents:(SPMCUSNatConsent * _Nullable)derivedConsents __attribute__((swift_name("doCopy(type:consentStatus:consentStrings:userConsents:dateCreated:expirationDate:webConsentPayload:gppData:derivedConsents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCUSNatConsent * _Nullable)toConsentDefault:(SPMCUSNatConsent * _Nullable)default_ __attribute__((swift_name("toConsent(default:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCUSNatConsent * _Nullable derivedConsents __attribute__((swift_name("derivedConsents")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> * _Nullable gppData __attribute__((swift_name("gppData")));
@property (readonly) SPMCSPCampaignType *type __attribute__((swift_name("type")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MessagesResponse.USNatCompanion")))
@interface SPMCMessagesResponseUSNatCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMessagesResponseUSNatCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse")))
@interface SPMCMetaDataResponse : SPMCBase
- (instancetype)initWithGdpr:(SPMCMetaDataResponseMetaDataResponseGDPR * _Nullable)gdpr globalcmp:(SPMCMetaDataResponseMetaDataResponseGlobalCmp * _Nullable)globalcmp usnat:(SPMCMetaDataResponseMetaDataResponseUSNat * _Nullable)usnat ccpa:(SPMCMetaDataResponseMetaDataResponseCCPA * _Nullable)ccpa preferences:(SPMCMetaDataResponseMetaDataResponsePreferences * _Nullable)preferences __attribute__((swift_name("init(gdpr:globalcmp:usnat:ccpa:preferences:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataResponse *)doCopyGdpr:(SPMCMetaDataResponseMetaDataResponseGDPR * _Nullable)gdpr globalcmp:(SPMCMetaDataResponseMetaDataResponseGlobalCmp * _Nullable)globalcmp usnat:(SPMCMetaDataResponseMetaDataResponseUSNat * _Nullable)usnat ccpa:(SPMCMetaDataResponseMetaDataResponseCCPA * _Nullable)ccpa preferences:(SPMCMetaDataResponseMetaDataResponsePreferences * _Nullable)preferences __attribute__((swift_name("doCopy(gdpr:globalcmp:usnat:ccpa:preferences:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCMetaDataResponseMetaDataResponseCCPA * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCMetaDataResponseMetaDataResponseGDPR * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCMetaDataResponseMetaDataResponseGlobalCmp * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCMetaDataResponseMetaDataResponsePreferences * _Nullable preferences __attribute__((swift_name("preferences")));
@property (readonly) SPMCMetaDataResponseMetaDataResponseUSNat * _Nullable usnat __attribute__((swift_name("usnat")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.Companion")))
@interface SPMCMetaDataResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseCCPA")))
@interface SPMCMetaDataResponseMetaDataResponseCCPA : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies sampleRate:(float)sampleRate __attribute__((swift_name("init(applies:sampleRate:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataResponseMetaDataResponseCCPACompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataResponseMetaDataResponseCCPA *)doCopyApplies:(BOOL)applies sampleRate:(float)sampleRate __attribute__((swift_name("doCopy(applies:sampleRate:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseCCPACompanion")))
@interface SPMCMetaDataResponseMetaDataResponseCCPACompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataResponseMetaDataResponseCCPACompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseGDPR")))
@interface SPMCMetaDataResponseMetaDataResponseGDPR : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies sampleRate:(float)sampleRate additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate legalBasisChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)legalBasisChangeDate childPmId:(NSString * _Nullable)childPmId vendorListId:(NSString *)vendorListId __attribute__((swift_name("init(applies:sampleRate:additionsChangeDate:legalBasisChangeDate:childPmId:vendorListId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataResponseMetaDataResponseGDPRCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataResponseMetaDataResponseGDPR *)doCopyApplies:(BOOL)applies sampleRate:(float)sampleRate additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate legalBasisChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)legalBasisChangeDate childPmId:(NSString * _Nullable)childPmId vendorListId:(NSString *)vendorListId __attribute__((swift_name("doCopy(applies:sampleRate:additionsChangeDate:legalBasisChangeDate:childPmId:vendorListId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable legalBasisChangeDate __attribute__((swift_name("legalBasisChangeDate")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="_id")
*/
@property (readonly) NSString *vendorListId __attribute__((swift_name("vendorListId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseGDPRCompanion")))
@interface SPMCMetaDataResponseMetaDataResponseGDPRCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataResponseMetaDataResponseGDPRCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseGlobalCmp")))
@interface SPMCMetaDataResponseMetaDataResponseGlobalCmp : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies sampleRate:(float)sampleRate additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate applicableSections:(NSArray<NSString *> * _Nullable)applicableSections legislation:(NSString * _Nullable)legislation childPmId:(NSString * _Nullable)childPmId vendorListId:(NSString *)vendorListId __attribute__((swift_name("init(applies:sampleRate:additionsChangeDate:applicableSections:legislation:childPmId:vendorListId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataResponseMetaDataResponseGlobalCmpCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataResponseMetaDataResponseGlobalCmp *)doCopyApplies:(BOOL)applies sampleRate:(float)sampleRate additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate applicableSections:(NSArray<NSString *> * _Nullable)applicableSections legislation:(NSString * _Nullable)legislation childPmId:(NSString * _Nullable)childPmId vendorListId:(NSString *)vendorListId __attribute__((swift_name("doCopy(applies:sampleRate:additionsChangeDate:applicableSections:legislation:childPmId:vendorListId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) NSArray<NSString *> * _Nullable applicableSections __attribute__((swift_name("applicableSections")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) NSString * _Nullable childPmId __attribute__((swift_name("childPmId")));
@property (readonly) NSString * _Nullable legislation __attribute__((swift_name("legislation")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="_id")
*/
@property (readonly) NSString *vendorListId __attribute__((swift_name("vendorListId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseGlobalCmpCompanion")))
@interface SPMCMetaDataResponseMetaDataResponseGlobalCmpCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataResponseMetaDataResponseGlobalCmpCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponsePreferences")))
@interface SPMCMetaDataResponseMetaDataResponsePreferences : SPMCBase
- (instancetype)initWithConfigurationId:(NSString *)configurationId additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate legalDocLiveDate:(NSDictionary<SPMCPreferencesConsentPreferencesSubType *, SPMCKotlinx_datetimeInstant *> * _Nullable)legalDocLiveDate __attribute__((swift_name("init(configurationId:additionsChangeDate:legalDocLiveDate:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataResponseMetaDataResponsePreferencesCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataResponseMetaDataResponsePreferences *)doCopyConfigurationId:(NSString *)configurationId additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate legalDocLiveDate:(NSDictionary<SPMCPreferencesConsentPreferencesSubType *, SPMCKotlinx_datetimeInstant *> * _Nullable)legalDocLiveDate __attribute__((swift_name("doCopy(configurationId:additionsChangeDate:legalDocLiveDate:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) NSString *configurationId __attribute__((swift_name("configurationId")));
@property (readonly) NSDictionary<SPMCPreferencesConsentPreferencesSubType *, SPMCKotlinx_datetimeInstant *> * _Nullable legalDocLiveDate __attribute__((swift_name("legalDocLiveDate")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponsePreferencesCompanion")))
@interface SPMCMetaDataResponseMetaDataResponsePreferencesCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataResponseMetaDataResponsePreferencesCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseUSNat")))
@interface SPMCMetaDataResponseMetaDataResponseUSNat : SPMCBase
- (instancetype)initWithApplies:(BOOL)applies sampleRate:(float)sampleRate additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate applicableSections:(NSArray<SPMCInt *> *)applicableSections vendorListId:(NSString *)vendorListId __attribute__((swift_name("init(applies:sampleRate:additionsChangeDate:applicableSections:vendorListId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCMetaDataResponseMetaDataResponseUSNatCompanion *companion __attribute__((swift_name("companion")));
- (SPMCMetaDataResponseMetaDataResponseUSNat *)doCopyApplies:(BOOL)applies sampleRate:(float)sampleRate additionsChangeDate:(SPMCKotlinx_datetimeInstant * _Nullable)additionsChangeDate applicableSections:(NSArray<SPMCInt *> *)applicableSections vendorListId:(NSString *)vendorListId __attribute__((swift_name("doCopy(applies:sampleRate:additionsChangeDate:applicableSections:vendorListId:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable additionsChangeDate __attribute__((swift_name("additionsChangeDate")));
@property (readonly) NSArray<SPMCInt *> *applicableSections __attribute__((swift_name("applicableSections")));
@property (readonly) BOOL applies __attribute__((swift_name("applies")));
@property (readonly) float sampleRate __attribute__((swift_name("sampleRate")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="_id")
*/
@property (readonly) NSString *vendorListId __attribute__((swift_name("vendorListId")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MetaDataResponse.MetaDataResponseUSNatCompanion")))
@interface SPMCMetaDataResponseMetaDataResponseUSNatCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCMetaDataResponseMetaDataResponseUSNatCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesChoiceResponse")))
@interface SPMCPreferencesChoiceResponse : SPMCBase
- (instancetype)initWithUuid:(NSString *)uuid configurationId:(NSString * _Nullable)configurationId dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated status:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)status rejectedStatus:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)rejectedStatus __attribute__((swift_name("init(uuid:configurationId:dateCreated:status:rejectedStatus:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPreferencesChoiceResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPreferencesChoiceResponse *)doCopyUuid:(NSString *)uuid configurationId:(NSString * _Nullable)configurationId dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated status:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)status rejectedStatus:(NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable)rejectedStatus __attribute__((swift_name("doCopy(uuid:configurationId:dateCreated:status:rejectedStatus:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable configurationId __attribute__((swift_name("configurationId")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable rejectedStatus __attribute__((swift_name("rejectedStatus")));
@property (readonly) NSArray<SPMCPreferencesConsentPreferencesStatus *> * _Nullable status __attribute__((swift_name("status")));
@property (readonly) NSString *uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PreferencesChoiceResponse.Companion")))
@interface SPMCPreferencesChoiceResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPreferencesChoiceResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataResponse")))
@interface SPMCPvDataResponse : SPMCBase
- (instancetype)initWithGdpr:(SPMCPvDataResponseCampaign * _Nullable)gdpr ccpa:(SPMCPvDataResponseCampaign * _Nullable)ccpa usnat:(SPMCPvDataResponseCampaign * _Nullable)usnat globalcmp:(SPMCPvDataResponseCampaign * _Nullable)globalcmp __attribute__((swift_name("init(gdpr:ccpa:usnat:globalcmp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPvDataResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPvDataResponse *)doCopyGdpr:(SPMCPvDataResponseCampaign * _Nullable)gdpr ccpa:(SPMCPvDataResponseCampaign * _Nullable)ccpa usnat:(SPMCPvDataResponseCampaign * _Nullable)usnat globalcmp:(SPMCPvDataResponseCampaign * _Nullable)globalcmp __attribute__((swift_name("doCopy(gdpr:ccpa:usnat:globalcmp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCPvDataResponseCampaign * _Nullable ccpa __attribute__((swift_name("ccpa")));
@property (readonly) SPMCPvDataResponseCampaign * _Nullable gdpr __attribute__((swift_name("gdpr")));
@property (readonly) SPMCPvDataResponseCampaign * _Nullable globalcmp __attribute__((swift_name("globalcmp")));
@property (readonly) SPMCPvDataResponseCampaign * _Nullable usnat __attribute__((swift_name("usnat")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataResponse.Campaign")))
@interface SPMCPvDataResponseCampaign : SPMCBase
- (instancetype)initWithUuid:(NSString *)uuid __attribute__((swift_name("init(uuid:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCPvDataResponseCampaignCompanion *companion __attribute__((swift_name("companion")));
- (SPMCPvDataResponseCampaign *)doCopyUuid:(NSString *)uuid __attribute__((swift_name("doCopy(uuid:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *uuid __attribute__((swift_name("uuid")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataResponse.CampaignCompanion")))
@interface SPMCPvDataResponseCampaignCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPvDataResponseCampaignCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PvDataResponse.Companion")))
@interface SPMCPvDataResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCPvDataResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatChoiceResponse")))
@interface SPMCUSNatChoiceResponse : SPMCBase
- (instancetype)initWithUuid:(NSString *)uuid consentStatus:(SPMCConsentStatus *)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> *)consentStrings dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData userConsents:(SPMCUserConsents *)userConsents __attribute__((swift_name("init(uuid:consentStatus:consentStrings:dateCreated:expirationDate:gpcEnabled:webConsentPayload:gppData:userConsents:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCUSNatChoiceResponseCompanion *companion __attribute__((swift_name("companion")));
- (SPMCUSNatChoiceResponse *)doCopyUuid:(NSString *)uuid consentStatus:(SPMCConsentStatus *)consentStatus consentStrings:(NSArray<SPMCUSNatConsentUSNatConsentSection *> *)consentStrings dateCreated:(SPMCKotlinx_datetimeInstant * _Nullable)dateCreated expirationDate:(SPMCKotlinx_datetimeInstant * _Nullable)expirationDate gpcEnabled:(SPMCBoolean * _Nullable)gpcEnabled webConsentPayload:(NSString * _Nullable)webConsentPayload gppData:(NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *)gppData userConsents:(SPMCUserConsents *)userConsents __attribute__((swift_name("doCopy(uuid:consentStatus:consentStrings:dateCreated:expirationDate:gpcEnabled:webConsentPayload:gppData:userConsents:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCConsentStatus *consentStatus __attribute__((swift_name("consentStatus")));
@property (readonly) NSArray<SPMCUSNatConsentUSNatConsentSection *> *consentStrings __attribute__((swift_name("consentStrings")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable dateCreated __attribute__((swift_name("dateCreated")));
@property (readonly) SPMCKotlinx_datetimeInstant * _Nullable expirationDate __attribute__((swift_name("expirationDate")));
@property (readonly) SPMCBoolean * _Nullable gpcEnabled __attribute__((swift_name("gpcEnabled")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="GPPData")
*/
@property (readonly) NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *gppData __attribute__((swift_name("gppData")));
@property (readonly) SPMCUserConsents *userConsents __attribute__((swift_name("userConsents")));
@property (readonly) NSString *uuid __attribute__((swift_name("uuid")));
@property (readonly) NSString * _Nullable webConsentPayload __attribute__((swift_name("webConsentPayload")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("USNatChoiceResponse.Companion")))
@interface SPMCUSNatChoiceResponseCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCUSNatChoiceResponseCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Repository")))
@interface SPMCRepository : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithStorage:(id<SPMCMultiplatform_settingsSettings>)storage __attribute__((swift_name("init(storage:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCRepositoryCompanion *companion __attribute__((swift_name("companion")));
- (void)clear __attribute__((swift_name("clear()")));
@property NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *gppData __attribute__((swift_name("gppData")));
@property SPMCState * _Nullable state __attribute__((swift_name("state")));
@property NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonPrimitive *> *tcData __attribute__((swift_name("tcData")));
@property NSString * _Nullable uspString __attribute__((swift_name("uspString")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Repository.Companion")))
@interface SPMCRepositoryCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCRepositoryCompanion *shared __attribute__((swift_name("shared")));
@property (readonly) NSString *GPP_PREFIX __attribute__((swift_name("GPP_PREFIX")));
@property (readonly) NSString *SP_STATE_KEY __attribute__((swift_name("SP_STATE_KEY")));
@property (readonly) NSString *TCF_PREFIX __attribute__((swift_name("TCF_PREFIX")));
@property (readonly) NSString *USPSTRING_KEY __attribute__((swift_name("USPSTRING_KEY")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=kotlinx/datetime/serializers/InstantIso8601Serializer))
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_datetimeInstant")))
@interface SPMCKotlinx_datetimeInstant : SPMCBase <SPMCKotlinComparable>
@property (class, readonly, getter=companion) SPMCKotlinx_datetimeInstantCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(SPMCKotlinx_datetimeInstant *)other __attribute__((swift_name("compareTo(other:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (SPMCKotlinx_datetimeInstant *)minusDuration:(int64_t)duration __attribute__((swift_name("minus(duration:)")));
- (int64_t)minusOther:(SPMCKotlinx_datetimeInstant *)other __attribute__((swift_name("minus(other:)")));
- (SPMCKotlinx_datetimeInstant *)plusDuration:(int64_t)duration __attribute__((swift_name("plus(duration:)")));
- (int64_t)toEpochMilliseconds __attribute__((swift_name("toEpochMilliseconds()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int64_t epochSeconds __attribute__((swift_name("epochSeconds")));
@property (readonly) int32_t nanosecondsOfSecond __attribute__((swift_name("nanosecondsOfSecond")));
@end

@interface SPMCKotlinx_datetimeInstant (Extensions)
- (SPMCKotlinx_datetimeInstant *)inOneYear __attribute__((swift_name("inOneYear()")));
- (NSString *)instantToString __attribute__((swift_name("instantToString()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("InstantKt")))
@interface SPMCInstantKt : SPMCBase
+ (SPMCKotlinx_datetimeInstant *)now __attribute__((swift_name("now()")));
+ (SPMCKotlinx_datetimeInstant *)toInstant:(NSString *)receiver __attribute__((swift_name("toInstant(_:)")));
+ (SPMCKotlinx_datetimeInstant *)yesterday __attribute__((swift_name("yesterday()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("JsonKt")))
@interface SPMCJsonKt : SPMCBase
+ (NSDictionary<NSString *, SPMCKotlinx_serialization_jsonJsonElement *> * _Nullable)encodeToJsonObject:(NSString * _Nullable)receiver __attribute__((swift_name("encodeToJsonObject(_:)")));
+ (SPMCKotlinx_serialization_jsonJsonPrimitive *)toJsonPrimitive:(id _Nullable)receiver __attribute__((swift_name("toJsonPrimitive(_:)")));
@property (class, readonly) SPMCKotlinx_serialization_jsonJson *json __attribute__((swift_name("json")));
@property (class, readonly) SPMCKotlinx_serialization_jsonJson *jsonWithNulls __attribute__((swift_name("jsonWithNulls")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PlatformStorage_appleKt")))
@interface SPMCPlatformStorage_appleKt : SPMCBase
+ (id<SPMCMultiplatform_settingsSettings>)getStorage __attribute__((swift_name("getStorage()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PlatformStorageKt")))
@interface SPMCPlatformStorageKt : SPMCBase
+ (id<SPMCMultiplatform_settingsSettings>)getStorageOrDefault __attribute__((swift_name("getStorageOrDefault()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TargetingParamsPreferencesKt")))
@interface SPMCTargetingParamsPreferencesKt : SPMCBase
+ (NSDictionary<NSString *, NSString *> *)preferencesTargetingParamsPreferencesState:(SPMCStatePreferencesState *)preferencesState __attribute__((swift_name("preferencesTargetingParams(preferencesState:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("WrapClientTimeoutErrorKt")))
@interface SPMCWrapClientTimeoutErrorKt : SPMCBase
@property (class, readonly) id<SPMCKtor_client_coreClientPlugin> WrapHttpTimeoutError __attribute__((swift_name("WrapHttpTimeoutError")));
@end

__attribute__((swift_name("KotlinRuntimeException")))
@interface SPMCKotlinRuntimeException : SPMCKotlinException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end

__attribute__((swift_name("KotlinIllegalStateException")))
@interface SPMCKotlinIllegalStateException : SPMCKotlinRuntimeException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.4")
*/
__attribute__((swift_name("KotlinCancellationException")))
@interface SPMCKotlinCancellationException : SPMCKotlinIllegalStateException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=kotlinx/serialization/json/JsonElementSerializer))
*/
__attribute__((swift_name("Kotlinx_serialization_jsonJsonElement")))
@interface SPMCKotlinx_serialization_jsonJsonElement : SPMCBase
@property (class, readonly, getter=companion) SPMCKotlinx_serialization_jsonJsonElementCompanion *companion __attribute__((swift_name("companion")));
@end

__attribute__((swift_name("KotlinFunction")))
@protocol SPMCKotlinFunction
@required
@end

__attribute__((swift_name("KotlinSuspendFunction0")))
@protocol SPMCKotlinSuspendFunction0 <SPMCKotlinFunction>
@required

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)invokeWithCompletionHandler:(void (^)(id _Nullable_result, NSError * _Nullable))completionHandler __attribute__((swift_name("invoke(completionHandler:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinEnumCompanion")))
@interface SPMCKotlinEnumCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinEnumCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinArray")))
@interface SPMCKotlinArray<T> : SPMCBase
+ (instancetype)arrayWithSize:(int32_t)size init:(T _Nullable (^)(SPMCInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (T _Nullable)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (id<SPMCKotlinIterator>)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(T _Nullable)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreEncoder")))
@protocol SPMCKotlinx_serialization_coreEncoder
@required
- (id<SPMCKotlinx_serialization_coreCompositeEncoder>)beginCollectionDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor collectionSize:(int32_t)collectionSize __attribute__((swift_name("beginCollection(descriptor:collectionSize:)")));
- (id<SPMCKotlinx_serialization_coreCompositeEncoder>)beginStructureDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("beginStructure(descriptor:)")));
- (void)encodeBooleanValue:(BOOL)value __attribute__((swift_name("encodeBoolean(value:)")));
- (void)encodeByteValue:(int8_t)value __attribute__((swift_name("encodeByte(value:)")));
- (void)encodeCharValue:(unichar)value __attribute__((swift_name("encodeChar(value:)")));
- (void)encodeDoubleValue:(double)value __attribute__((swift_name("encodeDouble(value:)")));
- (void)encodeEnumEnumDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)enumDescriptor index:(int32_t)index __attribute__((swift_name("encodeEnum(enumDescriptor:index:)")));
- (void)encodeFloatValue:(float)value __attribute__((swift_name("encodeFloat(value:)")));
- (id<SPMCKotlinx_serialization_coreEncoder>)encodeInlineDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("encodeInline(descriptor:)")));
- (void)encodeIntValue:(int32_t)value __attribute__((swift_name("encodeInt(value:)")));
- (void)encodeLongValue:(int64_t)value __attribute__((swift_name("encodeLong(value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNotNullMark __attribute__((swift_name("encodeNotNullMark()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNull __attribute__((swift_name("encodeNull()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNullableSerializableValueSerializer:(id<SPMCKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeNullableSerializableValue(serializer:value:)")));
- (void)encodeSerializableValueSerializer:(id<SPMCKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeSerializableValue(serializer:value:)")));
- (void)encodeShortValue:(int16_t)value __attribute__((swift_name("encodeShort(value:)")));
- (void)encodeStringValue:(NSString *)value __attribute__((swift_name("encodeString(value:)")));
@property (readonly) SPMCKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerialDescriptor")))
@protocol SPMCKotlinx_serialization_coreSerialDescriptor
@required

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (NSArray<id<SPMCKotlinAnnotation>> *)getElementAnnotationsIndex:(int32_t)index __attribute__((swift_name("getElementAnnotations(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<SPMCKotlinx_serialization_coreSerialDescriptor>)getElementDescriptorIndex:(int32_t)index __attribute__((swift_name("getElementDescriptor(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (int32_t)getElementIndexName:(NSString *)name __attribute__((swift_name("getElementIndex(name:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (NSString *)getElementNameIndex:(int32_t)index __attribute__((swift_name("getElementName(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)isElementOptionalIndex:(int32_t)index __attribute__((swift_name("isElementOptional(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) NSArray<id<SPMCKotlinAnnotation>> *annotations __attribute__((swift_name("annotations")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) int32_t elementsCount __attribute__((swift_name("elementsCount")));
@property (readonly) BOOL isInline __attribute__((swift_name("isInline")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) BOOL isNullable __attribute__((swift_name("isNullable")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) SPMCKotlinx_serialization_coreSerialKind *kind __attribute__((swift_name("kind")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) NSString *serialName __attribute__((swift_name("serialName")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreDecoder")))
@protocol SPMCKotlinx_serialization_coreDecoder
@required
- (id<SPMCKotlinx_serialization_coreCompositeDecoder>)beginStructureDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("beginStructure(descriptor:)")));
- (BOOL)decodeBoolean __attribute__((swift_name("decodeBoolean()")));
- (int8_t)decodeByte __attribute__((swift_name("decodeByte()")));
- (unichar)decodeChar __attribute__((swift_name("decodeChar()")));
- (double)decodeDouble __attribute__((swift_name("decodeDouble()")));
- (int32_t)decodeEnumEnumDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)enumDescriptor __attribute__((swift_name("decodeEnum(enumDescriptor:)")));
- (float)decodeFloat __attribute__((swift_name("decodeFloat()")));
- (id<SPMCKotlinx_serialization_coreDecoder>)decodeInlineDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeInline(descriptor:)")));
- (int32_t)decodeInt __attribute__((swift_name("decodeInt()")));
- (int64_t)decodeLong __attribute__((swift_name("decodeLong()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)decodeNotNullMark __attribute__((swift_name("decodeNotNullMark()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (SPMCKotlinNothing * _Nullable)decodeNull __attribute__((swift_name("decodeNull()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id _Nullable)decodeNullableSerializableValueDeserializer:(id<SPMCKotlinx_serialization_coreDeserializationStrategy>)deserializer __attribute__((swift_name("decodeNullableSerializableValue(deserializer:)")));
- (id _Nullable)decodeSerializableValueDeserializer:(id<SPMCKotlinx_serialization_coreDeserializationStrategy>)deserializer __attribute__((swift_name("decodeSerializableValue(deserializer:)")));
- (int16_t)decodeShort __attribute__((swift_name("decodeShort()")));
- (NSString *)decodeString __attribute__((swift_name("decodeString()")));
@property (readonly) SPMCKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=kotlinx/serialization/json/JsonPrimitiveSerializer))
*/
__attribute__((swift_name("Kotlinx_serialization_jsonJsonPrimitive")))
@interface SPMCKotlinx_serialization_jsonJsonPrimitive : SPMCKotlinx_serialization_jsonJsonElement
@property (class, readonly, getter=companion) SPMCKotlinx_serialization_jsonJsonPrimitiveCompanion *companion __attribute__((swift_name("companion")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *content __attribute__((swift_name("content")));
@property (readonly) BOOL isString __attribute__((swift_name("isString")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreCoroutineScope")))
@protocol SPMCKotlinx_coroutines_coreCoroutineScope
@required
@property (readonly) id<SPMCKotlinCoroutineContext> coroutineContext __attribute__((swift_name("coroutineContext")));
@end

__attribute__((swift_name("Ktor_ioCloseable")))
@protocol SPMCKtor_ioCloseable
@required
- (void)close __attribute__((swift_name("close()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpClient")))
@interface SPMCKtor_client_coreHttpClient : SPMCBase <SPMCKotlinx_coroutines_coreCoroutineScope, SPMCKtor_ioCloseable>
- (instancetype)initWithEngine:(id<SPMCKtor_client_coreHttpClientEngine>)engine userConfig:(SPMCKtor_client_coreHttpClientConfig<SPMCKtor_client_coreHttpClientEngineConfig *> *)userConfig __attribute__((swift_name("init(engine:userConfig:)"))) __attribute__((objc_designated_initializer));
- (void)close __attribute__((swift_name("close()")));
- (SPMCKtor_client_coreHttpClient *)configBlock:(void (^)(SPMCKtor_client_coreHttpClientConfig<id> *))block __attribute__((swift_name("config(block:)")));
- (BOOL)isSupportedCapability:(id<SPMCKtor_client_coreHttpClientEngineCapability>)capability __attribute__((swift_name("isSupported(capability:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) id<SPMCKtor_utilsAttributes> attributes __attribute__((swift_name("attributes")));
@property (readonly) id<SPMCKotlinCoroutineContext> coroutineContext __attribute__((swift_name("coroutineContext")));
@property (readonly) id<SPMCKtor_client_coreHttpClientEngine> engine __attribute__((swift_name("engine")));
@property (readonly) SPMCKtor_client_coreHttpClientEngineConfig *engineConfig __attribute__((swift_name("engineConfig")));
@property (readonly) SPMCKtor_eventsEvents *monitor __attribute__((swift_name("monitor")));
@property (readonly) SPMCKtor_client_coreHttpReceivePipeline *receivePipeline __attribute__((swift_name("receivePipeline")));
@property (readonly) SPMCKtor_client_coreHttpRequestPipeline *requestPipeline __attribute__((swift_name("requestPipeline")));
@property (readonly) SPMCKtor_client_coreHttpResponsePipeline *responsePipeline __attribute__((swift_name("responsePipeline")));
@property (readonly) SPMCKtor_client_coreHttpSendPipeline *sendPipeline __attribute__((swift_name("sendPipeline")));
@end

__attribute__((swift_name("Ktor_client_coreHttpClientEngine")))
@protocol SPMCKtor_client_coreHttpClientEngine <SPMCKotlinx_coroutines_coreCoroutineScope, SPMCKtor_ioCloseable>
@required

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)executeData:(SPMCKtor_client_coreHttpRequestData *)data completionHandler:(void (^)(SPMCKtor_client_coreHttpResponseData * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("execute(data:completionHandler:)")));
- (void)installClient:(SPMCKtor_client_coreHttpClient *)client __attribute__((swift_name("install(client:)")));
@property (readonly) SPMCKtor_client_coreHttpClientEngineConfig *config __attribute__((swift_name("config")));
@property (readonly) SPMCKotlinx_coroutines_coreCoroutineDispatcher *dispatcher __attribute__((swift_name("dispatcher")));
@property (readonly) NSSet<id<SPMCKtor_client_coreHttpClientEngineCapability>> *supportedCapabilities __attribute__((swift_name("supportedCapabilities")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinNothing")))
@interface SPMCKotlinNothing : SPMCBase
@end

__attribute__((swift_name("Multiplatform_settingsSettings")))
@protocol SPMCMultiplatform_settingsSettings
@required
- (void)clear __attribute__((swift_name("clear()")));
- (BOOL)getBooleanKey:(NSString *)key defaultValue:(BOOL)defaultValue __attribute__((swift_name("getBoolean(key:defaultValue:)")));
- (SPMCBoolean * _Nullable)getBooleanOrNullKey:(NSString *)key __attribute__((swift_name("getBooleanOrNull(key:)")));
- (double)getDoubleKey:(NSString *)key defaultValue:(double)defaultValue __attribute__((swift_name("getDouble(key:defaultValue:)")));
- (SPMCDouble * _Nullable)getDoubleOrNullKey:(NSString *)key __attribute__((swift_name("getDoubleOrNull(key:)")));
- (float)getFloatKey:(NSString *)key defaultValue:(float)defaultValue __attribute__((swift_name("getFloat(key:defaultValue:)")));
- (SPMCFloat * _Nullable)getFloatOrNullKey:(NSString *)key __attribute__((swift_name("getFloatOrNull(key:)")));
- (int32_t)getIntKey:(NSString *)key defaultValue:(int32_t)defaultValue __attribute__((swift_name("getInt(key:defaultValue:)")));
- (SPMCInt * _Nullable)getIntOrNullKey:(NSString *)key __attribute__((swift_name("getIntOrNull(key:)")));
- (int64_t)getLongKey:(NSString *)key defaultValue:(int64_t)defaultValue __attribute__((swift_name("getLong(key:defaultValue:)")));
- (SPMCLong * _Nullable)getLongOrNullKey:(NSString *)key __attribute__((swift_name("getLongOrNull(key:)")));
- (NSString *)getStringKey:(NSString *)key defaultValue:(NSString *)defaultValue __attribute__((swift_name("getString(key:defaultValue:)")));
- (NSString * _Nullable)getStringOrNullKey:(NSString *)key __attribute__((swift_name("getStringOrNull(key:)")));
- (BOOL)hasKeyKey:(NSString *)key __attribute__((swift_name("hasKey(key:)")));
- (void)putBooleanKey:(NSString *)key value:(BOOL)value __attribute__((swift_name("putBoolean(key:value:)")));
- (void)putDoubleKey:(NSString *)key value:(double)value __attribute__((swift_name("putDouble(key:value:)")));
- (void)putFloatKey:(NSString *)key value:(float)value __attribute__((swift_name("putFloat(key:value:)")));
- (void)putIntKey:(NSString *)key value:(int32_t)value __attribute__((swift_name("putInt(key:value:)")));
- (void)putLongKey:(NSString *)key value:(int64_t)value __attribute__((swift_name("putLong(key:value:)")));
- (void)putStringKey:(NSString *)key value:(NSString *)value __attribute__((swift_name("putString(key:value:)")));
- (void)removeKey:(NSString *)key __attribute__((swift_name("remove(key:)")));
@property (readonly) NSSet<NSString *> *keys __attribute__((swift_name("keys")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_datetimeInstant.Companion")))
@interface SPMCKotlinx_datetimeInstantCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinx_datetimeInstantCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKotlinx_datetimeInstant *)fromEpochMillisecondsEpochMilliseconds:(int64_t)epochMilliseconds __attribute__((swift_name("fromEpochMilliseconds(epochMilliseconds:)")));
- (SPMCKotlinx_datetimeInstant *)fromEpochSecondsEpochSeconds:(int64_t)epochSeconds nanosecondAdjustment:(int32_t)nanosecondAdjustment __attribute__((swift_name("fromEpochSeconds(epochSeconds:nanosecondAdjustment:)")));
- (SPMCKotlinx_datetimeInstant *)fromEpochSecondsEpochSeconds:(int64_t)epochSeconds nanosecondAdjustment_:(int64_t)nanosecondAdjustment __attribute__((swift_name("fromEpochSeconds(epochSeconds:nanosecondAdjustment_:)")));
- (SPMCKotlinx_datetimeInstant *)now __attribute__((swift_name("now()"))) __attribute__((unavailable("Use Clock.System.now() instead")));
- (SPMCKotlinx_datetimeInstant *)parseInput:(id)input format:(id<SPMCKotlinx_datetimeDateTimeFormat>)format __attribute__((swift_name("parse(input:format:)")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@property (readonly) SPMCKotlinx_datetimeInstant *DISTANT_FUTURE __attribute__((swift_name("DISTANT_FUTURE")));
@property (readonly) SPMCKotlinx_datetimeInstant *DISTANT_PAST __attribute__((swift_name("DISTANT_PAST")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerialFormat")))
@protocol SPMCKotlinx_serialization_coreSerialFormat
@required
@property (readonly) SPMCKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreStringFormat")))
@protocol SPMCKotlinx_serialization_coreStringFormat <SPMCKotlinx_serialization_coreSerialFormat>
@required
- (id _Nullable)decodeFromStringDeserializer:(id<SPMCKotlinx_serialization_coreDeserializationStrategy>)deserializer string:(NSString *)string __attribute__((swift_name("decodeFromString(deserializer:string:)")));
- (NSString *)encodeToStringSerializer:(id<SPMCKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeToString(serializer:value:)")));
@end

__attribute__((swift_name("Kotlinx_serialization_jsonJson")))
@interface SPMCKotlinx_serialization_jsonJson : SPMCBase <SPMCKotlinx_serialization_coreStringFormat>
@property (class, readonly, getter=companion) SPMCKotlinx_serialization_jsonJsonDefault *companion __attribute__((swift_name("companion")));
- (id _Nullable)decodeFromJsonElementDeserializer:(id<SPMCKotlinx_serialization_coreDeserializationStrategy>)deserializer element:(SPMCKotlinx_serialization_jsonJsonElement *)element __attribute__((swift_name("decodeFromJsonElement(deserializer:element:)")));
- (id _Nullable)decodeFromStringString:(NSString *)string __attribute__((swift_name("decodeFromString(string:)")));
- (id _Nullable)decodeFromStringDeserializer:(id<SPMCKotlinx_serialization_coreDeserializationStrategy>)deserializer string:(NSString *)string __attribute__((swift_name("decodeFromString(deserializer:string:)")));
- (SPMCKotlinx_serialization_jsonJsonElement *)encodeToJsonElementSerializer:(id<SPMCKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeToJsonElement(serializer:value:)")));
- (NSString *)encodeToStringSerializer:(id<SPMCKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeToString(serializer:value:)")));
- (SPMCKotlinx_serialization_jsonJsonElement *)parseToJsonElementString:(NSString *)string __attribute__((swift_name("parseToJsonElement(string:)")));
@property (readonly) SPMCKotlinx_serialization_jsonJsonConfiguration *configuration __attribute__((swift_name("configuration")));
@property (readonly) SPMCKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Ktor_client_coreHttpClientPlugin")))
@protocol SPMCKtor_client_coreHttpClientPlugin
@required
- (void)installPlugin:(id)plugin scope:(SPMCKtor_client_coreHttpClient *)scope __attribute__((swift_name("install(plugin:scope:)")));
- (id)prepareBlock:(void (^)(id))block __attribute__((swift_name("prepare(block:)")));
@property (readonly) SPMCKtor_utilsAttributeKey<id> *key __attribute__((swift_name("key")));
@end

__attribute__((swift_name("Ktor_client_coreClientPlugin")))
@protocol SPMCKtor_client_coreClientPlugin <SPMCKtor_client_coreHttpClientPlugin>
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_jsonJsonElement.Companion")))
@interface SPMCKotlinx_serialization_jsonJsonElementCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinx_serialization_jsonJsonElementCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((swift_name("KotlinIterator")))
@protocol SPMCKotlinIterator
@required
- (BOOL)hasNext __attribute__((swift_name("hasNext()")));
- (id _Nullable)next __attribute__((swift_name("next()")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreCompositeEncoder")))
@protocol SPMCKotlinx_serialization_coreCompositeEncoder
@required
- (void)encodeBooleanElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(BOOL)value __attribute__((swift_name("encodeBooleanElement(descriptor:index:value:)")));
- (void)encodeByteElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int8_t)value __attribute__((swift_name("encodeByteElement(descriptor:index:value:)")));
- (void)encodeCharElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(unichar)value __attribute__((swift_name("encodeCharElement(descriptor:index:value:)")));
- (void)encodeDoubleElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(double)value __attribute__((swift_name("encodeDoubleElement(descriptor:index:value:)")));
- (void)encodeFloatElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(float)value __attribute__((swift_name("encodeFloatElement(descriptor:index:value:)")));
- (id<SPMCKotlinx_serialization_coreEncoder>)encodeInlineElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("encodeInlineElement(descriptor:index:)")));
- (void)encodeIntElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int32_t)value __attribute__((swift_name("encodeIntElement(descriptor:index:value:)")));
- (void)encodeLongElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int64_t)value __attribute__((swift_name("encodeLongElement(descriptor:index:value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNullableSerializableElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index serializer:(id<SPMCKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeNullableSerializableElement(descriptor:index:serializer:value:)")));
- (void)encodeSerializableElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index serializer:(id<SPMCKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeSerializableElement(descriptor:index:serializer:value:)")));
- (void)encodeShortElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int16_t)value __attribute__((swift_name("encodeShortElement(descriptor:index:value:)")));
- (void)encodeStringElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(NSString *)value __attribute__((swift_name("encodeStringElement(descriptor:index:value:)")));
- (void)endStructureDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("endStructure(descriptor:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)shouldEncodeElementDefaultDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("shouldEncodeElementDefault(descriptor:index:)")));
@property (readonly) SPMCKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerializersModule")))
@interface SPMCKotlinx_serialization_coreSerializersModule : SPMCBase

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)dumpToCollector:(id<SPMCKotlinx_serialization_coreSerializersModuleCollector>)collector __attribute__((swift_name("dumpTo(collector:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<SPMCKotlinx_serialization_coreKSerializer> _Nullable)getContextualKClass:(id<SPMCKotlinKClass>)kClass typeArgumentsSerializers:(NSArray<id<SPMCKotlinx_serialization_coreKSerializer>> *)typeArgumentsSerializers __attribute__((swift_name("getContextual(kClass:typeArgumentsSerializers:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<SPMCKotlinx_serialization_coreSerializationStrategy> _Nullable)getPolymorphicBaseClass:(id<SPMCKotlinKClass>)baseClass value:(id)value __attribute__((swift_name("getPolymorphic(baseClass:value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<SPMCKotlinx_serialization_coreDeserializationStrategy> _Nullable)getPolymorphicBaseClass:(id<SPMCKotlinKClass>)baseClass serializedClassName:(NSString * _Nullable)serializedClassName __attribute__((swift_name("getPolymorphic(baseClass:serializedClassName:)")));
@end

__attribute__((swift_name("KotlinAnnotation")))
@protocol SPMCKotlinAnnotation
@required
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((swift_name("Kotlinx_serialization_coreSerialKind")))
@interface SPMCKotlinx_serialization_coreSerialKind : SPMCBase
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreCompositeDecoder")))
@protocol SPMCKotlinx_serialization_coreCompositeDecoder
@required
- (BOOL)decodeBooleanElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeBooleanElement(descriptor:index:)")));
- (int8_t)decodeByteElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeByteElement(descriptor:index:)")));
- (unichar)decodeCharElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeCharElement(descriptor:index:)")));
- (int32_t)decodeCollectionSizeDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeCollectionSize(descriptor:)")));
- (double)decodeDoubleElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeDoubleElement(descriptor:index:)")));
- (int32_t)decodeElementIndexDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeElementIndex(descriptor:)")));
- (float)decodeFloatElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeFloatElement(descriptor:index:)")));
- (id<SPMCKotlinx_serialization_coreDecoder>)decodeInlineElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeInlineElement(descriptor:index:)")));
- (int32_t)decodeIntElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeIntElement(descriptor:index:)")));
- (int64_t)decodeLongElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeLongElement(descriptor:index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id _Nullable)decodeNullableSerializableElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index deserializer:(id<SPMCKotlinx_serialization_coreDeserializationStrategy>)deserializer previousValue:(id _Nullable)previousValue __attribute__((swift_name("decodeNullableSerializableElement(descriptor:index:deserializer:previousValue:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)decodeSequentially __attribute__((swift_name("decodeSequentially()")));
- (id _Nullable)decodeSerializableElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index deserializer:(id<SPMCKotlinx_serialization_coreDeserializationStrategy>)deserializer previousValue:(id _Nullable)previousValue __attribute__((swift_name("decodeSerializableElement(descriptor:index:deserializer:previousValue:)")));
- (int16_t)decodeShortElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeShortElement(descriptor:index:)")));
- (NSString *)decodeStringElementDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeStringElement(descriptor:index:)")));
- (void)endStructureDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("endStructure(descriptor:)")));
@property (readonly) SPMCKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_jsonJsonPrimitive.Companion")))
@interface SPMCKotlinx_serialization_jsonJsonPrimitiveCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinx_serialization_jsonJsonPrimitiveCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.3")
*/
__attribute__((swift_name("KotlinCoroutineContext")))
@protocol SPMCKotlinCoroutineContext
@required
- (id _Nullable)foldInitial:(id _Nullable)initial operation:(id _Nullable (^)(id _Nullable, id<SPMCKotlinCoroutineContextElement>))operation __attribute__((swift_name("fold(initial:operation:)")));
- (id<SPMCKotlinCoroutineContextElement> _Nullable)getKey:(id<SPMCKotlinCoroutineContextKey>)key __attribute__((swift_name("get(key:)")));
- (id<SPMCKotlinCoroutineContext>)minusKeyKey:(id<SPMCKotlinCoroutineContextKey>)key __attribute__((swift_name("minusKey(key:)")));
- (id<SPMCKotlinCoroutineContext>)plusContext:(id<SPMCKotlinCoroutineContext>)context __attribute__((swift_name("plus(context:)")));
@end

__attribute__((swift_name("Ktor_client_coreHttpClientEngineConfig")))
@interface SPMCKtor_client_coreHttpClientEngineConfig : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property SPMCKotlinx_coroutines_coreCoroutineDispatcher * _Nullable dispatcher __attribute__((swift_name("dispatcher")));
@property BOOL pipelining __attribute__((swift_name("pipelining")));
@property SPMCKtor_client_coreProxyConfig * _Nullable proxy __attribute__((swift_name("proxy")));
@property int32_t threadsCount __attribute__((swift_name("threadsCount"))) __attribute__((unavailable("The [threadsCount] property is deprecated. Consider setting [dispatcher] instead.")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpClientConfig")))
@interface SPMCKtor_client_coreHttpClientConfig<T> : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (SPMCKtor_client_coreHttpClientConfig<T> *)clone __attribute__((swift_name("clone()")));
- (void)engineBlock:(void (^)(T))block __attribute__((swift_name("engine(block:)")));
- (void)installClient:(SPMCKtor_client_coreHttpClient *)client __attribute__((swift_name("install(client:)")));
- (void)installPlugin:(id<SPMCKtor_client_coreHttpClientPlugin>)plugin configure:(void (^)(id))configure __attribute__((swift_name("install(plugin:configure:)")));
- (void)installKey:(NSString *)key block:(void (^)(SPMCKtor_client_coreHttpClient *))block __attribute__((swift_name("install(key:block:)")));
- (void)plusAssignOther:(SPMCKtor_client_coreHttpClientConfig<T> *)other __attribute__((swift_name("plusAssign(other:)")));
@property BOOL developmentMode __attribute__((swift_name("developmentMode"))) __attribute__((deprecated("Development mode is no longer required. The property will be removed in the future.")));
@property BOOL expectSuccess __attribute__((swift_name("expectSuccess")));
@property BOOL followRedirects __attribute__((swift_name("followRedirects")));
@property BOOL useDefaultTransformers __attribute__((swift_name("useDefaultTransformers")));
@end

__attribute__((swift_name("Ktor_client_coreHttpClientEngineCapability")))
@protocol SPMCKtor_client_coreHttpClientEngineCapability
@required
@end

__attribute__((swift_name("Ktor_utilsAttributes")))
@protocol SPMCKtor_utilsAttributes
@required
- (id)computeIfAbsentKey:(SPMCKtor_utilsAttributeKey<id> *)key block:(id (^)(void))block __attribute__((swift_name("computeIfAbsent(key:block:)")));
- (BOOL)containsKey:(SPMCKtor_utilsAttributeKey<id> *)key __attribute__((swift_name("contains(key:)")));
- (id)getKey_:(SPMCKtor_utilsAttributeKey<id> *)key __attribute__((swift_name("get(key_:)")));
- (id _Nullable)getOrNullKey:(SPMCKtor_utilsAttributeKey<id> *)key __attribute__((swift_name("getOrNull(key:)")));
- (void)putKey:(SPMCKtor_utilsAttributeKey<id> *)key value:(id)value __attribute__((swift_name("put(key:value:)")));
- (void)removeKey_:(SPMCKtor_utilsAttributeKey<id> *)key __attribute__((swift_name("remove(key_:)")));
- (id)takeKey:(SPMCKtor_utilsAttributeKey<id> *)key __attribute__((swift_name("take(key:)")));
- (id _Nullable)takeOrNullKey:(SPMCKtor_utilsAttributeKey<id> *)key __attribute__((swift_name("takeOrNull(key:)")));
@property (readonly) NSArray<SPMCKtor_utilsAttributeKey<id> *> *allKeys __attribute__((swift_name("allKeys")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_eventsEvents")))
@interface SPMCKtor_eventsEvents : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)raiseDefinition:(SPMCKtor_eventsEventDefinition<id> *)definition value:(id _Nullable)value __attribute__((swift_name("raise(definition:value:)")));
- (id<SPMCKotlinx_coroutines_coreDisposableHandle>)subscribeDefinition:(SPMCKtor_eventsEventDefinition<id> *)definition handler:(void (^)(id _Nullable))handler __attribute__((swift_name("subscribe(definition:handler:)")));
- (void)unsubscribeDefinition:(SPMCKtor_eventsEventDefinition<id> *)definition handler:(void (^)(id _Nullable))handler __attribute__((swift_name("unsubscribe(definition:handler:)")));
@end

__attribute__((swift_name("Ktor_utilsPipeline")))
@interface SPMCKtor_utilsPipeline<TSubject, TContext> : SPMCBase
- (instancetype)initWithPhases:(SPMCKotlinArray<SPMCKtor_utilsPipelinePhase *> *)phases __attribute__((swift_name("init(phases:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithPhase:(SPMCKtor_utilsPipelinePhase *)phase interceptors:(NSArray<id<SPMCKotlinSuspendFunction2>> *)interceptors __attribute__((swift_name("init(phase:interceptors:)"))) __attribute__((objc_designated_initializer));
- (void)addPhasePhase:(SPMCKtor_utilsPipelinePhase *)phase __attribute__((swift_name("addPhase(phase:)")));
- (void)afterIntercepted __attribute__((swift_name("afterIntercepted()")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)executeContext:(TContext)context subject:(TSubject)subject completionHandler:(void (^)(TSubject _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("execute(context:subject:completionHandler:)")));
- (void)insertPhaseAfterReference:(SPMCKtor_utilsPipelinePhase *)reference phase:(SPMCKtor_utilsPipelinePhase *)phase __attribute__((swift_name("insertPhaseAfter(reference:phase:)")));
- (void)insertPhaseBeforeReference:(SPMCKtor_utilsPipelinePhase *)reference phase:(SPMCKtor_utilsPipelinePhase *)phase __attribute__((swift_name("insertPhaseBefore(reference:phase:)")));
- (void)interceptPhase:(SPMCKtor_utilsPipelinePhase *)phase block:(id<SPMCKotlinSuspendFunction2>)block __attribute__((swift_name("intercept(phase:block:)")));
- (NSArray<id<SPMCKotlinSuspendFunction2>> *)interceptorsForPhasePhase:(SPMCKtor_utilsPipelinePhase *)phase __attribute__((swift_name("interceptorsForPhase(phase:)")));
- (void)mergeFrom:(SPMCKtor_utilsPipeline<TSubject, TContext> *)from __attribute__((swift_name("merge(from:)")));
- (void)mergePhasesFrom:(SPMCKtor_utilsPipeline<TSubject, TContext> *)from __attribute__((swift_name("mergePhases(from:)")));
- (void)resetFromFrom:(SPMCKtor_utilsPipeline<TSubject, TContext> *)from __attribute__((swift_name("resetFrom(from:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) id<SPMCKtor_utilsAttributes> attributes __attribute__((swift_name("attributes")));
@property (readonly) BOOL developmentMode __attribute__((swift_name("developmentMode")));
@property (readonly) BOOL isEmpty __attribute__((swift_name("isEmpty")));
@property (readonly) NSArray<SPMCKtor_utilsPipelinePhase *> *items __attribute__((swift_name("items")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpReceivePipeline")))
@interface SPMCKtor_client_coreHttpReceivePipeline : SPMCKtor_utilsPipeline<SPMCKtor_client_coreHttpResponse *, SPMCKotlinUnit *>
- (instancetype)initWithDevelopmentMode:(BOOL)developmentMode __attribute__((swift_name("init(developmentMode:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithPhases:(SPMCKotlinArray<SPMCKtor_utilsPipelinePhase *> *)phases __attribute__((swift_name("init(phases:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithPhase:(SPMCKtor_utilsPipelinePhase *)phase interceptors:(NSArray<id<SPMCKotlinSuspendFunction2>> *)interceptors __attribute__((swift_name("init(phase:interceptors:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKtor_client_coreHttpReceivePipelinePhases *companion __attribute__((swift_name("companion")));
@property (readonly) BOOL developmentMode __attribute__((swift_name("developmentMode")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpRequestPipeline")))
@interface SPMCKtor_client_coreHttpRequestPipeline : SPMCKtor_utilsPipeline<id, SPMCKtor_client_coreHttpRequestBuilder *>
- (instancetype)initWithDevelopmentMode:(BOOL)developmentMode __attribute__((swift_name("init(developmentMode:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithPhases:(SPMCKotlinArray<SPMCKtor_utilsPipelinePhase *> *)phases __attribute__((swift_name("init(phases:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithPhase:(SPMCKtor_utilsPipelinePhase *)phase interceptors:(NSArray<id<SPMCKotlinSuspendFunction2>> *)interceptors __attribute__((swift_name("init(phase:interceptors:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKtor_client_coreHttpRequestPipelinePhases *companion __attribute__((swift_name("companion")));
@property (readonly) BOOL developmentMode __attribute__((swift_name("developmentMode")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpResponsePipeline")))
@interface SPMCKtor_client_coreHttpResponsePipeline : SPMCKtor_utilsPipeline<SPMCKtor_client_coreHttpResponseContainer *, SPMCKtor_client_coreHttpClientCall *>
- (instancetype)initWithDevelopmentMode:(BOOL)developmentMode __attribute__((swift_name("init(developmentMode:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithPhases:(SPMCKotlinArray<SPMCKtor_utilsPipelinePhase *> *)phases __attribute__((swift_name("init(phases:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithPhase:(SPMCKtor_utilsPipelinePhase *)phase interceptors:(NSArray<id<SPMCKotlinSuspendFunction2>> *)interceptors __attribute__((swift_name("init(phase:interceptors:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKtor_client_coreHttpResponsePipelinePhases *companion __attribute__((swift_name("companion")));
@property (readonly) BOOL developmentMode __attribute__((swift_name("developmentMode")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpSendPipeline")))
@interface SPMCKtor_client_coreHttpSendPipeline : SPMCKtor_utilsPipeline<id, SPMCKtor_client_coreHttpRequestBuilder *>
- (instancetype)initWithDevelopmentMode:(BOOL)developmentMode __attribute__((swift_name("init(developmentMode:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithPhases:(SPMCKotlinArray<SPMCKtor_utilsPipelinePhase *> *)phases __attribute__((swift_name("init(phases:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (instancetype)initWithPhase:(SPMCKtor_utilsPipelinePhase *)phase interceptors:(NSArray<id<SPMCKotlinSuspendFunction2>> *)interceptors __attribute__((swift_name("init(phase:interceptors:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKtor_client_coreHttpSendPipelinePhases *companion __attribute__((swift_name("companion")));
@property (readonly) BOOL developmentMode __attribute__((swift_name("developmentMode")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpRequestData")))
@interface SPMCKtor_client_coreHttpRequestData : SPMCBase
- (instancetype)initWithUrl:(SPMCKtor_httpUrl *)url method:(SPMCKtor_httpHttpMethod *)method headers:(id<SPMCKtor_httpHeaders>)headers body:(SPMCKtor_httpOutgoingContent *)body executionContext:(id<SPMCKotlinx_coroutines_coreJob>)executionContext attributes:(id<SPMCKtor_utilsAttributes>)attributes __attribute__((swift_name("init(url:method:headers:body:executionContext:attributes:)"))) __attribute__((objc_designated_initializer));
- (id _Nullable)getCapabilityOrNullKey:(id<SPMCKtor_client_coreHttpClientEngineCapability>)key __attribute__((swift_name("getCapabilityOrNull(key:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) id<SPMCKtor_utilsAttributes> attributes __attribute__((swift_name("attributes")));
@property (readonly) SPMCKtor_httpOutgoingContent *body __attribute__((swift_name("body")));
@property (readonly) id<SPMCKotlinx_coroutines_coreJob> executionContext __attribute__((swift_name("executionContext")));
@property (readonly) id<SPMCKtor_httpHeaders> headers __attribute__((swift_name("headers")));
@property (readonly) SPMCKtor_httpHttpMethod *method __attribute__((swift_name("method")));
@property (readonly) SPMCKtor_httpUrl *url __attribute__((swift_name("url")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpResponseData")))
@interface SPMCKtor_client_coreHttpResponseData : SPMCBase
- (instancetype)initWithStatusCode:(SPMCKtor_httpHttpStatusCode *)statusCode requestTime:(SPMCKtor_utilsGMTDate *)requestTime headers:(id<SPMCKtor_httpHeaders>)headers version:(SPMCKtor_httpHttpProtocolVersion *)version body:(id)body callContext:(id<SPMCKotlinCoroutineContext>)callContext __attribute__((swift_name("init(statusCode:requestTime:headers:version:body:callContext:)"))) __attribute__((objc_designated_initializer));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) id body __attribute__((swift_name("body")));
@property (readonly) id<SPMCKotlinCoroutineContext> callContext __attribute__((swift_name("callContext")));
@property (readonly) id<SPMCKtor_httpHeaders> headers __attribute__((swift_name("headers")));
@property (readonly) SPMCKtor_utilsGMTDate *requestTime __attribute__((swift_name("requestTime")));
@property (readonly) SPMCKtor_utilsGMTDate *responseTime __attribute__((swift_name("responseTime")));
@property (readonly) SPMCKtor_httpHttpStatusCode *statusCode __attribute__((swift_name("statusCode")));
@property (readonly) SPMCKtor_httpHttpProtocolVersion *version __attribute__((swift_name("version")));
@end

__attribute__((swift_name("KotlinCoroutineContextElement")))
@protocol SPMCKotlinCoroutineContextElement <SPMCKotlinCoroutineContext>
@required
@property (readonly) id<SPMCKotlinCoroutineContextKey> key __attribute__((swift_name("key")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.3")
*/
__attribute__((swift_name("KotlinAbstractCoroutineContextElement")))
@interface SPMCKotlinAbstractCoroutineContextElement : SPMCBase <SPMCKotlinCoroutineContextElement>
- (instancetype)initWithKey:(id<SPMCKotlinCoroutineContextKey>)key __attribute__((swift_name("init(key:)"))) __attribute__((objc_designated_initializer));
@property (readonly) id<SPMCKotlinCoroutineContextKey> key __attribute__((swift_name("key")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.3")
*/
__attribute__((swift_name("KotlinContinuationInterceptor")))
@protocol SPMCKotlinContinuationInterceptor <SPMCKotlinCoroutineContextElement>
@required
- (id<SPMCKotlinContinuation>)interceptContinuationContinuation:(id<SPMCKotlinContinuation>)continuation __attribute__((swift_name("interceptContinuation(continuation:)")));
- (void)releaseInterceptedContinuationContinuation:(id<SPMCKotlinContinuation>)continuation __attribute__((swift_name("releaseInterceptedContinuation(continuation:)")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreCoroutineDispatcher")))
@interface SPMCKotlinx_coroutines_coreCoroutineDispatcher : SPMCKotlinAbstractCoroutineContextElement <SPMCKotlinContinuationInterceptor>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithKey:(id<SPMCKotlinCoroutineContextKey>)key __attribute__((swift_name("init(key:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKotlinx_coroutines_coreCoroutineDispatcherKey *companion __attribute__((swift_name("companion")));
- (void)dispatchContext:(id<SPMCKotlinCoroutineContext>)context block:(id<SPMCKotlinx_coroutines_coreRunnable>)block __attribute__((swift_name("dispatch(context:block:)")));

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
- (void)dispatchYieldContext:(id<SPMCKotlinCoroutineContext>)context block:(id<SPMCKotlinx_coroutines_coreRunnable>)block __attribute__((swift_name("dispatchYield(context:block:)")));
- (id<SPMCKotlinContinuation>)interceptContinuationContinuation:(id<SPMCKotlinContinuation>)continuation __attribute__((swift_name("interceptContinuation(continuation:)")));
- (BOOL)isDispatchNeededContext:(id<SPMCKotlinCoroutineContext>)context __attribute__((swift_name("isDispatchNeeded(context:)")));
- (SPMCKotlinx_coroutines_coreCoroutineDispatcher *)limitedParallelismParallelism:(int32_t)parallelism name:(NSString * _Nullable)name __attribute__((swift_name("limitedParallelism(parallelism:name:)")));
- (SPMCKotlinx_coroutines_coreCoroutineDispatcher *)plusOther:(SPMCKotlinx_coroutines_coreCoroutineDispatcher *)other __attribute__((swift_name("plus(other:)"))) __attribute__((unavailable("Operator '+' on two CoroutineDispatcher objects is meaningless. CoroutineDispatcher is a coroutine context element and `+` is a set-sum operator for coroutine contexts. The dispatcher to the right of `+` just replaces the dispatcher to the left.")));
- (void)releaseInterceptedContinuationContinuation:(id<SPMCKotlinContinuation>)continuation __attribute__((swift_name("releaseInterceptedContinuation(continuation:)")));
- (NSString *)description __attribute__((swift_name("description()")));
@end

__attribute__((swift_name("Kotlinx_datetimeDateTimeFormat")))
@protocol SPMCKotlinx_datetimeDateTimeFormat
@required
- (NSString *)formatValue:(id _Nullable)value __attribute__((swift_name("format(value:)")));
- (id<SPMCKotlinAppendable>)formatToAppendable:(id<SPMCKotlinAppendable>)appendable value:(id _Nullable)value __attribute__((swift_name("formatTo(appendable:value:)")));
- (id _Nullable)parseInput:(id)input __attribute__((swift_name("parse(input:)")));
- (id _Nullable)parseOrNullInput:(id)input __attribute__((swift_name("parseOrNull(input:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_jsonJson.Default")))
@interface SPMCKotlinx_serialization_jsonJsonDefault : SPMCKotlinx_serialization_jsonJson
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)default_ __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinx_serialization_jsonJsonDefault *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_jsonJsonConfiguration")))
@interface SPMCKotlinx_serialization_jsonJsonConfiguration : SPMCBase
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) BOOL allowComments __attribute__((swift_name("allowComments")));
@property (readonly) BOOL allowSpecialFloatingPointValues __attribute__((swift_name("allowSpecialFloatingPointValues")));
@property (readonly) BOOL allowStructuredMapKeys __attribute__((swift_name("allowStructuredMapKeys")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) BOOL allowTrailingComma __attribute__((swift_name("allowTrailingComma")));
@property (readonly) NSString *classDiscriminator __attribute__((swift_name("classDiscriminator")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property SPMCKotlinx_serialization_jsonClassDiscriminatorMode *classDiscriminatorMode __attribute__((swift_name("classDiscriminatorMode")));
@property (readonly) BOOL coerceInputValues __attribute__((swift_name("coerceInputValues")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) BOOL decodeEnumsCaseInsensitive __attribute__((swift_name("decodeEnumsCaseInsensitive")));
@property (readonly) BOOL encodeDefaults __attribute__((swift_name("encodeDefaults")));
@property (readonly) BOOL explicitNulls __attribute__((swift_name("explicitNulls")));
@property (readonly) BOOL ignoreUnknownKeys __attribute__((swift_name("ignoreUnknownKeys")));
@property (readonly) BOOL isLenient __attribute__((swift_name("isLenient")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) id<SPMCKotlinx_serialization_jsonJsonNamingStrategy> _Nullable namingStrategy __attribute__((swift_name("namingStrategy")));
@property (readonly) BOOL prettyPrint __attribute__((swift_name("prettyPrint")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) NSString *prettyPrintIndent __attribute__((swift_name("prettyPrintIndent")));
@property (readonly) BOOL useAlternativeNames __attribute__((swift_name("useAlternativeNames")));
@property (readonly) BOOL useArrayPolymorphism __attribute__((swift_name("useArrayPolymorphism")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsAttributeKey")))
@interface SPMCKtor_utilsAttributeKey<T> : SPMCBase

/**
 * @note annotations
 *   kotlin.jvm.JvmOverloads
*/
- (instancetype)initWithName:(NSString *)name type:(SPMCKtor_utilsTypeInfo *)type __attribute__((swift_name("init(name:type:)"))) __attribute__((objc_designated_initializer));
- (SPMCKtor_utilsAttributeKey<T> *)doCopyName:(NSString *)name type:(SPMCKtor_utilsTypeInfo *)type __attribute__((swift_name("doCopy(name:type:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((swift_name("Kotlinx_serialization_coreSerializersModuleCollector")))
@protocol SPMCKotlinx_serialization_coreSerializersModuleCollector
@required
- (void)contextualKClass:(id<SPMCKotlinKClass>)kClass provider:(id<SPMCKotlinx_serialization_coreKSerializer> (^)(NSArray<id<SPMCKotlinx_serialization_coreKSerializer>> *))provider __attribute__((swift_name("contextual(kClass:provider:)")));
- (void)contextualKClass:(id<SPMCKotlinKClass>)kClass serializer:(id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("contextual(kClass:serializer:)")));
- (void)polymorphicBaseClass:(id<SPMCKotlinKClass>)baseClass actualClass:(id<SPMCKotlinKClass>)actualClass actualSerializer:(id<SPMCKotlinx_serialization_coreKSerializer>)actualSerializer __attribute__((swift_name("polymorphic(baseClass:actualClass:actualSerializer:)")));
- (void)polymorphicDefaultBaseClass:(id<SPMCKotlinKClass>)baseClass defaultDeserializerProvider:(id<SPMCKotlinx_serialization_coreDeserializationStrategy> _Nullable (^)(NSString * _Nullable))defaultDeserializerProvider __attribute__((swift_name("polymorphicDefault(baseClass:defaultDeserializerProvider:)"))) __attribute__((deprecated("Deprecated in favor of function with more precise name: polymorphicDefaultDeserializer")));
- (void)polymorphicDefaultDeserializerBaseClass:(id<SPMCKotlinKClass>)baseClass defaultDeserializerProvider:(id<SPMCKotlinx_serialization_coreDeserializationStrategy> _Nullable (^)(NSString * _Nullable))defaultDeserializerProvider __attribute__((swift_name("polymorphicDefaultDeserializer(baseClass:defaultDeserializerProvider:)")));
- (void)polymorphicDefaultSerializerBaseClass:(id<SPMCKotlinKClass>)baseClass defaultSerializerProvider:(id<SPMCKotlinx_serialization_coreSerializationStrategy> _Nullable (^)(id))defaultSerializerProvider __attribute__((swift_name("polymorphicDefaultSerializer(baseClass:defaultSerializerProvider:)")));
@end

__attribute__((swift_name("KotlinKDeclarationContainer")))
@protocol SPMCKotlinKDeclarationContainer
@required
@end

__attribute__((swift_name("KotlinKAnnotatedElement")))
@protocol SPMCKotlinKAnnotatedElement
@required
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
__attribute__((swift_name("KotlinKClassifier")))
@protocol SPMCKotlinKClassifier
@required
@end

__attribute__((swift_name("KotlinKClass")))
@protocol SPMCKotlinKClass <SPMCKotlinKDeclarationContainer, SPMCKotlinKAnnotatedElement, SPMCKotlinKClassifier>
@required

/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
- (BOOL)isInstanceValue:(id _Nullable)value __attribute__((swift_name("isInstance(value:)")));
@property (readonly) NSString * _Nullable qualifiedName __attribute__((swift_name("qualifiedName")));
@property (readonly) NSString * _Nullable simpleName __attribute__((swift_name("simpleName")));
@end

__attribute__((swift_name("KotlinCoroutineContextKey")))
@protocol SPMCKotlinCoroutineContextKey
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreProxyConfig")))
@interface SPMCKtor_client_coreProxyConfig : SPMCBase
- (instancetype)initWithUrl:(SPMCKtor_httpUrl *)url __attribute__((swift_name("init(url:)"))) __attribute__((objc_designated_initializer));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKtor_httpUrl *url __attribute__((swift_name("url")));
@end

__attribute__((swift_name("Ktor_eventsEventDefinition")))
@interface SPMCKtor_eventsEventDefinition<T> : SPMCBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreDisposableHandle")))
@protocol SPMCKotlinx_coroutines_coreDisposableHandle
@required
- (void)dispose __attribute__((swift_name("dispose()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsPipelinePhase")))
@interface SPMCKtor_utilsPipelinePhase : SPMCBase
- (instancetype)initWithName:(NSString *)name __attribute__((swift_name("init(name:)"))) __attribute__((objc_designated_initializer));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@end

__attribute__((swift_name("KotlinSuspendFunction2")))
@protocol SPMCKotlinSuspendFunction2 <SPMCKotlinFunction>
@required

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)invokeP1:(id _Nullable)p1 p2:(id _Nullable)p2 completionHandler:(void (^)(id _Nullable_result, NSError * _Nullable))completionHandler __attribute__((swift_name("invoke(p1:p2:completionHandler:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpReceivePipeline.Phases")))
@interface SPMCKtor_client_coreHttpReceivePipelinePhases : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)phases __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_client_coreHttpReceivePipelinePhases *shared __attribute__((swift_name("shared")));
@property (readonly) SPMCKtor_utilsPipelinePhase *After __attribute__((swift_name("After")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Before __attribute__((swift_name("Before")));
@property (readonly) SPMCKtor_utilsPipelinePhase *State __attribute__((swift_name("State")));
@end

__attribute__((swift_name("Ktor_httpHttpMessage")))
@protocol SPMCKtor_httpHttpMessage
@required
@property (readonly) id<SPMCKtor_httpHeaders> headers __attribute__((swift_name("headers")));
@end

__attribute__((swift_name("Ktor_client_coreHttpResponse")))
@interface SPMCKtor_client_coreHttpResponse : SPMCBase <SPMCKtor_httpHttpMessage, SPMCKotlinx_coroutines_coreCoroutineScope>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKtor_client_coreHttpClientCall *call __attribute__((swift_name("call")));
@property (readonly) id<SPMCKtor_ioByteReadChannel> rawContent __attribute__((swift_name("rawContent")));
@property (readonly) SPMCKtor_utilsGMTDate *requestTime __attribute__((swift_name("requestTime")));
@property (readonly) SPMCKtor_utilsGMTDate *responseTime __attribute__((swift_name("responseTime")));
@property (readonly) SPMCKtor_httpHttpStatusCode *status __attribute__((swift_name("status")));
@property (readonly) SPMCKtor_httpHttpProtocolVersion *version __attribute__((swift_name("version")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinUnit")))
@interface SPMCKotlinUnit : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)unit __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinUnit *shared __attribute__((swift_name("shared")));
- (NSString *)description __attribute__((swift_name("description()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpRequestPipeline.Phases")))
@interface SPMCKtor_client_coreHttpRequestPipelinePhases : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)phases __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_client_coreHttpRequestPipelinePhases *shared __attribute__((swift_name("shared")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Before __attribute__((swift_name("Before")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Render __attribute__((swift_name("Render")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Send __attribute__((swift_name("Send")));
@property (readonly) SPMCKtor_utilsPipelinePhase *State __attribute__((swift_name("State")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Transform __attribute__((swift_name("Transform")));
@end

__attribute__((swift_name("Ktor_httpHttpMessageBuilder")))
@protocol SPMCKtor_httpHttpMessageBuilder
@required
@property (readonly) SPMCKtor_httpHeadersBuilder *headers __attribute__((swift_name("headers")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpRequestBuilder")))
@interface SPMCKtor_client_coreHttpRequestBuilder : SPMCBase <SPMCKtor_httpHttpMessageBuilder>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property (class, readonly, getter=companion) SPMCKtor_client_coreHttpRequestBuilderCompanion *companion __attribute__((swift_name("companion")));
- (SPMCKtor_client_coreHttpRequestData *)build __attribute__((swift_name("build()")));
- (id _Nullable)getCapabilityOrNullKey:(id<SPMCKtor_client_coreHttpClientEngineCapability>)key __attribute__((swift_name("getCapabilityOrNull(key:)")));
- (void)setAttributesBlock:(void (^)(id<SPMCKtor_utilsAttributes>))block __attribute__((swift_name("setAttributes(block:)")));
- (void)setCapabilityKey:(id<SPMCKtor_client_coreHttpClientEngineCapability>)key capability:(id)capability __attribute__((swift_name("setCapability(key:capability:)")));
- (SPMCKtor_client_coreHttpRequestBuilder *)takeFromBuilder:(SPMCKtor_client_coreHttpRequestBuilder *)builder __attribute__((swift_name("takeFrom(builder:)")));
- (SPMCKtor_client_coreHttpRequestBuilder *)takeFromWithExecutionContextBuilder:(SPMCKtor_client_coreHttpRequestBuilder *)builder __attribute__((swift_name("takeFromWithExecutionContext(builder:)")));
- (void)urlBlock:(void (^)(SPMCKtor_httpURLBuilder *, SPMCKtor_httpURLBuilder *))block __attribute__((swift_name("url(block:)")));
@property (readonly) id<SPMCKtor_utilsAttributes> attributes __attribute__((swift_name("attributes")));
@property id body __attribute__((swift_name("body")));
@property SPMCKtor_utilsTypeInfo * _Nullable bodyType __attribute__((swift_name("bodyType")));
@property (readonly) id<SPMCKotlinx_coroutines_coreJob> executionContext __attribute__((swift_name("executionContext")));
@property (readonly) SPMCKtor_httpHeadersBuilder *headers __attribute__((swift_name("headers")));
@property SPMCKtor_httpHttpMethod *method __attribute__((swift_name("method")));
@property (readonly) SPMCKtor_httpURLBuilder *url __attribute__((swift_name("url")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpResponsePipeline.Phases")))
@interface SPMCKtor_client_coreHttpResponsePipelinePhases : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)phases __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_client_coreHttpResponsePipelinePhases *shared __attribute__((swift_name("shared")));
@property (readonly) SPMCKtor_utilsPipelinePhase *After __attribute__((swift_name("After")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Parse __attribute__((swift_name("Parse")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Receive __attribute__((swift_name("Receive")));
@property (readonly) SPMCKtor_utilsPipelinePhase *State __attribute__((swift_name("State")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Transform __attribute__((swift_name("Transform")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpResponseContainer")))
@interface SPMCKtor_client_coreHttpResponseContainer : SPMCBase
- (instancetype)initWithExpectedType:(SPMCKtor_utilsTypeInfo *)expectedType response:(id)response __attribute__((swift_name("init(expectedType:response:)"))) __attribute__((objc_designated_initializer));
- (SPMCKtor_client_coreHttpResponseContainer *)doCopyExpectedType:(SPMCKtor_utilsTypeInfo *)expectedType response:(id)response __attribute__((swift_name("doCopy(expectedType:response:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) SPMCKtor_utilsTypeInfo *expectedType __attribute__((swift_name("expectedType")));
@property (readonly) id response __attribute__((swift_name("response")));
@end

__attribute__((swift_name("Ktor_client_coreHttpClientCall")))
@interface SPMCKtor_client_coreHttpClientCall : SPMCBase <SPMCKotlinx_coroutines_coreCoroutineScope>
- (instancetype)initWithClient:(SPMCKtor_client_coreHttpClient *)client __attribute__((swift_name("init(client:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithClient:(SPMCKtor_client_coreHttpClient *)client requestData:(SPMCKtor_client_coreHttpRequestData *)requestData responseData:(SPMCKtor_client_coreHttpResponseData *)responseData __attribute__((swift_name("init(client:requestData:responseData:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_client_coreHttpClientCallCompanion *companion __attribute__((swift_name("companion")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)bodyInfo:(SPMCKtor_utilsTypeInfo *)info completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("body(info:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)bodyNullableInfo:(SPMCKtor_utilsTypeInfo *)info completionHandler:(void (^)(id _Nullable_result, NSError * _Nullable))completionHandler __attribute__((swift_name("bodyNullable(info:completionHandler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
 * @note This method has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
- (void)getResponseContentWithCompletionHandler:(void (^)(id<SPMCKtor_ioByteReadChannel> _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("getResponseContent(completionHandler:)")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) BOOL allowDoubleReceive __attribute__((swift_name("allowDoubleReceive")));
@property (readonly) id<SPMCKtor_utilsAttributes> attributes __attribute__((swift_name("attributes")));
@property (readonly) SPMCKtor_client_coreHttpClient *client __attribute__((swift_name("client")));
@property (readonly) id<SPMCKotlinCoroutineContext> coroutineContext __attribute__((swift_name("coroutineContext")));
@property id<SPMCKtor_client_coreHttpRequest> request __attribute__((swift_name("request")));
@property SPMCKtor_client_coreHttpResponse *response __attribute__((swift_name("response")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpSendPipeline.Phases")))
@interface SPMCKtor_client_coreHttpSendPipelinePhases : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)phases __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_client_coreHttpSendPipelinePhases *shared __attribute__((swift_name("shared")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Before __attribute__((swift_name("Before")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Engine __attribute__((swift_name("Engine")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Monitoring __attribute__((swift_name("Monitoring")));
@property (readonly) SPMCKtor_utilsPipelinePhase *Receive __attribute__((swift_name("Receive")));
@property (readonly) SPMCKtor_utilsPipelinePhase *State __attribute__((swift_name("State")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpUrl")))
@interface SPMCKtor_httpUrl : SPMCBase
@property (class, readonly, getter=companion) SPMCKtor_httpUrlCompanion *companion __attribute__((swift_name("companion")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *encodedFragment __attribute__((swift_name("encodedFragment")));
@property (readonly) NSString * _Nullable encodedPassword __attribute__((swift_name("encodedPassword")));
@property (readonly) NSString *encodedPath __attribute__((swift_name("encodedPath")));
@property (readonly) NSString *encodedPathAndQuery __attribute__((swift_name("encodedPathAndQuery")));
@property (readonly) NSString *encodedQuery __attribute__((swift_name("encodedQuery")));
@property (readonly) NSString * _Nullable encodedUser __attribute__((swift_name("encodedUser")));
@property (readonly) NSString *fragment __attribute__((swift_name("fragment")));
@property (readonly) NSString *host __attribute__((swift_name("host")));
@property (readonly) id<SPMCKtor_httpParameters> parameters __attribute__((swift_name("parameters")));
@property (readonly) NSString * _Nullable password __attribute__((swift_name("password")));
@property (readonly) NSArray<NSString *> *pathSegments __attribute__((swift_name("pathSegments"))) __attribute__((deprecated("\n        `pathSegments` is deprecated.\n\n        This property will contain an empty path segment at the beginning for URLs with a hostname,\n        and an empty path segment at the end for the URLs with a trailing slash. If you need to keep this behaviour please\n        use [rawSegments]. If you only need to access the meaningful parts of the path, consider using [segments] instead.\n             \n        Please decide if you need [rawSegments] or [segments] explicitly.\n        ")));
@property (readonly) int32_t port __attribute__((swift_name("port")));
@property (readonly) SPMCKtor_httpURLProtocol *protocol __attribute__((swift_name("protocol")));
@property (readonly) SPMCKtor_httpURLProtocol * _Nullable protocolOrNull __attribute__((swift_name("protocolOrNull")));
@property (readonly) NSArray<NSString *> *rawSegments __attribute__((swift_name("rawSegments")));
@property (readonly) NSArray<NSString *> *segments __attribute__((swift_name("segments")));
@property (readonly) int32_t specifiedPort __attribute__((swift_name("specifiedPort")));
@property (readonly) BOOL trailingQuery __attribute__((swift_name("trailingQuery")));
@property (readonly) NSString * _Nullable user __attribute__((swift_name("user")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHttpMethod")))
@interface SPMCKtor_httpHttpMethod : SPMCBase
- (instancetype)initWithValue:(NSString *)value __attribute__((swift_name("init(value:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_httpHttpMethodCompanion *companion __attribute__((swift_name("companion")));
- (SPMCKtor_httpHttpMethod *)doCopyValue:(NSString *)value __attribute__((swift_name("doCopy(value:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((swift_name("Ktor_utilsStringValues")))
@protocol SPMCKtor_utilsStringValues
@required
- (BOOL)containsName:(NSString *)name __attribute__((swift_name("contains(name:)")));
- (BOOL)containsName:(NSString *)name value:(NSString *)value __attribute__((swift_name("contains(name:value:)")));
- (NSSet<id<SPMCKotlinMapEntry>> *)entries __attribute__((swift_name("entries()")));
- (void)forEachBody:(void (^)(NSString *, NSArray<NSString *> *))body __attribute__((swift_name("forEach(body:)")));
- (NSString * _Nullable)getName:(NSString *)name __attribute__((swift_name("get(name:)")));
- (NSArray<NSString *> * _Nullable)getAllName:(NSString *)name __attribute__((swift_name("getAll(name:)")));
- (BOOL)isEmpty_ __attribute__((swift_name("isEmpty()")));
- (NSSet<NSString *> *)names __attribute__((swift_name("names()")));
@property (readonly) BOOL caseInsensitiveName __attribute__((swift_name("caseInsensitiveName")));
@end

__attribute__((swift_name("Ktor_httpHeaders")))
@protocol SPMCKtor_httpHeaders <SPMCKtor_utilsStringValues>
@required
@end

__attribute__((swift_name("Ktor_httpOutgoingContent")))
@interface SPMCKtor_httpOutgoingContent : SPMCBase
- (id _Nullable)getPropertyKey:(SPMCKtor_utilsAttributeKey<id> *)key __attribute__((swift_name("getProperty(key:)")));
- (void)setPropertyKey:(SPMCKtor_utilsAttributeKey<id> *)key value:(id _Nullable)value __attribute__((swift_name("setProperty(key:value:)")));
- (id<SPMCKtor_httpHeaders> _Nullable)trailers __attribute__((swift_name("trailers()")));
@property (readonly) SPMCLong * _Nullable contentLength __attribute__((swift_name("contentLength")));
@property (readonly) SPMCKtor_httpContentType * _Nullable contentType __attribute__((swift_name("contentType")));
@property (readonly) id<SPMCKtor_httpHeaders> headers __attribute__((swift_name("headers")));
@property (readonly) SPMCKtor_httpHttpStatusCode * _Nullable status __attribute__((swift_name("status")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreJob")))
@protocol SPMCKotlinx_coroutines_coreJob <SPMCKotlinCoroutineContextElement>
@required

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
- (id<SPMCKotlinx_coroutines_coreChildHandle>)attachChildChild:(id<SPMCKotlinx_coroutines_coreChildJob>)child __attribute__((swift_name("attachChild(child:)")));
- (void)cancelCause:(SPMCKotlinCancellationException * _Nullable)cause __attribute__((swift_name("cancel(cause:)")));

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
- (SPMCKotlinCancellationException *)getCancellationException __attribute__((swift_name("getCancellationException()")));
- (id<SPMCKotlinx_coroutines_coreDisposableHandle>)invokeOnCompletionHandler:(void (^)(SPMCKotlinThrowable * _Nullable))handler __attribute__((swift_name("invokeOnCompletion(handler:)")));

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
- (id<SPMCKotlinx_coroutines_coreDisposableHandle>)invokeOnCompletionOnCancelling:(BOOL)onCancelling invokeImmediately:(BOOL)invokeImmediately handler:(void (^)(SPMCKotlinThrowable * _Nullable))handler __attribute__((swift_name("invokeOnCompletion(onCancelling:invokeImmediately:handler:)")));

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)joinWithCompletionHandler:(void (^)(NSError * _Nullable))completionHandler __attribute__((swift_name("join(completionHandler:)")));
- (id<SPMCKotlinx_coroutines_coreJob>)plusOther_:(id<SPMCKotlinx_coroutines_coreJob>)other __attribute__((swift_name("plus(other_:)"))) __attribute__((unavailable("Operator '+' on two Job objects is meaningless. Job is a coroutine context element and `+` is a set-sum operator for coroutine contexts. The job to the right of `+` just replaces the job the left of `+`.")));
- (BOOL)start __attribute__((swift_name("start()")));
@property (readonly) id<SPMCKotlinSequence> children __attribute__((swift_name("children")));
@property (readonly) BOOL isActive __attribute__((swift_name("isActive")));
@property (readonly) BOOL isCancelled __attribute__((swift_name("isCancelled")));
@property (readonly) BOOL isCompleted __attribute__((swift_name("isCompleted")));
@property (readonly) id<SPMCKotlinx_coroutines_coreSelectClause0> onJoin __attribute__((swift_name("onJoin")));

/**
 * @note annotations
 *   kotlinx.coroutines.ExperimentalCoroutinesApi
*/
@property (readonly) id<SPMCKotlinx_coroutines_coreJob> _Nullable parent __attribute__((swift_name("parent")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHttpStatusCode")))
@interface SPMCKtor_httpHttpStatusCode : SPMCBase <SPMCKotlinComparable>
- (instancetype)initWithValue:(int32_t)value description:(NSString *)description __attribute__((swift_name("init(value:description:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_httpHttpStatusCodeCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(SPMCKtor_httpHttpStatusCode *)other __attribute__((swift_name("compareTo(other:)")));
- (SPMCKtor_httpHttpStatusCode *)doCopyValue:(int32_t)value description:(NSString *)description __attribute__((swift_name("doCopy(value:description:)")));
- (SPMCKtor_httpHttpStatusCode *)descriptionValue:(NSString *)value __attribute__((swift_name("description(value:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *description_ __attribute__((swift_name("description_")));
@property (readonly) int32_t value __attribute__((swift_name("value")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsGMTDate")))
@interface SPMCKtor_utilsGMTDate : SPMCBase <SPMCKotlinComparable>
- (instancetype)initWithSeconds:(int32_t)seconds minutes:(int32_t)minutes hours:(int32_t)hours dayOfWeek:(SPMCKtor_utilsWeekDay *)dayOfWeek dayOfMonth:(int32_t)dayOfMonth dayOfYear:(int32_t)dayOfYear month:(SPMCKtor_utilsMonth *)month year:(int32_t)year timestamp:(int64_t)timestamp __attribute__((swift_name("init(seconds:minutes:hours:dayOfWeek:dayOfMonth:dayOfYear:month:year:timestamp:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_utilsGMTDateCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(SPMCKtor_utilsGMTDate *)other __attribute__((swift_name("compareTo(other:)")));
- (SPMCKtor_utilsGMTDate *)doCopy __attribute__((swift_name("doCopy()")));
- (SPMCKtor_utilsGMTDate *)doCopySeconds:(int32_t)seconds minutes:(int32_t)minutes hours:(int32_t)hours dayOfWeek:(SPMCKtor_utilsWeekDay *)dayOfWeek dayOfMonth:(int32_t)dayOfMonth dayOfYear:(int32_t)dayOfYear month:(SPMCKtor_utilsMonth *)month year:(int32_t)year timestamp:(int64_t)timestamp __attribute__((swift_name("doCopy(seconds:minutes:hours:dayOfWeek:dayOfMonth:dayOfYear:month:year:timestamp:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t dayOfMonth __attribute__((swift_name("dayOfMonth")));
@property (readonly) SPMCKtor_utilsWeekDay *dayOfWeek __attribute__((swift_name("dayOfWeek")));
@property (readonly) int32_t dayOfYear __attribute__((swift_name("dayOfYear")));
@property (readonly) int32_t hours __attribute__((swift_name("hours")));
@property (readonly) int32_t minutes __attribute__((swift_name("minutes")));
@property (readonly) SPMCKtor_utilsMonth *month __attribute__((swift_name("month")));
@property (readonly) int32_t seconds __attribute__((swift_name("seconds")));
@property (readonly) int64_t timestamp __attribute__((swift_name("timestamp")));
@property (readonly) int32_t year __attribute__((swift_name("year")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHttpProtocolVersion")))
@interface SPMCKtor_httpHttpProtocolVersion : SPMCBase
- (instancetype)initWithName:(NSString *)name major:(int32_t)major minor:(int32_t)minor __attribute__((swift_name("init(name:major:minor:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_httpHttpProtocolVersionCompanion *companion __attribute__((swift_name("companion")));
- (SPMCKtor_httpHttpProtocolVersion *)doCopyName:(NSString *)name major:(int32_t)major minor:(int32_t)minor __attribute__((swift_name("doCopy(name:major:minor:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t major __attribute__((swift_name("major")));
@property (readonly) int32_t minor __attribute__((swift_name("minor")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.3")
*/
__attribute__((swift_name("KotlinContinuation")))
@protocol SPMCKotlinContinuation
@required
- (void)resumeWithResult:(id _Nullable)result __attribute__((swift_name("resumeWith(result:)")));
@property (readonly) id<SPMCKotlinCoroutineContext> context __attribute__((swift_name("context")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.3")
 *   kotlin.ExperimentalStdlibApi
*/
__attribute__((swift_name("KotlinAbstractCoroutineContextKey")))
@interface SPMCKotlinAbstractCoroutineContextKey<B, E> : SPMCBase <SPMCKotlinCoroutineContextKey>
- (instancetype)initWithBaseKey:(id<SPMCKotlinCoroutineContextKey>)baseKey safeCast:(E _Nullable (^)(id<SPMCKotlinCoroutineContextElement>))safeCast __attribute__((swift_name("init(baseKey:safeCast:)"))) __attribute__((objc_designated_initializer));
@end


/**
 * @note annotations
 *   kotlin.ExperimentalStdlibApi
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_coroutines_coreCoroutineDispatcher.Key")))
@interface SPMCKotlinx_coroutines_coreCoroutineDispatcherKey : SPMCKotlinAbstractCoroutineContextKey<id<SPMCKotlinContinuationInterceptor>, SPMCKotlinx_coroutines_coreCoroutineDispatcher *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithBaseKey:(id<SPMCKotlinCoroutineContextKey>)baseKey safeCast:(id<SPMCKotlinCoroutineContextElement> _Nullable (^)(id<SPMCKotlinCoroutineContextElement>))safeCast __attribute__((swift_name("init(baseKey:safeCast:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)key __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinx_coroutines_coreCoroutineDispatcherKey *shared __attribute__((swift_name("shared")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreRunnable")))
@protocol SPMCKotlinx_coroutines_coreRunnable
@required
- (void)run __attribute__((swift_name("run()")));
@end

__attribute__((swift_name("KotlinAppendable")))
@protocol SPMCKotlinAppendable
@required
- (id<SPMCKotlinAppendable>)appendValue:(unichar)value __attribute__((swift_name("append(value:)")));
- (id<SPMCKotlinAppendable>)appendValue_:(id _Nullable)value __attribute__((swift_name("append(value_:)")));
- (id<SPMCKotlinAppendable>)appendValue:(id _Nullable)value startIndex:(int32_t)startIndex endIndex:(int32_t)endIndex __attribute__((swift_name("append(value:startIndex:endIndex:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_jsonClassDiscriminatorMode")))
@interface SPMCKotlinx_serialization_jsonClassDiscriminatorMode : SPMCKotlinEnum<SPMCKotlinx_serialization_jsonClassDiscriminatorMode *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) SPMCKotlinx_serialization_jsonClassDiscriminatorMode *none __attribute__((swift_name("none")));
@property (class, readonly) SPMCKotlinx_serialization_jsonClassDiscriminatorMode *allJsonObjects __attribute__((swift_name("allJsonObjects")));
@property (class, readonly) SPMCKotlinx_serialization_jsonClassDiscriminatorMode *polymorphic __attribute__((swift_name("polymorphic")));
+ (SPMCKotlinArray<SPMCKotlinx_serialization_jsonClassDiscriminatorMode *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCKotlinx_serialization_jsonClassDiscriminatorMode *> *entries __attribute__((swift_name("entries")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((swift_name("Kotlinx_serialization_jsonJsonNamingStrategy")))
@protocol SPMCKotlinx_serialization_jsonJsonNamingStrategy
@required
- (NSString *)serialNameForJsonDescriptor:(id<SPMCKotlinx_serialization_coreSerialDescriptor>)descriptor elementIndex:(int32_t)elementIndex serialName:(NSString *)serialName __attribute__((swift_name("serialNameForJson(descriptor:elementIndex:serialName:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsTypeInfo")))
@interface SPMCKtor_utilsTypeInfo : SPMCBase
- (instancetype)initWithType:(id<SPMCKotlinKClass>)type kotlinType:(id<SPMCKotlinKType> _Nullable)kotlinType __attribute__((swift_name("init(type:kotlinType:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithType:(id<SPMCKotlinKClass>)type reifiedType:(id<SPMCKotlinKType>)reifiedType kotlinType:(id<SPMCKotlinKType> _Nullable)kotlinType __attribute__((swift_name("init(type:reifiedType:kotlinType:)"))) __attribute__((objc_designated_initializer)) __attribute__((deprecated("Use constructor without reifiedType parameter.")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) id<SPMCKotlinKType> _Nullable kotlinType __attribute__((swift_name("kotlinType")));
@property (readonly) id<SPMCKotlinKClass> type __attribute__((swift_name("type")));
@end

__attribute__((swift_name("Ktor_ioByteReadChannel")))
@protocol SPMCKtor_ioByteReadChannel
@required

/**
 * @note This method converts instances of CancellationException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (void)awaitContentMin:(int32_t)min completionHandler:(void (^)(SPMCBoolean * _Nullable, NSError * _Nullable))completionHandler __attribute__((swift_name("awaitContent(min:completionHandler:)")));
- (void)cancelCause_:(SPMCKotlinThrowable * _Nullable)cause __attribute__((swift_name("cancel(cause_:)")));
@property (readonly) SPMCKotlinThrowable * _Nullable closedCause __attribute__((swift_name("closedCause")));
@property (readonly) BOOL isClosedForRead __attribute__((swift_name("isClosedForRead")));
@property (readonly) id<SPMCKotlinx_io_coreSource> readBuffer __attribute__((swift_name("readBuffer")));
@end

__attribute__((swift_name("Ktor_utilsStringValuesBuilder")))
@protocol SPMCKtor_utilsStringValuesBuilder
@required
- (void)appendName:(NSString *)name value:(NSString *)value __attribute__((swift_name("append(name:value:)")));
- (void)appendAllStringValues:(id<SPMCKtor_utilsStringValues>)stringValues __attribute__((swift_name("appendAll(stringValues:)")));
- (void)appendAllName:(NSString *)name values:(id)values __attribute__((swift_name("appendAll(name:values:)")));
- (void)appendMissingStringValues:(id<SPMCKtor_utilsStringValues>)stringValues __attribute__((swift_name("appendMissing(stringValues:)")));
- (void)appendMissingName:(NSString *)name values:(id)values __attribute__((swift_name("appendMissing(name:values:)")));
- (id<SPMCKtor_utilsStringValues>)build __attribute__((swift_name("build()")));
- (void)clear __attribute__((swift_name("clear()")));
- (BOOL)containsName:(NSString *)name __attribute__((swift_name("contains(name:)")));
- (BOOL)containsName:(NSString *)name value:(NSString *)value __attribute__((swift_name("contains(name:value:)")));
- (NSSet<id<SPMCKotlinMapEntry>> *)entries __attribute__((swift_name("entries()")));
- (NSString * _Nullable)getName:(NSString *)name __attribute__((swift_name("get(name:)")));
- (NSArray<NSString *> * _Nullable)getAllName:(NSString *)name __attribute__((swift_name("getAll(name:)")));
- (BOOL)isEmpty_ __attribute__((swift_name("isEmpty()")));
- (NSSet<NSString *> *)names __attribute__((swift_name("names()")));
- (void)removeName:(NSString *)name __attribute__((swift_name("remove(name:)")));
- (BOOL)removeName:(NSString *)name value:(NSString *)value __attribute__((swift_name("remove(name:value:)")));
- (void)removeKeysWithNoEntries __attribute__((swift_name("removeKeysWithNoEntries()")));
- (void)setName:(NSString *)name value:(NSString *)value __attribute__((swift_name("set(name:value:)")));
@property (readonly) BOOL caseInsensitiveName __attribute__((swift_name("caseInsensitiveName")));
@end

__attribute__((swift_name("Ktor_utilsStringValuesBuilderImpl")))
@interface SPMCKtor_utilsStringValuesBuilderImpl : SPMCBase <SPMCKtor_utilsStringValuesBuilder>
- (instancetype)initWithCaseInsensitiveName:(BOOL)caseInsensitiveName size:(int32_t)size __attribute__((swift_name("init(caseInsensitiveName:size:)"))) __attribute__((objc_designated_initializer));
- (void)appendName:(NSString *)name value:(NSString *)value __attribute__((swift_name("append(name:value:)")));
- (void)appendAllStringValues:(id<SPMCKtor_utilsStringValues>)stringValues __attribute__((swift_name("appendAll(stringValues:)")));
- (void)appendAllName:(NSString *)name values:(id)values __attribute__((swift_name("appendAll(name:values:)")));
- (void)appendMissingStringValues:(id<SPMCKtor_utilsStringValues>)stringValues __attribute__((swift_name("appendMissing(stringValues:)")));
- (void)appendMissingName:(NSString *)name values:(id)values __attribute__((swift_name("appendMissing(name:values:)")));
- (id<SPMCKtor_utilsStringValues>)build __attribute__((swift_name("build()")));
- (void)clear __attribute__((swift_name("clear()")));
- (BOOL)containsName:(NSString *)name __attribute__((swift_name("contains(name:)")));
- (BOOL)containsName:(NSString *)name value:(NSString *)value __attribute__((swift_name("contains(name:value:)")));
- (NSSet<id<SPMCKotlinMapEntry>> *)entries __attribute__((swift_name("entries()")));
- (NSString * _Nullable)getName:(NSString *)name __attribute__((swift_name("get(name:)")));
- (NSArray<NSString *> * _Nullable)getAllName:(NSString *)name __attribute__((swift_name("getAll(name:)")));
- (BOOL)isEmpty_ __attribute__((swift_name("isEmpty()")));
- (NSSet<NSString *> *)names __attribute__((swift_name("names()")));
- (void)removeName:(NSString *)name __attribute__((swift_name("remove(name:)")));
- (BOOL)removeName:(NSString *)name value:(NSString *)value __attribute__((swift_name("remove(name:value:)")));
- (void)removeKeysWithNoEntries __attribute__((swift_name("removeKeysWithNoEntries()")));
- (void)setName:(NSString *)name value:(NSString *)value __attribute__((swift_name("set(name:value:)")));

/**
 * @note This method has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
- (void)validateNameName:(NSString *)name __attribute__((swift_name("validateName(name:)")));

/**
 * @note This method has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
- (void)validateValueValue:(NSString *)value __attribute__((swift_name("validateValue(value:)")));
@property (readonly) BOOL caseInsensitiveName __attribute__((swift_name("caseInsensitiveName")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) SPMCMutableDictionary<NSString *, NSMutableArray<NSString *> *> *values __attribute__((swift_name("values")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHeadersBuilder")))
@interface SPMCKtor_httpHeadersBuilder : SPMCKtor_utilsStringValuesBuilderImpl
- (instancetype)initWithSize:(int32_t)size __attribute__((swift_name("init(size:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCaseInsensitiveName:(BOOL)caseInsensitiveName size:(int32_t)size __attribute__((swift_name("init(caseInsensitiveName:size:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (id<SPMCKtor_httpHeaders>)build __attribute__((swift_name("build()")));

/**
 * @note This method has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
- (void)validateNameName:(NSString *)name __attribute__((swift_name("validateName(name:)")));

/**
 * @note This method has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
- (void)validateValueValue:(NSString *)value __attribute__((swift_name("validateValue(value:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpRequestBuilder.Companion")))
@interface SPMCKtor_client_coreHttpRequestBuilderCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_client_coreHttpRequestBuilderCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpURLBuilder")))
@interface SPMCKtor_httpURLBuilder : SPMCBase
- (instancetype)initWithProtocol:(SPMCKtor_httpURLProtocol * _Nullable)protocol host:(NSString *)host port:(int32_t)port user:(NSString * _Nullable)user password:(NSString * _Nullable)password pathSegments:(NSArray<NSString *> *)pathSegments parameters:(id<SPMCKtor_httpParameters>)parameters fragment:(NSString *)fragment trailingQuery:(BOOL)trailingQuery __attribute__((swift_name("init(protocol:host:port:user:password:pathSegments:parameters:fragment:trailingQuery:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_httpURLBuilderCompanion *companion __attribute__((swift_name("companion")));
- (SPMCKtor_httpUrl *)build __attribute__((swift_name("build()")));
- (NSString *)buildString __attribute__((swift_name("buildString()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property NSString *encodedFragment __attribute__((swift_name("encodedFragment")));
@property id<SPMCKtor_httpParametersBuilder> encodedParameters __attribute__((swift_name("encodedParameters")));
@property NSString * _Nullable encodedPassword __attribute__((swift_name("encodedPassword")));
@property NSArray<NSString *> *encodedPathSegments __attribute__((swift_name("encodedPathSegments")));
@property NSString * _Nullable encodedUser __attribute__((swift_name("encodedUser")));
@property NSString *fragment __attribute__((swift_name("fragment")));
@property NSString *host __attribute__((swift_name("host")));
@property (readonly) id<SPMCKtor_httpParametersBuilder> parameters __attribute__((swift_name("parameters")));
@property NSString * _Nullable password __attribute__((swift_name("password")));
@property NSArray<NSString *> *pathSegments __attribute__((swift_name("pathSegments")));
@property int32_t port __attribute__((swift_name("port")));
@property SPMCKtor_httpURLProtocol *protocol __attribute__((swift_name("protocol")));
@property SPMCKtor_httpURLProtocol * _Nullable protocolOrNull __attribute__((swift_name("protocolOrNull")));
@property BOOL trailingQuery __attribute__((swift_name("trailingQuery")));
@property NSString * _Nullable user __attribute__((swift_name("user")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_client_coreHttpClientCall.Companion")))
@interface SPMCKtor_client_coreHttpClientCallCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_client_coreHttpClientCallCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((swift_name("Ktor_client_coreHttpRequest")))
@protocol SPMCKtor_client_coreHttpRequest <SPMCKtor_httpHttpMessage, SPMCKotlinx_coroutines_coreCoroutineScope>
@required
@property (readonly) id<SPMCKtor_utilsAttributes> attributes __attribute__((swift_name("attributes")));
@property (readonly) SPMCKtor_client_coreHttpClientCall *call __attribute__((swift_name("call")));
@property (readonly) SPMCKtor_httpOutgoingContent *content __attribute__((swift_name("content")));
@property (readonly) SPMCKtor_httpHttpMethod *method __attribute__((swift_name("method")));
@property (readonly) SPMCKtor_httpUrl *url __attribute__((swift_name("url")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpUrl.Companion")))
@interface SPMCKtor_httpUrlCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpUrlCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((swift_name("Ktor_httpParameters")))
@protocol SPMCKtor_httpParameters <SPMCKtor_utilsStringValues>
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpURLProtocol")))
@interface SPMCKtor_httpURLProtocol : SPMCBase
- (instancetype)initWithName:(NSString *)name defaultPort:(int32_t)defaultPort __attribute__((swift_name("init(name:defaultPort:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_httpURLProtocolCompanion *companion __attribute__((swift_name("companion")));
- (SPMCKtor_httpURLProtocol *)doCopyName:(NSString *)name defaultPort:(int32_t)defaultPort __attribute__((swift_name("doCopy(name:defaultPort:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t defaultPort __attribute__((swift_name("defaultPort")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHttpMethod.Companion")))
@interface SPMCKtor_httpHttpMethodCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpHttpMethodCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_httpHttpMethod *)parseMethod:(NSString *)method __attribute__((swift_name("parse(method:)")));
@property (readonly) NSArray<SPMCKtor_httpHttpMethod *> *DefaultMethods __attribute__((swift_name("DefaultMethods")));
@property (readonly) SPMCKtor_httpHttpMethod *Delete __attribute__((swift_name("Delete")));
@property (readonly) SPMCKtor_httpHttpMethod *Get __attribute__((swift_name("Get")));
@property (readonly) SPMCKtor_httpHttpMethod *Head __attribute__((swift_name("Head")));
@property (readonly) SPMCKtor_httpHttpMethod *Options __attribute__((swift_name("Options")));
@property (readonly) SPMCKtor_httpHttpMethod *Patch __attribute__((swift_name("Patch")));
@property (readonly) SPMCKtor_httpHttpMethod *Post __attribute__((swift_name("Post")));
@property (readonly) SPMCKtor_httpHttpMethod *Put __attribute__((swift_name("Put")));
@end

__attribute__((swift_name("KotlinMapEntry")))
@protocol SPMCKotlinMapEntry
@required
@property (readonly) id _Nullable key __attribute__((swift_name("key")));
@property (readonly) id _Nullable value __attribute__((swift_name("value")));
@end

__attribute__((swift_name("Ktor_httpHeaderValueWithParameters")))
@interface SPMCKtor_httpHeaderValueWithParameters : SPMCBase
- (instancetype)initWithContent:(NSString *)content parameters:(NSArray<SPMCKtor_httpHeaderValueParam *> *)parameters __attribute__((swift_name("init(content:parameters:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKtor_httpHeaderValueWithParametersCompanion *companion __attribute__((swift_name("companion")));
- (NSString * _Nullable)parameterName:(NSString *)name __attribute__((swift_name("parameter(name:)")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note This property has protected visibility in Kotlin source and is intended only for use by subclasses.
*/
@property (readonly) NSString *content __attribute__((swift_name("content")));
@property (readonly) NSArray<SPMCKtor_httpHeaderValueParam *> *parameters __attribute__((swift_name("parameters")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpContentType")))
@interface SPMCKtor_httpContentType : SPMCKtor_httpHeaderValueWithParameters
- (instancetype)initWithContentType:(NSString *)contentType contentSubtype:(NSString *)contentSubtype parameters:(NSArray<SPMCKtor_httpHeaderValueParam *> *)parameters __attribute__((swift_name("init(contentType:contentSubtype:parameters:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithContent:(NSString *)content parameters:(NSArray<SPMCKtor_httpHeaderValueParam *> *)parameters __attribute__((swift_name("init(content:parameters:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKtor_httpContentTypeCompanion *companion __attribute__((swift_name("companion")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (BOOL)matchPattern:(SPMCKtor_httpContentType *)pattern __attribute__((swift_name("match(pattern:)")));
- (BOOL)matchPattern_:(NSString *)pattern __attribute__((swift_name("match(pattern_:)")));
- (SPMCKtor_httpContentType *)withParameterName:(NSString *)name value:(NSString *)value __attribute__((swift_name("withParameter(name:value:)")));
- (SPMCKtor_httpContentType *)withoutParameters __attribute__((swift_name("withoutParameters()")));
@property (readonly) NSString *contentSubtype __attribute__((swift_name("contentSubtype")));
@property (readonly) NSString *contentType __attribute__((swift_name("contentType")));
@end


/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
__attribute__((swift_name("Kotlinx_coroutines_coreChildHandle")))
@protocol SPMCKotlinx_coroutines_coreChildHandle <SPMCKotlinx_coroutines_coreDisposableHandle>
@required

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
- (BOOL)childCancelledCause:(SPMCKotlinThrowable *)cause __attribute__((swift_name("childCancelled(cause:)")));

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
@property (readonly) id<SPMCKotlinx_coroutines_coreJob> _Nullable parent __attribute__((swift_name("parent")));
@end


/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
__attribute__((swift_name("Kotlinx_coroutines_coreChildJob")))
@protocol SPMCKotlinx_coroutines_coreChildJob <SPMCKotlinx_coroutines_coreJob>
@required

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
- (void)parentCancelledParentJob:(id<SPMCKotlinx_coroutines_coreParentJob>)parentJob __attribute__((swift_name("parentCancelled(parentJob:)")));
@end

__attribute__((swift_name("KotlinSequence")))
@protocol SPMCKotlinSequence
@required
- (id<SPMCKotlinIterator>)iterator __attribute__((swift_name("iterator()")));
@end


/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
__attribute__((swift_name("Kotlinx_coroutines_coreSelectClause")))
@protocol SPMCKotlinx_coroutines_coreSelectClause
@required
@property (readonly) id clauseObject __attribute__((swift_name("clauseObject")));
@property (readonly) SPMCKotlinUnit *(^(^ _Nullable onCancellationConstructor)(id<SPMCKotlinx_coroutines_coreSelectInstance>, id _Nullable, id _Nullable))(SPMCKotlinThrowable *, id _Nullable, id<SPMCKotlinCoroutineContext>) __attribute__((swift_name("onCancellationConstructor")));
@property (readonly) id _Nullable (^processResFunc)(id, id _Nullable, id _Nullable) __attribute__((swift_name("processResFunc")));
@property (readonly) void (^regFunc)(id, id<SPMCKotlinx_coroutines_coreSelectInstance>, id _Nullable) __attribute__((swift_name("regFunc")));
@end

__attribute__((swift_name("Kotlinx_coroutines_coreSelectClause0")))
@protocol SPMCKotlinx_coroutines_coreSelectClause0 <SPMCKotlinx_coroutines_coreSelectClause>
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHttpStatusCode.Companion")))
@interface SPMCKtor_httpHttpStatusCodeCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpHttpStatusCodeCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_httpHttpStatusCode *)fromValueValue:(int32_t)value __attribute__((swift_name("fromValue(value:)")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Accepted __attribute__((swift_name("Accepted")));
@property (readonly) SPMCKtor_httpHttpStatusCode *BadGateway __attribute__((swift_name("BadGateway")));
@property (readonly) SPMCKtor_httpHttpStatusCode *BadRequest __attribute__((swift_name("BadRequest")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Conflict __attribute__((swift_name("Conflict")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Continue __attribute__((swift_name("Continue")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Created __attribute__((swift_name("Created")));
@property (readonly) SPMCKtor_httpHttpStatusCode *ExpectationFailed __attribute__((swift_name("ExpectationFailed")));
@property (readonly) SPMCKtor_httpHttpStatusCode *FailedDependency __attribute__((swift_name("FailedDependency")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Forbidden __attribute__((swift_name("Forbidden")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Found __attribute__((swift_name("Found")));
@property (readonly) SPMCKtor_httpHttpStatusCode *GatewayTimeout __attribute__((swift_name("GatewayTimeout")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Gone __attribute__((swift_name("Gone")));
@property (readonly) SPMCKtor_httpHttpStatusCode *InsufficientStorage __attribute__((swift_name("InsufficientStorage")));
@property (readonly) SPMCKtor_httpHttpStatusCode *InternalServerError __attribute__((swift_name("InternalServerError")));
@property (readonly) SPMCKtor_httpHttpStatusCode *LengthRequired __attribute__((swift_name("LengthRequired")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Locked __attribute__((swift_name("Locked")));
@property (readonly) SPMCKtor_httpHttpStatusCode *MethodNotAllowed __attribute__((swift_name("MethodNotAllowed")));
@property (readonly) SPMCKtor_httpHttpStatusCode *MovedPermanently __attribute__((swift_name("MovedPermanently")));
@property (readonly) SPMCKtor_httpHttpStatusCode *MultiStatus __attribute__((swift_name("MultiStatus")));
@property (readonly) SPMCKtor_httpHttpStatusCode *MultipleChoices __attribute__((swift_name("MultipleChoices")));
@property (readonly) SPMCKtor_httpHttpStatusCode *NoContent __attribute__((swift_name("NoContent")));
@property (readonly) SPMCKtor_httpHttpStatusCode *NonAuthoritativeInformation __attribute__((swift_name("NonAuthoritativeInformation")));
@property (readonly) SPMCKtor_httpHttpStatusCode *NotAcceptable __attribute__((swift_name("NotAcceptable")));
@property (readonly) SPMCKtor_httpHttpStatusCode *NotFound __attribute__((swift_name("NotFound")));
@property (readonly) SPMCKtor_httpHttpStatusCode *NotImplemented __attribute__((swift_name("NotImplemented")));
@property (readonly) SPMCKtor_httpHttpStatusCode *NotModified __attribute__((swift_name("NotModified")));
@property (readonly) SPMCKtor_httpHttpStatusCode *OK __attribute__((swift_name("OK")));
@property (readonly) SPMCKtor_httpHttpStatusCode *PartialContent __attribute__((swift_name("PartialContent")));
@property (readonly) SPMCKtor_httpHttpStatusCode *PayloadTooLarge __attribute__((swift_name("PayloadTooLarge")));
@property (readonly) SPMCKtor_httpHttpStatusCode *PaymentRequired __attribute__((swift_name("PaymentRequired")));
@property (readonly) SPMCKtor_httpHttpStatusCode *PermanentRedirect __attribute__((swift_name("PermanentRedirect")));
@property (readonly) SPMCKtor_httpHttpStatusCode *PreconditionFailed __attribute__((swift_name("PreconditionFailed")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Processing __attribute__((swift_name("Processing")));
@property (readonly) SPMCKtor_httpHttpStatusCode *ProxyAuthenticationRequired __attribute__((swift_name("ProxyAuthenticationRequired")));
@property (readonly) SPMCKtor_httpHttpStatusCode *RequestHeaderFieldTooLarge __attribute__((swift_name("RequestHeaderFieldTooLarge")));
@property (readonly) SPMCKtor_httpHttpStatusCode *RequestTimeout __attribute__((swift_name("RequestTimeout")));
@property (readonly) SPMCKtor_httpHttpStatusCode *RequestURITooLong __attribute__((swift_name("RequestURITooLong")));
@property (readonly) SPMCKtor_httpHttpStatusCode *RequestedRangeNotSatisfiable __attribute__((swift_name("RequestedRangeNotSatisfiable")));
@property (readonly) SPMCKtor_httpHttpStatusCode *ResetContent __attribute__((swift_name("ResetContent")));
@property (readonly) SPMCKtor_httpHttpStatusCode *SeeOther __attribute__((swift_name("SeeOther")));
@property (readonly) SPMCKtor_httpHttpStatusCode *ServiceUnavailable __attribute__((swift_name("ServiceUnavailable")));
@property (readonly) SPMCKtor_httpHttpStatusCode *SwitchProxy __attribute__((swift_name("SwitchProxy")));
@property (readonly) SPMCKtor_httpHttpStatusCode *SwitchingProtocols __attribute__((swift_name("SwitchingProtocols")));
@property (readonly) SPMCKtor_httpHttpStatusCode *TemporaryRedirect __attribute__((swift_name("TemporaryRedirect")));
@property (readonly) SPMCKtor_httpHttpStatusCode *TooEarly __attribute__((swift_name("TooEarly")));
@property (readonly) SPMCKtor_httpHttpStatusCode *TooManyRequests __attribute__((swift_name("TooManyRequests")));
@property (readonly) SPMCKtor_httpHttpStatusCode *Unauthorized __attribute__((swift_name("Unauthorized")));
@property (readonly) SPMCKtor_httpHttpStatusCode *UnprocessableEntity __attribute__((swift_name("UnprocessableEntity")));
@property (readonly) SPMCKtor_httpHttpStatusCode *UnsupportedMediaType __attribute__((swift_name("UnsupportedMediaType")));
@property (readonly) SPMCKtor_httpHttpStatusCode *UpgradeRequired __attribute__((swift_name("UpgradeRequired")));
@property (readonly) SPMCKtor_httpHttpStatusCode *UseProxy __attribute__((swift_name("UseProxy")));
@property (readonly) SPMCKtor_httpHttpStatusCode *VariantAlsoNegotiates __attribute__((swift_name("VariantAlsoNegotiates")));
@property (readonly) SPMCKtor_httpHttpStatusCode *VersionNotSupported __attribute__((swift_name("VersionNotSupported")));
@property (readonly) NSArray<SPMCKtor_httpHttpStatusCode *> *allStatusCodes __attribute__((swift_name("allStatusCodes")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsWeekDay")))
@interface SPMCKtor_utilsWeekDay : SPMCKotlinEnum<SPMCKtor_utilsWeekDay *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKtor_utilsWeekDayCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCKtor_utilsWeekDay *monday __attribute__((swift_name("monday")));
@property (class, readonly) SPMCKtor_utilsWeekDay *tuesday __attribute__((swift_name("tuesday")));
@property (class, readonly) SPMCKtor_utilsWeekDay *wednesday __attribute__((swift_name("wednesday")));
@property (class, readonly) SPMCKtor_utilsWeekDay *thursday __attribute__((swift_name("thursday")));
@property (class, readonly) SPMCKtor_utilsWeekDay *friday __attribute__((swift_name("friday")));
@property (class, readonly) SPMCKtor_utilsWeekDay *saturday __attribute__((swift_name("saturday")));
@property (class, readonly) SPMCKtor_utilsWeekDay *sunday __attribute__((swift_name("sunday")));
+ (SPMCKotlinArray<SPMCKtor_utilsWeekDay *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCKtor_utilsWeekDay *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsMonth")))
@interface SPMCKtor_utilsMonth : SPMCKotlinEnum<SPMCKtor_utilsMonth *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly, getter=companion) SPMCKtor_utilsMonthCompanion *companion __attribute__((swift_name("companion")));
@property (class, readonly) SPMCKtor_utilsMonth *january __attribute__((swift_name("january")));
@property (class, readonly) SPMCKtor_utilsMonth *february __attribute__((swift_name("february")));
@property (class, readonly) SPMCKtor_utilsMonth *march __attribute__((swift_name("march")));
@property (class, readonly) SPMCKtor_utilsMonth *april __attribute__((swift_name("april")));
@property (class, readonly) SPMCKtor_utilsMonth *may __attribute__((swift_name("may")));
@property (class, readonly) SPMCKtor_utilsMonth *june __attribute__((swift_name("june")));
@property (class, readonly) SPMCKtor_utilsMonth *july __attribute__((swift_name("july")));
@property (class, readonly) SPMCKtor_utilsMonth *august __attribute__((swift_name("august")));
@property (class, readonly) SPMCKtor_utilsMonth *september __attribute__((swift_name("september")));
@property (class, readonly) SPMCKtor_utilsMonth *october __attribute__((swift_name("october")));
@property (class, readonly) SPMCKtor_utilsMonth *november __attribute__((swift_name("november")));
@property (class, readonly) SPMCKtor_utilsMonth *december __attribute__((swift_name("december")));
+ (SPMCKotlinArray<SPMCKtor_utilsMonth *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCKtor_utilsMonth *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsGMTDate.Companion")))
@interface SPMCKtor_utilsGMTDateCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_utilsGMTDateCompanion *shared __attribute__((swift_name("shared")));
- (id<SPMCKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@property (readonly) SPMCKtor_utilsGMTDate *START __attribute__((swift_name("START")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHttpProtocolVersion.Companion")))
@interface SPMCKtor_httpHttpProtocolVersionCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpHttpProtocolVersionCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_httpHttpProtocolVersion *)fromValueName:(NSString *)name major:(int32_t)major minor:(int32_t)minor __attribute__((swift_name("fromValue(name:major:minor:)")));
- (SPMCKtor_httpHttpProtocolVersion *)parseValue:(id)value __attribute__((swift_name("parse(value:)")));
@property (readonly) SPMCKtor_httpHttpProtocolVersion *HTTP_1_0 __attribute__((swift_name("HTTP_1_0")));
@property (readonly) SPMCKtor_httpHttpProtocolVersion *HTTP_1_1 __attribute__((swift_name("HTTP_1_1")));
@property (readonly) SPMCKtor_httpHttpProtocolVersion *HTTP_2_0 __attribute__((swift_name("HTTP_2_0")));
@property (readonly) SPMCKtor_httpHttpProtocolVersion *QUIC __attribute__((swift_name("QUIC")));
@property (readonly) SPMCKtor_httpHttpProtocolVersion *SPDY_3 __attribute__((swift_name("SPDY_3")));
@end

__attribute__((swift_name("KotlinKType")))
@protocol SPMCKotlinKType
@required

/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
@property (readonly) NSArray<SPMCKotlinKTypeProjection *> *arguments __attribute__((swift_name("arguments")));

/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
@property (readonly) id<SPMCKotlinKClassifier> _Nullable classifier __attribute__((swift_name("classifier")));
@property (readonly) BOOL isMarkedNullable __attribute__((swift_name("isMarkedNullable")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="2.0")
*/
__attribute__((swift_name("KotlinAutoCloseable")))
@protocol SPMCKotlinAutoCloseable
@required
- (void)close __attribute__((swift_name("close()")));
@end

__attribute__((swift_name("Kotlinx_io_coreRawSource")))
@protocol SPMCKotlinx_io_coreRawSource <SPMCKotlinAutoCloseable>
@required
- (int64_t)readAtMostToSink:(SPMCKotlinx_io_coreBuffer *)sink byteCount:(int64_t)byteCount __attribute__((swift_name("readAtMostTo(sink:byteCount:)")));
@end

__attribute__((swift_name("Kotlinx_io_coreSource")))
@protocol SPMCKotlinx_io_coreSource <SPMCKotlinx_io_coreRawSource>
@required
- (BOOL)exhausted __attribute__((swift_name("exhausted()")));
- (id<SPMCKotlinx_io_coreSource>)peek __attribute__((swift_name("peek()")));
- (int32_t)readAtMostToSink:(SPMCKotlinByteArray *)sink startIndex:(int32_t)startIndex endIndex:(int32_t)endIndex __attribute__((swift_name("readAtMostTo(sink:startIndex:endIndex:)")));
- (int8_t)readByte __attribute__((swift_name("readByte()")));
- (int32_t)readInt __attribute__((swift_name("readInt()")));
- (int64_t)readLong __attribute__((swift_name("readLong()")));
- (int16_t)readShort __attribute__((swift_name("readShort()")));
- (void)readToSink:(id<SPMCKotlinx_io_coreRawSink>)sink byteCount:(int64_t)byteCount __attribute__((swift_name("readTo(sink:byteCount:)")));
- (BOOL)requestByteCount:(int64_t)byteCount __attribute__((swift_name("request(byteCount:)")));
- (void)requireByteCount:(int64_t)byteCount __attribute__((swift_name("require(byteCount:)")));
- (void)skipByteCount:(int64_t)byteCount __attribute__((swift_name("skip(byteCount:)")));
- (int64_t)transferToSink:(id<SPMCKotlinx_io_coreRawSink>)sink __attribute__((swift_name("transferTo(sink:)")));

/**
 * @note annotations
 *   kotlinx.io.InternalIoApi
*/
@property (readonly) SPMCKotlinx_io_coreBuffer *buffer __attribute__((swift_name("buffer")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpURLBuilder.Companion")))
@interface SPMCKtor_httpURLBuilderCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpURLBuilderCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((swift_name("Ktor_httpParametersBuilder")))
@protocol SPMCKtor_httpParametersBuilder <SPMCKtor_utilsStringValuesBuilder>
@required
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpURLProtocol.Companion")))
@interface SPMCKtor_httpURLProtocolCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpURLProtocolCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_httpURLProtocol *)createOrDefaultName:(NSString *)name __attribute__((swift_name("createOrDefault(name:)")));
@property (readonly) SPMCKtor_httpURLProtocol *HTTP __attribute__((swift_name("HTTP")));
@property (readonly) SPMCKtor_httpURLProtocol *HTTPS __attribute__((swift_name("HTTPS")));
@property (readonly) SPMCKtor_httpURLProtocol *SOCKS __attribute__((swift_name("SOCKS")));
@property (readonly) SPMCKtor_httpURLProtocol *WS __attribute__((swift_name("WS")));
@property (readonly) SPMCKtor_httpURLProtocol *WSS __attribute__((swift_name("WSS")));
@property (readonly) NSDictionary<NSString *, SPMCKtor_httpURLProtocol *> *byName __attribute__((swift_name("byName")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHeaderValueParam")))
@interface SPMCKtor_httpHeaderValueParam : SPMCBase
- (instancetype)initWithName:(NSString *)name value:(NSString *)value __attribute__((swift_name("init(name:value:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithName:(NSString *)name value:(NSString *)value escapeValue:(BOOL)escapeValue __attribute__((swift_name("init(name:value:escapeValue:)"))) __attribute__((objc_designated_initializer));
- (SPMCKtor_httpHeaderValueParam *)doCopyName:(NSString *)name value:(NSString *)value escapeValue:(BOOL)escapeValue __attribute__((swift_name("doCopy(name:value:escapeValue:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL escapeValue __attribute__((swift_name("escapeValue")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpHeaderValueWithParameters.Companion")))
@interface SPMCKtor_httpHeaderValueWithParametersCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpHeaderValueWithParametersCompanion *shared __attribute__((swift_name("shared")));
- (id _Nullable)parseValue:(NSString *)value init:(id _Nullable (^)(NSString *, NSArray<SPMCKtor_httpHeaderValueParam *> *))init __attribute__((swift_name("parse(value:init:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_httpContentType.Companion")))
@interface SPMCKtor_httpContentTypeCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_httpContentTypeCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_httpContentType *)parseValue:(NSString *)value __attribute__((swift_name("parse(value:)")));
@property (readonly) SPMCKtor_httpContentType *Any __attribute__((swift_name("Any")));
@end


/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
__attribute__((swift_name("Kotlinx_coroutines_coreParentJob")))
@protocol SPMCKotlinx_coroutines_coreParentJob <SPMCKotlinx_coroutines_coreJob>
@required

/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
- (SPMCKotlinCancellationException *)getChildJobCancellationCause __attribute__((swift_name("getChildJobCancellationCause()")));
@end


/**
 * @note annotations
 *   kotlinx.coroutines.InternalCoroutinesApi
*/
__attribute__((swift_name("Kotlinx_coroutines_coreSelectInstance")))
@protocol SPMCKotlinx_coroutines_coreSelectInstance
@required
- (void)disposeOnCompletionDisposableHandle:(id<SPMCKotlinx_coroutines_coreDisposableHandle>)disposableHandle __attribute__((swift_name("disposeOnCompletion(disposableHandle:)")));
- (void)selectInRegistrationPhaseInternalResult:(id _Nullable)internalResult __attribute__((swift_name("selectInRegistrationPhase(internalResult:)")));
- (BOOL)trySelectClauseObject:(id)clauseObject result:(id _Nullable)result __attribute__((swift_name("trySelect(clauseObject:result:)")));
@property (readonly) id<SPMCKotlinCoroutineContext> context __attribute__((swift_name("context")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsWeekDay.Companion")))
@interface SPMCKtor_utilsWeekDayCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_utilsWeekDayCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_utilsWeekDay *)fromOrdinal:(int32_t)ordinal __attribute__((swift_name("from(ordinal:)")));
- (SPMCKtor_utilsWeekDay *)fromValue:(NSString *)value __attribute__((swift_name("from(value:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Ktor_utilsMonth.Companion")))
@interface SPMCKtor_utilsMonthCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKtor_utilsMonthCompanion *shared __attribute__((swift_name("shared")));
- (SPMCKtor_utilsMonth *)fromOrdinal:(int32_t)ordinal __attribute__((swift_name("from(ordinal:)")));
- (SPMCKtor_utilsMonth *)fromValue:(NSString *)value __attribute__((swift_name("from(value:)")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinKTypeProjection")))
@interface SPMCKotlinKTypeProjection : SPMCBase
- (instancetype)initWithVariance:(SPMCKotlinKVariance * _Nullable)variance type:(id<SPMCKotlinKType> _Nullable)type __attribute__((swift_name("init(variance:type:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) SPMCKotlinKTypeProjectionCompanion *companion __attribute__((swift_name("companion")));
- (SPMCKotlinKTypeProjection *)doCopyVariance:(SPMCKotlinKVariance * _Nullable)variance type:(id<SPMCKotlinKType> _Nullable)type __attribute__((swift_name("doCopy(variance:type:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) id<SPMCKotlinKType> _Nullable type __attribute__((swift_name("type")));
@property (readonly) SPMCKotlinKVariance * _Nullable variance __attribute__((swift_name("variance")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinByteArray")))
@interface SPMCKotlinByteArray : SPMCBase
+ (instancetype)arrayWithSize:(int32_t)size __attribute__((swift_name("init(size:)")));
+ (instancetype)arrayWithSize:(int32_t)size init:(SPMCByte *(^)(SPMCInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (int8_t)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (SPMCKotlinByteIterator *)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(int8_t)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((swift_name("Kotlinx_io_coreRawSink")))
@protocol SPMCKotlinx_io_coreRawSink <SPMCKotlinAutoCloseable>
@required
- (void)flush __attribute__((swift_name("flush()")));
- (void)writeSource:(SPMCKotlinx_io_coreBuffer *)source byteCount:(int64_t)byteCount __attribute__((swift_name("write(source:byteCount:)")));
@end

__attribute__((swift_name("Kotlinx_io_coreSink")))
@protocol SPMCKotlinx_io_coreSink <SPMCKotlinx_io_coreRawSink>
@required
- (void)emit __attribute__((swift_name("emit()")));

/**
 * @note annotations
 *   kotlinx.io.InternalIoApi
*/
- (void)hintEmit __attribute__((swift_name("hintEmit()")));
- (int64_t)transferFromSource:(id<SPMCKotlinx_io_coreRawSource>)source __attribute__((swift_name("transferFrom(source:)")));
- (void)writeSource:(id<SPMCKotlinx_io_coreRawSource>)source byteCount_:(int64_t)byteCount __attribute__((swift_name("write(source:byteCount_:)")));
- (void)writeSource:(SPMCKotlinByteArray *)source startIndex:(int32_t)startIndex endIndex:(int32_t)endIndex __attribute__((swift_name("write(source:startIndex:endIndex:)")));
- (void)writeByteByte:(int8_t)byte __attribute__((swift_name("writeByte(byte:)")));
- (void)writeIntInt:(int32_t)int_ __attribute__((swift_name("writeInt(int:)")));
- (void)writeLongLong:(int64_t)long_ __attribute__((swift_name("writeLong(long:)")));
- (void)writeShortShort:(int16_t)short_ __attribute__((swift_name("writeShort(short:)")));

/**
 * @note annotations
 *   kotlinx.io.InternalIoApi
*/
@property (readonly) SPMCKotlinx_io_coreBuffer *buffer __attribute__((swift_name("buffer")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_io_coreBuffer")))
@interface SPMCKotlinx_io_coreBuffer : SPMCBase <SPMCKotlinx_io_coreSource, SPMCKotlinx_io_coreSink>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)clear __attribute__((swift_name("clear()")));
- (void)close __attribute__((swift_name("close()")));
- (SPMCKotlinx_io_coreBuffer *)doCopy __attribute__((swift_name("doCopy()")));
- (void)doCopyToOut:(SPMCKotlinx_io_coreBuffer *)out startIndex:(int64_t)startIndex endIndex:(int64_t)endIndex __attribute__((swift_name("doCopyTo(out:startIndex:endIndex:)")));
- (void)emit __attribute__((swift_name("emit()")));
- (BOOL)exhausted __attribute__((swift_name("exhausted()")));
- (void)flush __attribute__((swift_name("flush()")));
- (int8_t)getPosition:(int64_t)position __attribute__((swift_name("get(position:)")));

/**
 * @note annotations
 *   kotlinx.io.InternalIoApi
*/
- (void)hintEmit __attribute__((swift_name("hintEmit()")));
- (id<SPMCKotlinx_io_coreSource>)peek __attribute__((swift_name("peek()")));
- (int64_t)readAtMostToSink:(SPMCKotlinx_io_coreBuffer *)sink byteCount:(int64_t)byteCount __attribute__((swift_name("readAtMostTo(sink:byteCount:)")));
- (int32_t)readAtMostToSink:(SPMCKotlinByteArray *)sink startIndex:(int32_t)startIndex endIndex:(int32_t)endIndex __attribute__((swift_name("readAtMostTo(sink:startIndex:endIndex:)")));
- (int8_t)readByte __attribute__((swift_name("readByte()")));
- (int32_t)readInt __attribute__((swift_name("readInt()")));
- (int64_t)readLong __attribute__((swift_name("readLong()")));
- (int16_t)readShort __attribute__((swift_name("readShort()")));
- (void)readToSink:(id<SPMCKotlinx_io_coreRawSink>)sink byteCount:(int64_t)byteCount __attribute__((swift_name("readTo(sink:byteCount:)")));
- (BOOL)requestByteCount:(int64_t)byteCount __attribute__((swift_name("request(byteCount:)")));
- (void)requireByteCount:(int64_t)byteCount __attribute__((swift_name("require(byteCount:)")));
- (void)skipByteCount:(int64_t)byteCount __attribute__((swift_name("skip(byteCount:)")));
- (NSString *)description __attribute__((swift_name("description()")));
- (int64_t)transferFromSource:(id<SPMCKotlinx_io_coreRawSource>)source __attribute__((swift_name("transferFrom(source:)")));
- (int64_t)transferToSink:(id<SPMCKotlinx_io_coreRawSink>)sink __attribute__((swift_name("transferTo(sink:)")));
- (void)writeSource:(SPMCKotlinx_io_coreBuffer *)source byteCount:(int64_t)byteCount __attribute__((swift_name("write(source:byteCount:)")));
- (void)writeSource:(id<SPMCKotlinx_io_coreRawSource>)source byteCount_:(int64_t)byteCount __attribute__((swift_name("write(source:byteCount_:)")));
- (void)writeSource:(SPMCKotlinByteArray *)source startIndex:(int32_t)startIndex endIndex:(int32_t)endIndex __attribute__((swift_name("write(source:startIndex:endIndex:)")));
- (void)writeByteByte:(int8_t)byte __attribute__((swift_name("writeByte(byte:)")));
- (void)writeIntInt:(int32_t)int_ __attribute__((swift_name("writeInt(int:)")));
- (void)writeLongLong:(int64_t)long_ __attribute__((swift_name("writeLong(long:)")));
- (void)writeShortShort:(int16_t)short_ __attribute__((swift_name("writeShort(short:)")));

/**
 * @note annotations
 *   kotlinx.io.InternalIoApi
*/
@property (readonly) SPMCKotlinx_io_coreBuffer *buffer __attribute__((swift_name("buffer")));
@property (readonly) int64_t size __attribute__((swift_name("size")));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinKVariance")))
@interface SPMCKotlinKVariance : SPMCKotlinEnum<SPMCKotlinKVariance *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) SPMCKotlinKVariance *invariant __attribute__((swift_name("invariant")));
@property (class, readonly) SPMCKotlinKVariance *in __attribute__((swift_name("in")));
@property (class, readonly) SPMCKotlinKVariance *out __attribute__((swift_name("out")));
+ (SPMCKotlinArray<SPMCKotlinKVariance *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<SPMCKotlinKVariance *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinKTypeProjection.Companion")))
@interface SPMCKotlinKTypeProjectionCompanion : SPMCBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) SPMCKotlinKTypeProjectionCompanion *shared __attribute__((swift_name("shared")));

/**
 * @note annotations
 *   kotlin.jvm.JvmStatic
*/
- (SPMCKotlinKTypeProjection *)contravariantType:(id<SPMCKotlinKType>)type __attribute__((swift_name("contravariant(type:)")));

/**
 * @note annotations
 *   kotlin.jvm.JvmStatic
*/
- (SPMCKotlinKTypeProjection *)covariantType:(id<SPMCKotlinKType>)type __attribute__((swift_name("covariant(type:)")));

/**
 * @note annotations
 *   kotlin.jvm.JvmStatic
*/
- (SPMCKotlinKTypeProjection *)invariantType:(id<SPMCKotlinKType>)type __attribute__((swift_name("invariant(type:)")));
@property (readonly) SPMCKotlinKTypeProjection *STAR __attribute__((swift_name("STAR")));
@end

__attribute__((swift_name("KotlinByteIterator")))
@interface SPMCKotlinByteIterator : SPMCBase <SPMCKotlinIterator>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (SPMCByte *)next __attribute__((swift_name("next()")));
- (int8_t)nextByte __attribute__((swift_name("nextByte()")));
@end

#pragma pop_macro("_Nullable_result")
#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
