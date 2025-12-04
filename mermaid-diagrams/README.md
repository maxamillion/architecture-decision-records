# Architecture Diagrams - Mermaid Format

This directory contains Mermaid markup language conversions of the architecture diagrams from the RHOAI/ODH architecture decision records repository.

## Overview

All diagrams have been converted from PNG/JPG/DrawIO formats to Mermaid markdown for better version control, easier editing, and enhanced collaboration. Mermaid diagrams can be rendered directly in GitHub, GitLab, and many markdown editors.

## Diagram Catalog

### Model Serving

#### KServe Network Architecture
- **[kserve-private-network-in-cluster.md](./kserve-private-network-in-cluster.md)** - KServe private network with mTLS and local gateway
  - Source: `architecture-decision-records/model-serving/images/ODH-ADR-MS-0001-kserve-private-network-in-cluster-img-1.png`
  - Shows mTLS communication within service mesh
  - Gateway configuration and certificate management

- **[kserve-autogen-sni-gateways.md](./kserve-autogen-sni-gateways.md)** - KServe autogen SNI gateways architecture
  - Source: `architecture-decision-records/model-serving/images/ODH-ADR-MS-0001-kserve-private-network-in-cluster-img-2.png`
  - HTTPS with dynamic certificate creation
  - Autogen SNI gateway configuration

### Operator Architecture

#### ODH Operator Evolution
- **[odh-operator-current-architecture.md](./odh-operator-current-architecture.md)** - Current internal API architecture
  - Source: `architecture-decision-records/operator/assets/ODH-ADR-Operator-0006/odh-operator-current.png`
  - Shows current reconciler pattern
  - Platform API and component relationships

- **[odh-operator-next-architecture.md](./odh-operator-next-architecture.md)** - Proposed internal API architecture
  - Source: `architecture-decision-records/operator/assets/ODH-ADR-Operator-0006/odh-operator-next.png`
  - Component-specific reconcilers
  - New Components API layer

### Dashboard

- **[dashboard-feature-flags.md](./dashboard-feature-flags.md)** - Dashboard feature flag system
  - Source: `documentation/components/dashboard/assets/featureFlags.png`
  - Feature evaluation flow
  - Caching strategy (2-minute refresh)
  - Integration with DSC/DSCI cluster resources

### Components

#### TrustyAI / Explainability
- **[trustyai-explainability-architecture.md](./trustyai-explainability-architecture.md)** - TrustyAI service architecture
  - Source: `documentation/components/explainability/diagram.png`
  - Operator-based deployment
  - Integration with ModelMesh and KServe
  - Inference logging and payload processing

#### Data Science Pipelines
- **[dsp-v2-architecture.md](./dsp-v2-architecture.md)** - DSP v2 control and data plane architecture
  - Source: `documentation/components/pipelines/dsp-v2-architecture.drawio.png`
  - Control plane (operator, dashboard, notebook)
  - Data plane (API server, workflow controllers, metadata service)
  - Network policies and OAuth integration

#### Model Registry
- **[model-registry-overview.md](./model-registry-overview.md)** - Model Registry integration overview
  - Source: `documentation/components/model-registry/images/model-registry-overview.jpg`
  - ML lifecycle phases
  - Integration with Jupyter, Dashboard, API clients
  - Infrastructure component connections

### Platform

- **[platform-architecture-overview.md](./platform-architecture-overview.md)** - Complete platform architecture
  - Source: `documentation/components/platform/Platform Architecture Overview.png`
  - ODH Operator and controllers
  - Platform infrastructure (DSCI)
  - Application components (DSC)
  - Namespace organization

- **[rhoai-components-overview.md](./rhoai-components-overview.md)** - RHOAI v2.13 components overview
  - Source: `documentation/images/RHOAI Architecture-Overview.drawio.png`
  - User personas (ML Ops, Data Scientist)
  - Component maturity (GA vs In Development)
  - Service layer architecture

## Using These Diagrams

### Viewing
- All diagrams render automatically in GitHub/GitLab markdown preview
- Use any Mermaid-compatible markdown editor
- Online tools: [Mermaid Live Editor](https://mermaid.live/)

### Editing
1. Copy the Mermaid code from any `.md` file
2. Paste into Mermaid Live Editor for visual editing
3. Update the source file with your changes
4. Submit a pull request

### Embedding in Documentation
```markdown
# Your Document Title

See the architecture diagram:

![Architecture Diagram](./mermaid-diagrams/your-diagram.md)
```

## Mermaid Syntax Reference

### Graph Directions
- `TB` - Top to Bottom (most diagrams use this)
- `LR` - Left to Right
- `BT` - Bottom to Top
- `RL` - Right to Left

### Common Elements
- `-->` - Solid arrow
- `-.->` - Dotted arrow
- `==>` - Thick arrow
- `subgraph` - Grouping container
- `style` - Custom styling

### Resources
- [Mermaid Documentation](https://mermaid.js.org/)
- [Mermaid Flowchart Syntax](https://mermaid.js.org/syntax/flowchart.html)
- [GitHub Mermaid Support](https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/)

## Original Sources

All diagrams were converted from:
- `architecture-decision-records/model-serving/images/` - KServe diagrams
- `architecture-decision-records/operator/assets/` - Operator diagrams
- `documentation/components/*/` - Component-specific diagrams
- `documentation/images/` - Platform overview diagrams

## Conversion Notes

### Fidelity
- All diagrams maintain the structure and information from originals
- Colors and styling adapted for Mermaid syntax
- Icons represented with Unicode characters where applicable (☸️ for Kubernetes, 👤 for users, 📦 for pods, etc.)

### Enhancements
- Added comprehensive documentation sections to each diagram
- Included architecture notes and key features
- Cross-references to related diagrams
- Improved labels and descriptions for clarity

### Known Limitations
- Some complex DrawIO diagrams simplified for Mermaid compatibility
- Custom icons replaced with standard shapes or Unicode
- Complex nested layouts may appear slightly different

## Contributing

To add or update diagrams:

1. **New Diagrams**:
   - Convert source image to Mermaid syntax
   - Include source attribution
   - Add comprehensive documentation
   - Update this README

2. **Updates**:
   - Maintain existing structure
   - Document changes in commit message
   - Ensure Mermaid syntax validates

3. **Review**:
   - Test rendering in GitHub preview
   - Verify against original diagram
   - Check for completeness

## Maintenance

**Last Updated**: 2025-12-03

**Conversion Status**: ✅ Complete
- 11 diagrams converted to Mermaid format
- All major architecture components documented
- Cross-references and navigation added

**Future Work**:
- Additional component detail diagrams (workbenches, distributed workloads)
- Network architecture diagrams from `documentation/images/network/`
- Deployment model diagrams from model-registry
- Logical model and tenancy diagrams

## Related Documentation

- [Architecture Decision Records](../architecture-decision-records/README.md)
- [Component Documentation](../documentation/components/)
- [Architecture Overview](../documentation/arch-overview.md)
