# RHOAI Architecture Documentation Index (Mermaid Version)

> This directory contains mermaid-enhanced versions of the architecture documentation from [`documentation/`](../../documentation/), using interactive Mermaid diagrams instead of static images.

## 📚 Main Architecture Documents

### [Architecture Overview](./ARCHITECTURE-OVERVIEW.md)
Complete RHOAI v2.13 architecture overview with embedded Mermaid diagrams.

**Replaces**: [`documentation/arch-overview.md`](../../documentation/arch-overview.md)

**Key Diagrams**:
- [RHOAI Components Overview](../rhoai-components-overview.md)
- [Platform Architecture](../platform-architecture-overview.md)
- [Dashboard Feature Flags](../dashboard-feature-flags.md)
- [Data Science Pipelines v2](../dsp-v2-architecture.md)
- [Model Registry Overview](../model-registry-overview.md)
- [TrustyAI Architecture](../trustyai-explainability-architecture.md)

### [Platform Architecture](./PLATFORM-ARCHITECTURE.md)
ODH Operator and platform component details.

**Replaces**: [`documentation/components/platform/README.md`](../../documentation/components/platform/README.md)

**Key Diagrams**:
- [Platform Architecture Overview](../platform-architecture-overview.md)
- [ODH Operator Current Architecture](../odh-operator-current-architecture.md)
- [ODH Operator Next Architecture](../odh-operator-next-architecture.md)

## 🎯 Component Architecture

### Dashboard
**Original Docs**: [`documentation/components/dashboard/README.md`](../../documentation/components/dashboard/README.md)
**Mermaid Version**: [Dashboard Architecture](./components/DASHBOARD.md)

**Mermaid Diagrams**:
- [Dashboard Feature Flags](../dashboard-feature-flags.md)

**Key Topics**:
- User authentication and OAuth proxy flow
- K8s API vs REST API based features
- Feature flag system with 2-minute cache
- Dashboard CRDs and configuration
- User access and permissions model

### Model Serving
**Original Docs**: [`documentation/components/serving/README.md`](../../documentation/components/serving/README.md)
**Mermaid Version**: [Model Serving Architecture](./components/MODEL-SERVING.md)

**Mermaid Diagrams**:
- [KServe Private Network (mTLS)](../kserve-private-network-in-cluster.md)
- [KServe Autogen SNI Gateways](../kserve-autogen-sni-gateways.md)

**Key Topics**:
- KServe single model serving
- ModelMesh multi-model serving
- Network architecture with Service Mesh
- ODH Model Controller integration

### Data Science Pipelines
**Original Docs**: [`documentation/components/pipelines/README.md`](../../documentation/components/pipelines/README.md)
**Mermaid Version**: [Pipelines Architecture](./components/PIPELINES.md)

**Mermaid Diagrams**:
- [DSP v2 Architecture](../dsp-v2-architecture.md)

**Key Topics**:
- Control plane (DSPO) vs data plane (DSP Stack)
- Kubeflow Pipelines v2
- Argo Workflows integration
- DSPA custom resource configuration

### Model Registry
**Original Docs**: [`documentation/components/model-registry/README.md`](../../documentation/components/model-registry/README.md)
**Mermaid Version**: [Model Registry Architecture](./components/MODEL-REGISTRY.md)

**Mermaid Diagrams**:
- [Model Registry Overview](../model-registry-overview.md)

**Key Topics**:
- ML lifecycle metadata management
- ML-Metadata server and REST API
- Integration with model serving
- RBAC and tenancy

### TrustyAI / Explainability
**Original Docs**: [`documentation/components/explainability/README.md`](../../documentation/components/explainability/README.md)
**Mermaid Version**: [TrustyAI Architecture](./components/TRUSTYAI.md)

**Mermaid Diagrams**:
- [TrustyAI Architecture](../trustyai-explainability-architecture.md)

**Key Topics**:
- TrustyAI service operator
- ModelMesh and KServe payload logging
- Fairness metrics and explainability
- Authentication with OAuth proxy

### Workbenches
**Original Docs**: [`documentation/components/workbenches/README.md`](../../documentation/components/workbenches/README.md)

**Related Images** (no Mermaid conversion yet):
- High-level workbench architecture
- Notebook controller flow
- ImageStream configurations

### Feature Store
**Original Docs**: [`documentation/components/feature_store/README.md`](../../documentation/components/feature_store/README.md)

**Related Images** (no Mermaid conversion yet):
- Feature store overview

## 📊 All Available Mermaid Diagrams

| Diagram | Description | Original Image |
|---------|-------------|----------------|
| [rhoai-components-overview.md](../rhoai-components-overview.md) | RHOAI v2.13 component architecture | `RHOAI Architecture-Overview.drawio.png` |
| [platform-architecture-overview.md](../platform-architecture-overview.md) | Platform and operator architecture | `Platform Architecture Overview.png` |
| [odh-operator-current-architecture.md](../odh-operator-current-architecture.md) | Current operator internal API | `odh-operator-current.png` |
| [odh-operator-next-architecture.md](../odh-operator-next-architecture.md) | Proposed operator architecture | `odh-operator-next.png` |
| [dashboard-feature-flags.md](../dashboard-feature-flags.md) | Dashboard feature flag system | `featureFlags.png` |
| [kserve-private-network-in-cluster.md](../kserve-private-network-in-cluster.md) | KServe mTLS network | `ODH-ADR-MS-0001-...-img-1.png` |
| [kserve-autogen-sni-gateways.md](../kserve-autogen-sni-gateways.md) | KServe HTTPS autogen SNI | `ODH-ADR-MS-0001-...-img-2.png` |
| [dsp-v2-architecture.md](../dsp-v2-architecture.md) | Data Science Pipelines v2 | `dsp-v2-architecture.drawio.png` |
| [model-registry-overview.md](../model-registry-overview.md) | Model Registry overview | `model-registry-overview.jpg` |
| [trustyai-explainability-architecture.md](../trustyai-explainability-architecture.md) | TrustyAI service architecture | `diagram.png` |

## 🔄 Image to Mermaid Mapping

### Images with Mermaid Equivalents

The following original images have been converted to Mermaid diagrams:

```
documentation/images/
├── RHOAI Architecture-Overview.drawio.png → rhoai-components-overview.md
├── RHOAI Architecture - D1 - Operator.png → (partial: operator diagrams)
├── RHOAI Architecture - D2 - DSP.png → dsp-v2-architecture.md
├── RHOAI Architecture - D4 - Dashboard.png → (partial: dashboard-feature-flags.md)
├── RHOAI Architecture - D7 - Trusty.png → trustyai-explainability-architecture.md
└── RHOAI Architecture - D9 - Feature Store.png → (partial: model-registry-overview.md)

documentation/components/
├── platform/Platform Architecture Overview.png → platform-architecture-overview.md
├── dashboard/assets/featureFlags.png → dashboard-feature-flags.md
├── pipelines/dsp-v2-architecture.drawio.png → dsp-v2-architecture.md
├── model-registry/images/model-registry-overview.jpg → model-registry-overview.md
├── explainability/diagram.png → trustyai-explainability-architecture.md
└── serving/... → kserve diagrams

architecture-decision-records/operator/assets/
├── odh-operator-current.png → odh-operator-current-architecture.md
└── odh-operator-next.png → odh-operator-next-architecture.md

architecture-decision-records/model-serving/images/
├── ODH-ADR-MS-0001-...-img-1.png → kserve-private-network-in-cluster.md
└── ODH-ADR-MS-0001-...-img-2.png → kserve-autogen-sni-gateways.md
```

### Images Without Mermaid Conversions (Yet)

These images are still referenced as static images:

- `RHOAI Architecture - D3 - Workbenches.png`
- `RHOAI Architecture - D5 - Distr Workloads.png`
- `RHOAI Architecture - D6a/b/c - Model Serving.png`
- Network diagrams in `documentation/images/network/`

## 🎨 Using This Documentation

### For Reading

1. Start with [Architecture Overview](./ARCHITECTURE-OVERVIEW.md) for the big picture
2. Dive into specific components via links above
3. Click through to individual Mermaid diagrams for interactive viewing

### For Contributing

1. See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines
2. Use Mermaid syntax for new diagrams
3. Test with validation script before committing
4. Link from documentation to diagrams

### For Developers

**Benefits of Mermaid Diagrams**:
- ✅ Version controlled as text
- ✅ Searchable and diff-able
- ✅ Renders in GitHub/GitLab
- ✅ Can be embedded in documentation
- ✅ Easy to update and maintain

**Tradeoffs**:
- ⚠️  Limited styling options vs DrawIO
- ⚠️  Some complex diagrams simplified
- ⚠️  Requires Mermaid syntax knowledge

## 📖 Additional Resources

### Original Documentation
- [documentation/README.md](../../documentation/README.md)
- [documentation/arch-overview.md](../../documentation/arch-overview.md)
- [documentation/components/](../../documentation/components/)

### Mermaid Resources
- [Mermaid Diagrams README](../README.md)
- [Validation Guide](../VALIDATION.md)
- [Contributing Guide](../CONTRIBUTING.md)

### GitHub Actions
- [Validation Workflow](../../.github/workflows/validate-mermaid.yml)
- [Workflow Documentation](../../.github/workflows/README.md)

## 🔍 Quick Reference

### Architecture Decision Records (ADRs)
- [ADR Index](../../architecture-decision-records/README.md)
- [Model Serving ADRs](../../architecture-decision-records/model-serving/)
- [Operator ADRs](../../architecture-decision-records/operator/)

### Component Documentation
| Component | Original Docs | Mermaid Version | Key Diagrams |
|-----------|---------------|-----------------|--------------|
| Platform | [📄](../../documentation/components/platform/README.md) | [📖](./PLATFORM-ARCHITECTURE.md) | [📊](../platform-architecture-overview.md) |
| Dashboard | [📄](../../documentation/components/dashboard/README.md) | [📖](./components/DASHBOARD.md) | [📊](../dashboard-feature-flags.md) |
| Model Serving | [📄](../../documentation/components/serving/README.md) | [📖](./components/MODEL-SERVING.md) | [📊](../kserve-private-network-in-cluster.md) |
| Pipelines | [📄](../../documentation/components/pipelines/README.md) | [📖](./components/PIPELINES.md) | [📊](../dsp-v2-architecture.md) |
| Model Registry | [📄](../../documentation/components/model-registry/README.md) | [📖](./components/MODEL-REGISTRY.md) | [📊](../model-registry-overview.md) |
| TrustyAI | [📄](../../documentation/components/explainability/README.md) | [📖](./components/TRUSTYAI.md) | [📊](../trustyai-explainability-architecture.md) |
| Workbenches | [📄](../../documentation/components/workbenches/README.md) | - | - |
| Feature Store | [📄](../../documentation/components/feature_store/README.md) | - | - |

## 🎯 Navigation Tips

- **For Architecture Overview**: Start with [ARCHITECTURE-OVERVIEW.md](./ARCHITECTURE-OVERVIEW.md)
- **For Platform Details**: Read [PLATFORM-ARCHITECTURE.md](./PLATFORM-ARCHITECTURE.md)
- **For Component Details**: Browse [Component Documentation](./components/)
  - [Dashboard](./components/DASHBOARD.md) - UI and feature system
  - [Model Serving](./components/MODEL-SERVING.md) - KServe and ModelMesh
  - [Pipelines](./components/PIPELINES.md) - Data Science Pipelines v2
  - [Model Registry](./components/MODEL-REGISTRY.md) - ML metadata management
  - [TrustyAI](./components/TRUSTYAI.md) - Explainability and fairness
- **For Interactive Diagrams**: Click through to individual diagram `.md` files
- **For Original Content**: Reference links point to `documentation/` directory

## 📖 Complete Mermaid Documentation Set

This directory now contains a comprehensive mermaid-enhanced version of the RHOAI architecture documentation:

### Main Architecture Documents
1. [ARCHITECTURE-OVERVIEW.md](./ARCHITECTURE-OVERVIEW.md) - Complete RHOAI v2.13 overview
2. [PLATFORM-ARCHITECTURE.md](./PLATFORM-ARCHITECTURE.md) - ODH Operator and platform

### Component Documentation
3. [components/DASHBOARD.md](./components/DASHBOARD.md) - Dashboard architecture
4. [components/MODEL-SERVING.md](./components/MODEL-SERVING.md) - Model serving platforms
5. [components/PIPELINES.md](./components/PIPELINES.md) - Data Science Pipelines
6. [components/MODEL-REGISTRY.md](./components/MODEL-REGISTRY.md) - Model Registry
7. [components/TRUSTYAI.md](./components/TRUSTYAI.md) - TrustyAI explainability

### Standalone Diagram Files
8. [rhoai-components-overview.md](../rhoai-components-overview.md)
9. [platform-architecture-overview.md](../platform-architecture-overview.md)
10. [odh-operator-current-architecture.md](../odh-operator-current-architecture.md)
11. [odh-operator-next-architecture.md](../odh-operator-next-architecture.md)
12. [dashboard-feature-flags.md](../dashboard-feature-flags.md)
13. [kserve-private-network-in-cluster.md](../kserve-private-network-in-cluster.md)
14. [kserve-autogen-sni-gateways.md](../kserve-autogen-sni-gateways.md)
15. [dsp-v2-architecture.md](../dsp-v2-architecture.md)
16. [model-registry-overview.md](../model-registry-overview.md)
17. [trustyai-explainability-architecture.md](../trustyai-explainability-architecture.md)

---

**Last Updated**: 2025-12-04
**Mermaid Diagrams**: 10 standalone diagram files
**Documentation Files**: 7 comprehensive mermaid-enhanced docs (2 main + 5 component)
**Coverage**: ~70% of visual architecture diagrams converted to Mermaid
**Interactive Features**: All diagrams render natively in GitHub with zoom and pan
