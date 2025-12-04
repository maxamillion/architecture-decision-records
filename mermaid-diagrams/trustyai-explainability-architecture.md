# TrustyAI Explainability Architecture

## TrustyAI Service Operator and Component Flow

```mermaid
graph TB
    subgraph Project["project"]
        ConfigMap["Global CA<br/>bundle"]
        ServiceMonitor["ServiceMonitor"]

        ConfigMap -.->|cm| CM_Icon["📋"]
    end

    subgraph ModelMesh["ModelMesh"]
        InferenceService1["InferenceService"]
        InferenceService2["InferenceService"]
        InferenceService3["InferenceService"]
    end

    subgraph KServe["KServe"]
        InferenceService4["InferenceService"]
        InferenceService5["InferenceService"]
    end

    subgraph RedhatODSApps["redhat-ods-applications"]
        Operator["trustyai-service-operator-controller-manager"]
        TrustyAIConfig["TrustyAI config"]

        Operator -->|watch| ConfigMap
        Operator -->|watch| TrustyAIConfig
        Operator -->|watch| ModelMesh
        Operator -->|watch| KServe
        Operator -->|manage| ServiceMonitor
    end

    subgraph Deployment["Deployment Area"]
        TrustyAIService["TrustyAIService"]
        InternalService["Internal<br/>Service"]
        PVC["PVC"]
        Service["Service"]
        OAuth["OAuth"]
        ExternalService["External<br/>Service"]
        Route["Route"]

        Operator -->|manage| Deployment
        Operator -->|manage| TrustyAIService

        TrustyAIService -->|deploy| InternalPod["📦"]
        TrustyAIService -->|pod| ServicePod["📦"]

        ServicePod --> Service
        ServicePod --> OAuth
        ServicePod --> PVC

        Service --> ExternalService
        OAuth --> ExternalService
        ExternalService --> Route
    end

    InferenceLogger["InferenceLogger"]
    User["User"]

    InferenceService4 -.->|Payload processor| InferenceLogger
    InternalService --> PVC
    Route --> User

    style ConfigMap fill:#fff,stroke:#333
    style ServiceMonitor fill:#fff,stroke:#333
    style Operator fill:#9ad,stroke:#333
    style TrustyAIConfig fill:#fff,stroke:#333
    style TrustyAIService fill:#eee,stroke:#333
    style InternalService fill:#fff,stroke:#333
    style ExternalService fill:#fff,stroke:#333
    style Service fill:#fff,stroke:#333
    style OAuth fill:#fff,stroke:#333
    style Route fill:#99f,stroke:#333
    style PVC fill:#9ad,stroke:#333
    style InferenceService1 fill:#fff,stroke:#333
    style InferenceService2 fill:#fff,stroke:#333
    style InferenceService3 fill:#fff,stroke:#333
    style InferenceService4 fill:#fff,stroke:#333
    style InferenceService5 fill:#fff,stroke:#333
    style User fill:#fff,stroke:#333
    style Project stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style ModelMesh stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style KServe stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style RedhatODSApps stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style Deployment stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
```

## Architecture Overview

### TrustyAI Service Operator
The **trustyai-service-operator-controller-manager** is the central control component that:
- **Watches** multiple resources:
  - Global CA bundle (ConfigMap)
  - TrustyAI configuration
  - InferenceServices in ModelMesh
  - InferenceServices in KServe
- **Manages**:
  - ServiceMonitor for metrics
  - TrustyAIService deployment
  - Associated Kubernetes resources

### Inference Service Integration

#### ModelMesh
- Monitors InferenceService resources deployed via ModelMesh
- Watches for model serving events

#### KServe
- Monitors InferenceService resources deployed via KServe
- InferenceLogger captures payload data from inference requests
- Payload processor sends data to TrustyAI service

### TrustyAI Service Components

#### Internal Components
- **Internal Service**: Internal-facing service endpoint
- **PVC (Persistent Volume Claim)**: Data storage for inference logs and metrics

#### External Access
- **Service**: Kubernetes service for pod access
- **OAuth**: Authentication and authorization layer
- **External Service**: External-facing service endpoint
- **Route**: OpenShift route for user access

### Data Flow

1. **Inference Requests**:
   - KServe InferenceServices process model inference requests
   - Payload processor captures request/response data via InferenceLogger

2. **Data Storage**:
   - Internal Service writes data to PVC
   - TrustyAI pods read/write from PVC

3. **External Access**:
   - Users access TrustyAI via Route
   - OAuth provides secure authentication
   - External Service routes traffic to TrustyAI pods

### Monitoring
- ServiceMonitor managed by operator
- Provides metrics and observability for TrustyAI services

## Key Features
- **Multi-Platform Support**: Works with both ModelMesh and KServe
- **Automated Management**: Operator handles lifecycle and configuration
- **Secure Access**: OAuth-protected routes for external access
- **Persistent Storage**: PVC for inference data and analysis results
