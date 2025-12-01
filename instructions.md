# API-Factory & QEC Instructions

> **Version:** 2.0.0  
> **Last Updated:** 2025-12-01  
> **Document Owner:** FUTUREWEALTHBOT, LLC  
> **Classification:** Internal Operations

---

## Table of Contents

- [1. QEP / QEC Command Usage](#1-qep--qec-command-usage)
  - [1.1 System Overview](#11-system-overview)
  - [1.2 Common Commands](#12-common-commands)
  - [1.3 Push Workflow](#13-push-workflow)
- [2. API-Factory Deployment & Operational SOP](#2-api-factory-deployment--operational-sop)
  - [2.1 Core Architecture](#21-core-architecture)
  - [2.2 Operational Checklist](#22-operational-checklist)
  - [2.3 Monitoring & Alerts](#23-monitoring--alerts)
- [3. Compliance & Security Instructions](#3-compliance--security-instructions)
  - [3.1 Governance & Audit](#31-governance--audit)
  - [3.2 Security Hardening Steps](#32-security-hardening-steps)
  - [3.3 Security Verification](#33-security-verification)
- [4. Financial / Monetization Operations](#4-financial--monetization-operations)
  - [4.1 Stripe Product Tiers](#41-stripe-product-tiers)
  - [4.2 Operational Steps](#42-operational-steps)
- [5. Corporate & Legal Instructions](#5-corporate--legal-instructions)
  - [5.1 Entity Compliance](#51-entity-compliance)
  - [5.2 Required Filings](#52-required-filings)
  - [5.3 Banking / Access](#53-banking--access)
- [6. References & Artifacts](#6-references--artifacts)
- [Appendix A: Artifact Tracking](#appendix-a-artifact-tracking)
- [Appendix B: Changelog](#appendix-b-changelog)

---

## 1. QEP / QEC Command Usage

### 1.1 System Overview

<details>
<summary><strong>Click to expand System Overview</strong></summary>

| Component | Description |
|-----------|-------------|
| **QEP** | Command-driven automation mentor framework (FutureWealthBot) |
| **QEC** | Compliance enforcement and policy management |
| **Integration** | QEP commands trigger QEC pushes to enforce policies and update artifacts |

**Architecture Diagram:**

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│     QEP     │ ───▶ │     QEC     │ ───▶ │  Production │
│  (Commands) │      │  (Policies) │      │  (Deployed) │
└─────────────┘      └─────────────┘      └─────────────┘
```

</details>

### 1.2 Common Commands

<details>
<summary><strong>Click to expand Common Commands</strong></summary>

#### Gmail Polling Setup

```bash
# Enable polling for inbox
CONNECT.GMAIL --scope inbox --alias API.LIVE
POLLING.ENABLE --channel API.LIVE --interval 60s
```

#### Policy Push Command

```bash
# Push policies and artifacts to production simulation
APIF QEP QEC PUSH --all
```

#### Command Reference Table

| Command | Description | Parameters |
|---------|-------------|------------|
| `CONNECT.GMAIL` | Establish Gmail connection | `--scope`, `--alias` |
| `POLLING.ENABLE` | Enable polling for channel | `--channel`, `--interval` |
| `APIF QEP QEC PUSH` | Push artifacts to production | `--all`, `--selective` |
| `QEC VALIDATE` | Validate policy compliance | `--pack`, `--target` |
| `QEC AUDIT` | Generate audit report | `--from`, `--to`, `--format` |

</details>

### 1.3 Push Workflow

<details>
<summary><strong>Click to expand Push Workflow</strong></summary>

#### Prerequisites

1. Ensure all artifacts are up-to-date in sandbox:
   - `finance-ledger-bundle.zip`
   - Policy packs: `qec_policy_pack_finance_os_v2.txt`

2. Verify artifact integrity before push

#### Execution Steps

1. Execute QEC PUSH command:
   ```bash
   APIF QEP QEC PUSH --all
   ```

2. Confirm receipt via push log:
   ```json
   {
     "status": "PUSHED",
     "timestamp": "2025-12-01T09:00:00Z",
     "artifacts": [
       {"name": "finance-ledger-bundle.zip", "sha256": "a1b2c3d4..."},
       {"name": "qec_policy_pack_finance_os_v2.txt", "sha256": "e5f6g7h8..."}
     ],
     "version": "2.0.0"
   }
   ```

#### Push Workflow Diagram

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Validate   │───▶│   Package    │───▶│    Push      │───▶│   Verify     │
│   Artifacts  │    │   Bundle     │    │   to Prod    │    │   Receipt    │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
```

</details>

---

## 2. API-Factory Deployment & Operational SOP

### 2.1 Core Architecture

<details>
<summary><strong>Click to expand Core Architecture</strong></summary>

| Layer | Technology | Purpose |
|-------|------------|---------|
| **API** | Fastify REST API | Typed schemas, state machines, adapter interfaces |
| **Multi-tenant** | Row-Level Security (RLS) | Tenant isolation and data segregation |
| **Backend** | Supabase | Database, authentication, storage |
| **Deployment** | Vercel | Edge/web deployment |
| **Security** | Cloudflare | DNS, WAF, DDoS protection |

#### Architecture Stack

```
┌─────────────────────────────────────────────────────────────┐
│                      Cloudflare (DNS/WAF)                   │
├─────────────────────────────────────────────────────────────┤
│                      Vercel (Edge/Web)                      │
├─────────────────────────────────────────────────────────────┤
│                   Fastify REST API (Typed)                  │
├─────────────────────────────────────────────────────────────┤
│              Supabase (DB/Auth/Storage + RLS)               │
└─────────────────────────────────────────────────────────────┘
```

</details>

### 2.2 Operational Checklist

<details>
<summary><strong>Click to expand Operational Checklist</strong></summary>

#### Pre-Deployment Checklist

- [ ] Validate backend endpoints
- [ ] Verify orchestration flows
- [ ] Confirm SDK CI pipelines
- [ ] Test admin portal dashboards
- [ ] Verify monetization integration

#### Endpoint Validation

| Endpoint | Method | Expected Response |
|----------|--------|-------------------|
| `/api/healthz` | GET | `200 OK` |
| `/api/v1/hello/ping` | GET | `{"pong": true}` |
| `/api/v1/hello/echo` | POST | Echo request body |

#### Integration Checklist

| Component | Status | Owner |
|-----------|--------|-------|
| Make.com scenarios | ☐ | DevOps |
| TypeScript SDK CI | ☐ | Engineering |
| Python SDK CI | ☐ | Engineering |
| Go SDK CI | ☐ | Engineering |
| Admin portal dashboards | ☐ | Product |
| API key management | ☐ | Security |
| Stripe billing enforcement | ☐ | Finance |

</details>

### 2.3 Monitoring & Alerts

<details>
<summary><strong>Click to expand Monitoring & Alerts</strong></summary>

#### Alert Channels

| Channel | Purpose | Priority |
|---------|---------|----------|
| Telegram | Real-time financial events | Critical |
| Supabase | Compliance breach alerts | High |
| Email | Daily summary reports | Normal |

#### Logging Requirements

- All financial transactions must be logged
- Compliance events require immutable audit trail
- Performance metrics collected every 60 seconds

#### Alert Thresholds

| Metric | Warning | Critical |
|--------|---------|----------|
| API Response Time | > 500ms | > 2000ms |
| Error Rate | > 1% | > 5% |
| Transaction Failures | > 0.1% | > 1% |

</details>

---

## 3. Compliance & Security Instructions

### 3.1 Governance & Audit

<details>
<summary><strong>Click to expand Governance & Audit</strong></summary>

#### Policy Management

- Maintain Policy Packs and Audit Trails
- Ensure all versions are traceable and immutable
- Regular compliance reviews (quarterly minimum)

#### Compliance Matrix

| Regulation | Applicability | Review Frequency |
|------------|---------------|------------------|
| FTC | Consumer protection | Quarterly |
| SEC | Securities compliance | Quarterly |
| HIPAA | Health data (if applicable) | Annual |
| FinCEN | Financial crimes | Monthly |
| CCPA | California privacy | Annual |
| SOC 2 | Security controls | Annual |

#### Audit Trail Requirements

- All policy changes must be versioned
- Audit logs retained for 7 years minimum
- Immutable storage for compliance records

</details>

### 3.2 Security Hardening Steps

<details>
<summary><strong>Click to expand Security Hardening Steps</strong></summary>

#### Critical Security Tasks

| Priority | Task | Frequency |
|----------|------|-----------|
| P0 | Rotate Stripe & Mercury secrets | 90 days |
| P0 | Enforce idempotency on Finance-OS rails | Continuous |
| P1 | Apply admin IP allow-listing | On change |
| P1 | Enable WAF with SQLi/XSS L7 filters | Continuous |
| P2 | Move audit logs to immutable storage | Weekly |

#### Secret Rotation Schedule

| Secret Type | Rotation Period | Last Rotated | Next Due |
|-------------|-----------------|--------------|----------|
| Stripe API Keys | 90 days | TBD | TBD |
| Mercury API Keys | 90 days | TBD | TBD |
| Supabase Keys | 180 days | TBD | TBD |
| JWT Signing Keys | 365 days | TBD | TBD |

#### WAF Configuration

```yaml
waf_rules:
  - name: SQLi Protection
    enabled: true
    action: block
  - name: XSS Protection
    enabled: true
    action: block
  - name: Rate Limiting
    enabled: true
    threshold: 1000/min
```

</details>

### 3.3 Security Verification

<details>
<summary><strong>Click to expand Security Verification</strong></summary>

#### Periodic Security Tasks

- [ ] Penetration testing simulation (quarterly)
- [ ] Tenant isolation validation (monthly)
- [ ] TLS 1.3 configuration verification (monthly)
- [ ] HSTS and CSP header validation (weekly)

#### Security Configuration Checklist

| Configuration | Required Setting | Verified |
|---------------|------------------|----------|
| TLS Version | 1.3 | ☐ |
| HSTS | Enabled, max-age=31536000 | ☐ |
| CSP | Strict policy | ☐ |
| X-Frame-Options | DENY | ☐ |
| X-Content-Type-Options | nosniff | ☐ |

#### Zero-Trust Validation

- Verify tenant isolation boundaries
- Confirm least-privilege access controls
- Validate service-to-service authentication

</details>

---

## 4. Financial / Monetization Operations

### 4.1 Stripe Product Tiers

<details>
<summary><strong>Click to expand Stripe Product Tiers</strong></summary>

| Tier | Product | Pricing Model | Target Customer |
|------|---------|---------------|-----------------|
| **Gold** | Compliance Copilot | Tiered usage pricing | SMB |
| **Platinum** | Finance-OS v2 Rails | Graduated tiered pricing | Mid-market |
| **Enterprise** | Arbitrage Engine Premium | Per-unit pricing | Enterprise |

#### Pricing Structure

```
Gold (Compliance Copilot):
├── Tier 1: 0-1,000 requests    → $0.01/request
├── Tier 2: 1,001-10,000        → $0.008/request
└── Tier 3: 10,001+             → $0.005/request

Platinum (Finance-OS v2 Rails):
├── Tier 1: 0-5,000 transactions → $0.05/transaction
├── Tier 2: 5,001-50,000         → $0.04/transaction
└── Tier 3: 50,001+              → $0.03/transaction

Enterprise (Arbitrage Engine Premium):
└── Custom per-unit pricing based on volume
```

</details>

### 4.2 Operational Steps

<details>
<summary><strong>Click to expand Operational Steps</strong></summary>

#### Pre-Launch Checklist

- [ ] Confirm product configuration in Stripe
- [ ] Integrate usage tracking for all APIs
- [ ] Validate ledger consistency and no drift
- [ ] Ensure ACH/Wire adapters are functional

#### Financial Operations Verification

| Operation | Status | Last Verified |
|-----------|--------|---------------|
| Stripe product sync | ☐ | TBD |
| Usage metering | ☐ | TBD |
| Ledger reconciliation | ☐ | TBD |
| ACH adapter | ☐ | TBD |
| Wire adapter | ☐ | TBD |

#### Reconciliation Process

1. Daily: Automated ledger sync
2. Weekly: Manual reconciliation review
3. Monthly: Full audit report generation

</details>

---

## 5. Corporate & Legal Instructions

### 5.1 Entity Compliance

<details>
<summary><strong>Click to expand Entity Compliance</strong></summary>

| Field | Value |
|-------|-------|
| **Legal Name** | FUTUREWEALTHBOT, LLC |
| **Manager** | Amihud Pierce |
| **Jurisdiction** | California (LLC) |
| **EIN** | 39-3590857 |
| **Principal Address** | 5080 Camino Del Arroyo, San Diego, CA 92108 |
| **Formation Date** | TBD |
| **Status** | Active |

</details>

### 5.2 Required Filings

<details>
<summary><strong>Click to expand Required Filings</strong></summary>

#### Filing Schedule

| Filing | Authority | Due Date | Frequency |
|--------|-----------|----------|-----------|
| Statement of Information | CA Secretary of State | 90 days from formation, then biennially | Every 2 years |
| Membership Listing Statement | Registered Agent | On change | As needed |
| IRS Form 8822-B | IRS | Upon address change | As needed |
| Annual Tax Return | FTB | 15th day of 4th month | Annually |

#### Compliance Calendar

- [ ] Statement of Information due within 90 days of formation
- [ ] Biennial Statement of Information thereafter
- [ ] Maintain Membership Listing Statement current at registered agent office
- [ ] File IRS Form 8822-B upon address changes

</details>

### 5.3 Banking / Access

<details>
<summary><strong>Click to expand Banking / Access</strong></summary>

#### Security Protocols

> ⚠️ **CRITICAL SECURITY NOTICE**

- Mercury business account 2FA backup codes stored **offline only**
- **Never** share 2FA codes or store them in cloud drives
- Limit banking access to authorized signatories only

#### Access Control Matrix

| Role | Mercury View | Mercury Transfer | Stripe Admin |
|------|--------------|------------------|--------------|
| Manager | ✓ | ✓ | ✓ |
| Finance Lead | ✓ | ✓ | ✓ |
| Developer | ✗ | ✗ | Read-only |

</details>

---

## 6. References & Artifacts

<details>
<summary><strong>Click to expand References & Artifacts</strong></summary>

### Core Documentation

| Document | Version | Description |
|----------|---------|-------------|
| `QEC_System_Report_v11.11.25.pdf` | 11.11.25 | QEC system architecture and status |
| `api-factory-audit-v2.8.pdf` | 2.8 | API Factory security audit |
| `APIF_Security_Executive_Brief_Branded.pdf` | 1.0 | Executive security summary |
| `FUTUREWEALTHBOT_Compliance_Binder.pdf` | 1.0 | Compliance documentation |
| `stripe_products.json` | 2.0 | Stripe product configuration |

### Quick Links

- [QEP Commands](#12-common-commands)
- [Security Hardening](#32-security-hardening-steps)
- [Compliance Matrix](#31-governance--audit)
- [Stripe Products](#41-stripe-product-tiers)

</details>

---

## Appendix A: Artifact Tracking

### Artifact Registry

| Artifact Name | Version | SHA256 Hash | Status | Last Updated |
|---------------|---------|-------------|--------|--------------|
| `finance-ledger-bundle.zip` | 2.0.0 | `TBD` | Production | 2025-12-01 |
| `qec_policy_pack_finance_os_v2.txt` | 2.0.0 | `TBD` | Production | 2025-12-01 |
| `QEC_System_Report_v11.11.25.pdf` | 11.11.25 | `TBD` | Released | 2025-11-25 |
| `api-factory-audit-v2.8.pdf` | 2.8 | `TBD` | Released | 2025-11-20 |
| `APIF_Security_Executive_Brief_Branded.pdf` | 1.0 | `TBD` | Released | 2025-11-15 |
| `FUTUREWEALTHBOT_Compliance_Binder.pdf` | 1.0 | `TBD` | Released | 2025-11-10 |
| `stripe_products.json` | 2.0 | `TBD` | Production | 2025-12-01 |

### Artifact Status Definitions

| Status | Description |
|--------|-------------|
| **Draft** | In development, not ready for review |
| **Review** | Under review, pending approval |
| **Released** | Approved and available for use |
| **Production** | Deployed to production environment |
| **Deprecated** | Superseded by newer version |
| **Archived** | No longer in active use |

---

## Appendix B: Changelog

### Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 2.0.0 | 2025-12-01 | System | Initial comprehensive documentation with collapsible sections, tables, and internal links |
| 1.0.0 | 2025-11-01 | System | Initial draft |

### Change Categories

- **[ADDED]** - New features or documentation
- **[CHANGED]** - Updates to existing content
- **[DEPRECATED]** - Features marked for removal
- **[REMOVED]** - Deleted content
- **[FIXED]** - Bug fixes or corrections
- **[SECURITY]** - Security-related updates

---

## Future Extensions

<details>
<summary><strong>Click to expand planned extensions</strong></summary>

This document can be extended with:

- [ ] Step-by-step deployment pipelines
- [ ] Detailed Make.com automation scenarios
- [ ] QEC rule definitions per business domain
- [ ] API endpoint and schema reference tables
- [ ] Integration testing procedures
- [ ] Disaster recovery procedures
- [ ] Incident response playbooks

</details>

---

<div align="center">

**FUTUREWEALTHBOT, LLC** | **Confidential - Internal Use Only**

*For questions or updates, contact the document owner.*

</div>
