# Claude Context: Didomi SDK Integration

## Overview

ConsentViewController is Sourcepoint's iOS SDK for privacy consents. Migrating to use Didomi SDK as the underlying CMP implementation.

**Didomi repo location:** `/Users/andreherculano/dev/didomi/ios`

## Architecture

### Wrapper Pattern

`SPDidomiConsentManager` wraps Didomi SDK:
- Initializes Didomi SDK
- Maps Didomi events → Sourcepoint delegate callbacks
- Converts Didomi consent data → Sourcepoint data structures

Main integration: `ConsentViewController/Classes/DidomiIntegration/SPDidomiConsentManager.swift`

### ID Mapping Problem

Vendors and Purposes have different IDs in Didomi vs Sourcepoint systems. Customers reference Sourcepoint IDs.

**Solution:** Didomi exposes Sourcepoint IDs via namespaces:
- `vendor.namespaces?.sp` - Sourcepoint vendor ID
- `purpose.namespaces?.sp` - Sourcepoint purpose ID

### Data Flow

```
Didomi SDK collects consent
    ↓
CurrentUserStatus (Didomi IDs)
    ↓
SPDidomiConsentManager.toSourcepoint()
  - Calls Didomi.shared.getVendor()/getPurpose()
  - Extracts namespaces.sp
  - Maps to Sourcepoint structures
    ↓
SPUserData (Sourcepoint IDs)
    ↓
SPDelegate callbacks (existing API preserved)
```

## Implementation

### Consent Mapping

Located in `DidomiUserStatus` extension in `SPDidomiConsentManager.swift`:

**GDPR:**
- Iterate Didomi vendors/purposes
- Look up full objects via `Didomi.shared.getVendor()/getPurpose()`
- Extract `namespaces.sp` for Sourcepoint ID
- Build `SPGDPRVendorGrants` with purpose-level granularity
- Populate accepted arrays (vendors, categories, legInt variants)

**CCPA:**
- Map rejected vendors/purposes using same lookup
- Calculate status (RejectedNone/Some/All)

### Key Structures

**Sourcepoint side:**
- `SPGDPRConsent` - Vendor grants, accepted arrays, TCF strings
- `SPGDPRVendorGrant` - Per-vendor purpose grants
- `SPCCPAConsent` - Rejected vendors/categories, status
- `SPUserData` - Top-level container

**Didomi side:**
- `CurrentUserStatus` - User consent state (Didomi IDs)
- `Vendor`/`Purpose` - Config objects with namespaces
- `Namespaces` - Contains `sp` field for ID mapping

## Changes to Didomi SDK

Added to support integration:
- `Purpose.namespaces` property (public API)
- `Purpose.Namespaces` class with `sp` field
- Internal mapper updates

## Dependencies

- `Didomi-XCFramework` v2.45.0 (needs update for namespace API)
- `SPMobileCore` v0.1.13

## Testing

Local development challenge: Can't point CocoaPods to Didomi source. Need XCFramework build or manual workspace linking.

## Key Files

- `SPDidomiConsentManager.swift` - Integration wrapper
- `SPGDPRConsent.swift` / `SPCCPAConsent.swift` - Sourcepoint data structures
- `SPUserData.swift` - Container for all consent types

## Current Branch

`CMP-6553_sp_integration_consent_migration`
