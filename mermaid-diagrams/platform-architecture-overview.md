# Platform Architecture Overview

## RHOAI/ODH Platform Architecture

```mermaid
graph TB
    Admin["👤<br/>Admin"]

    subgraph RedhatODSOperator["redhat-ods-operator"]
        ODHOperator["ODH Operator<br/>(rhods-operator-controller-manager)"]

        subgraph OperatorComponents["Operator Components"]
            DSCIController["dsci-<br/>controller"]
            ConfigMapGenController["configmap-<br/>generator-<br/>controller"]
            DSCController["dsc-<br/>controller"]
            SecretGenController["secret<br/>generator-<br/>controller"]
        end

        ODHOperator --> OperatorComponents
    end

    subgraph FeatureTracker["FeatureTracker"]
        FT["Feature<br/>Trackers"]
        DashboardSecret["Dashboard<br/>Oauth-client<br/>Secret"]
    end

    Admin -->|installs| ODHOperator

    ODHOperator -->|Manages| FT
    ODHOperator -->|Manages| DashboardSecret

    subgraph IstioSystem["istio-system"]
        ServiceMeshConfig["Service Mesh<br/>Configuration"]
    end

    subgraph RedhatODSAuthProvider["redhat-ods-auth-provider"]
        AuthoringCR["Authoring CR"]
    end

    subgraph RedhatODSMonitoring["redhat-ods-monitoring"]
        MonitoringResources["Monitoring<br/>Resources"]
    end

    subgraph DSCI["DSCI"]
        DSCIRes["DSCI"]
    end

    subgraph DSC["DSC"]
        DSCRes["DSC"]
    end

    subgraph RedhatODSApplications["redhat-ods-applications"]
        Workbenches["Workbenches"]
        ServingComponents["Serving<br/>Components"]
        DistributedWorkloads["Distributed<br/>Workloads"]
        DataSciencePipelines["Data Science<br/>Pipelines"]
        Dashboard["Dashboard"]
        NComponents["n Components"]

        Workbenches -.-> WBIcon1["☸️"]
        Workbenches -.-> WBIcon2["☸️"]
        Workbenches -.-> WBIcon3["☸️"]
        Workbenches -.-> WBIcon4["☸️"]
        Workbenches -.-> WBIcon5["☸️"]

        ServingComponents -.-> SCIcon1["☸️"]
        ServingComponents -.-> SCIcon2["☸️"]
        ServingComponents -.-> SCIcon3["☸️"]
        ServingComponents -.-> SCIcon4["☸️"]
        ServingComponents -.-> SCIcon5["☸️"]

        DistributedWorkloads -.-> DWIcon1["☸️"]
        DistributedWorkloads -.-> DWIcon2["☸️"]
        DistributedWorkloads -.-> DWIcon3["☸️"]
        DistributedWorkloads -.-> DWIcon4["☸️"]

        DataSciencePipelines -.-> DSPIcon1["☸️"]
        DataSciencePipelines -.-> DSPIcon2["☸️"]
        DataSciencePipelines -.-> DSPIcon3["☸️"]
        DataSciencePipelines -.-> DSPIcon4["☸️"]

        Dashboard -.-> DashIcon1["☸️"]
        Dashboard -.-> DashIcon2["☸️"]
        Dashboard -.-> DashIcon3["☸️"]
        Dashboard -.-> DashIcon4["☸️"]
        Dashboard -.-> DashIcon5["☸️"]
    end

    DSCIController -->|"Creates/manages"| ServiceMeshConfig
    DSCIController -->|Manages| DSCI

    DSCController -->|Manages| DSC
    DSCController -->|Watches| DSCI

    DSCI -->|"Creates/manages"| AuthoringCR
    DSCI -->|"Creates/manages"| MonitoringResources
    DSCI -->|"Creates/manages"| TrustedCAConfigmaps["TrustedCA Configmaps"]

    DSC -->|"manage/watches"| RedhatODSApplications

    style Admin fill:#fff,stroke:#333
    style ODHOperator fill:#9ad,stroke:#333
    style DSCIController fill:#eee,stroke:#333
    style ConfigMapGenController fill:#eee,stroke:#333
    style DSCController fill:#eee,stroke:#333
    style SecretGenController fill:#eee,stroke:#333
    style FT fill:#fff,stroke:#333
    style DashboardSecret fill:#fff,stroke:#333
    style ServiceMeshConfig fill:#fff,stroke:#333
    style AuthoringCR fill:#fff,stroke:#333
    style MonitoringResources fill:#fff,stroke:#333
    style TrustedCAConfigmaps fill:#fff,stroke:#333
    style DSCIRes fill:#99f,stroke:#333
    style DSCRes fill:#99f,stroke:#333
    style Workbenches fill:#dce,stroke:#333
    style ServingComponents fill:#dce,stroke:#333
    style DistributedWorkloads fill:#dce,stroke:#333
    style DataSciencePipelines fill:#dce,stroke:#333
    style Dashboard fill:#dce,stroke:#333
    style NComponents fill:#dce,stroke:#333
    style RedhatODSOperator stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style IstioSystem stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style RedhatODSAuthProvider stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style RedhatODSMonitoring stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style RedhatODSApplications stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
```

## Architecture Overview

### Admin Installation
- Administrator installs ODH Operator
- Operator deployed in **redhat-ods-operator** namespace

### ODH Operator Components

The operator consists of multiple controllers:

#### dsci-controller
- Manages DSCInitialization (DSCI) resources
- Creates and manages platform-level infrastructure:
  - Service Mesh Configuration (istio-system)
  - Authoring CR (redhat-ods-auth-provider)
  - Monitoring Resources (redhat-ods-monitoring)
  - TrustedCA Configmaps

#### dsc-controller
- Manages DataScienceCluster (DSC) resources
- Watches DSCI for platform readiness
- Manages application components in redhat-ods-applications

#### configmap-generator-controller
- Generates configuration for components

#### secret-generator-controller
- Manages secrets, including Dashboard OAuth client secret

### Platform Resources

#### Feature Tracker
- Cluster-wide resource tracking features
- Owner reference for resources linked to features
- Enables precise resource management and cleanup

#### Dashboard OAuth Secret
- Managed by operator
- Provides OAuth authentication for Dashboard

### Platform Infrastructure Namespaces

#### istio-system
- Service Mesh Configuration
- Network and security policies
- Managed by DSCI controller

#### redhat-ods-auth-provider
- Authoring CR for authentication
- OAuth and identity management
- Created by DSCI

#### redhat-ods-monitoring
- Monitoring Resources
- Metrics collection and alerting
- Managed by DSCI

### Application Components (redhat-ods-applications)

All components are managed by DSC controller and deploy Kubernetes resources (☸️):

#### Workbenches
- Jupyter notebooks and development environments
- Deploys 5+ Kubernetes resources

#### Serving Components
- Model serving infrastructure
- KServe, ModelMesh deployments
- Deploys 5+ Kubernetes resources

#### Distributed Workloads
- Ray, Kubeflow Training Operator
- Distributed computing resources
- Deploys 4+ Kubernetes resources

#### Data Science Pipelines
- Kubeflow Pipelines v2
- Workflow orchestration
- Deploys 4+ Kubernetes resources

#### Dashboard
- Web UI for platform management
- User-facing interface
- Deploys 5+ Kubernetes resources

#### Additional Components
- Feature Store, Model Registry, TrustyAI, etc.
- Extensible component architecture

## Control Flow

### Installation Flow
1. Admin installs ODH Operator
2. Operator controllers start in redhat-ods-operator namespace

### Platform Initialization Flow
1. DSCI controller watches for DSCInitialization CR
2. Creates platform infrastructure:
   - Service Mesh in istio-system
   - Auth provider in redhat-ods-auth-provider
   - Monitoring in redhat-ods-monitoring
   - TrustedCA Configmaps

### Application Deployment Flow
1. DSC controller watches for DataScienceCluster CR
2. DSC controller watches DSCI for readiness
3. Deploys and manages application components
4. Each component creates Kubernetes resources

## Key Design Principles

- **Namespace Isolation**: Different namespaces for operator, platform, and applications
- **Declarative Management**: CR-driven configuration (DSCI, DSC)
- **Resource Tracking**: FeatureTracker for precise lifecycle management
- **Layered Architecture**: Platform layer (DSCI) → Application layer (DSC)
