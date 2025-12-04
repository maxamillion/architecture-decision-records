# Model Serving Architecture (Mermaid Version)

> This document provides the same information as [`documentation/components/serving/README.md`](../../../documentation/components/serving/README.md) but uses interactive Mermaid diagrams.

## Components

### KServe
**Repository**: [github.com/opendatahub-io/kserve](https://github.com/opendatahub-io/kserve)

This supports a single model serving platform. For deploying large models such as large language models (LLMs), OpenShift AI includes a single model serving platform that is based on the KServe component. Because each model is deployed from its own model server, the single model serving platform helps you deploy, monitor, scale, and maintain large models that require increased resources.

### ModelMesh
**Repository**: [github.com/opendatahub-io/modelmesh-serving](https://github.com/opendatahub-io/modelmesh-serving)

This supports a multi-model serving platform. For deploying small and medium-sized models, OpenShift AI includes a multi-model serving platform that is based on the ModelMesh component. On the multi-model serving platform, you can deploy multiple models on the same model server. Each of the deployed models shares the server resources. This approach can be advantageous on OpenShift clusters that have finite compute resources or pods.

### ODH Model Controller
**Repository**: [github.com/opendatahub-io/odh-model-controller](https://github.com/opendatahub-io/odh-model-controller)

This component facilitates seamless integration between RHOAI's various components and model serving components, enhancing the interoperability and synergy within the RHOAI ecosystem. It streamlines the integration process, enabling smoother communication and interaction between different modules and services, thereby optimizing the overall performance and functionality of the RHOAI platform.

## Network Architecture Diagrams

### KServe Private Network with mTLS

[View Full Diagram](../../kserve-private-network-in-cluster.md)

This diagram illustrates the KServe network architecture with mutual TLS (mTLS) for secure communication within the cluster. The setup uses Istio ingress gateway for routing and security.

**Key Components**:
- Virtual Service for Knative Local routing
- Istio Ingress Gateway for mTLS enforcement
- Internal cluster communication with mutual TLS
- External access through KServe Ingress Gateway

**Security Model**:
- In-cluster traffic uses `istio_mutual` for mTLS
- External traffic supports plain text or simple TLS

### KServe with Autogen SNI Gateways

[View Full Diagram](../../kserve-autogen-sni-gateways.md)

This diagram shows KServe HTTPS configuration with automatically generated SNI (Server Name Indication) gateways for secure external access.

**Key Components**:
- HTTPS communication for external access
- Automatic SNI gateway generation
- Istio-based routing and security
- Support for both proxied and direct workload access

**Access Patterns**:
- Internal workloads through Knative local gateway
- External workloads with proxy support
- External workloads without proxy (direct access)

## Model Serving Platforms Comparison

### Single Model Serving (KServe)

**Use Cases**:
- Large Language Models (LLMs)
- Models requiring dedicated resources
- High-resource models
- Models needing independent scaling

**Architecture**:
- One model per server
- Dedicated resources per model
- Independent scaling
- OpenShift Serverless integration
- Service Mesh integration

**Advantages**:
- Isolated resources
- Independent monitoring
- Granular scaling control
- Optimized for large models

### Multi-Model Serving (ModelMesh)

**Use Cases**:
- Small to medium-sized models
- Resource-constrained environments
- High model density requirements
- Shared resource scenarios

**Architecture**:
- Multiple models per server
- Shared server resources
- Collective resource management
- etcd for metadata persistence

**Advantages**:
- Efficient resource utilization
- Lower infrastructure overhead
- Cost-effective for many models
- Simplified management

## Integration with OpenShift AI Components

### Dashboard Integration
The Dashboard provides UI for:
- Model deployment configuration
- Runtime selection
- Resource allocation
- Monitoring and observability

### Model Registry Integration
Model Serving integrates with Model Registry to:
- Track deployment status
- Link models to registry entries
- Maintain deployment history
- Enable model versioning

### Service Mesh Integration
Both serving platforms integrate with OpenShift Service Mesh for:
- Network security (mTLS)
- Traffic management
- Observability
- Access control

## Deployment Workflow

### KServe Deployment
```
1. Create InferenceService CR
   ↓
2. KServe Controller processes CR
   ↓
3. Deploy model server pod
   ↓
4. Configure networking (Virtual Service, Gateway)
   ↓
5. Model ready for inference
```

### ModelMesh Deployment
```
1. Create InferenceService CR
   ↓
2. ModelMesh Controller processes CR
   ↓
3. Load model into existing server pool
   ↓
4. Update routing configuration
   ↓
5. Model ready for inference
```

## Network Security Considerations

### Internal Communication
- **mTLS Enforcement**: All in-cluster communication uses mutual TLS
- **Service Mesh**: Istio provides network policies and encryption
- **Authentication**: Bearer tokens for API access
- **Authorization**: K8s RBAC for resource access

### External Access
- **HTTPS**: Encrypted external communication
- **SNI Gateways**: Automatic certificate management
- **Route Configuration**: OpenShift Routes for external exposure
- **OAuth Proxy**: Optional authentication layer

## Monitoring and Observability

### Metrics Available
- Inference request rate
- Response latency
- Model server resource usage
- Error rates and types
- Queue depth (ModelMesh)

### Integration Points
- Prometheus for metrics collection
- Service Mesh observability
- Dashboard UI visualization
- Custom metrics endpoints

## References

- **Full Documentation**: [documentation/components/serving/README.md](../../../documentation/components/serving/README.md)
- **KServe Private Network Diagram**: [kserve-private-network-in-cluster.md](../../kserve-private-network-in-cluster.md)
- **KServe SNI Gateways Diagram**: [kserve-autogen-sni-gateways.md](../../kserve-autogen-sni-gateways.md)
- **Network Diagrams**: [documentation/images/network/](../../../documentation/images/network/)
- **Mermaid Diagrams**: [../README.md](../../README.md)
