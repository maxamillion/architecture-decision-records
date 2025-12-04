# ODH Operator Current Architecture

## Current Internal API Architecture

```mermaid
graph TB
    subgraph Resources["Resources"]
        FeatureTracker["Feature<br/>Tracker"]
        Resource["Resource"]

        FeatureTracker -->|"Creates/Manages"| DSCIReconciler
        Resource -->|"Creates/Manages"| DSCReconciler
    end

    subgraph Components["Components"]
        Dashboard["Dashboard"]
        Ellipsis["..."]
        ModelServing["Model Serving"]

        Components1[Components] -->|"Creates/Manages"| DSCReconciler
    end

    subgraph Reconcilers["Reconcilers"]
        DSCIReconciler["DSCI Reconciler"]
        DSCReconciler["DSC Reconciler"]

        DSCIReconciler -->|Watches| DSCIReconciler
        DSCReconciler -->|Watches| DSCReconciler
    end

    subgraph PlatformAPI["Platform API"]
        DSCInitialization["DSCInitialization"]
        DataScienceCluster["DataScienceCluster"]

        DSCIReconciler -->|Watches| DSCInitialization
        DSCReconciler -->|Watches| DataScienceCluster
    end

    ODHOperator["ODH Operator"]
    ODHOperator -.-> DSCIReconciler
    ODHOperator -.-> DSCReconciler

    Dashboard -.-> KubeIcon1["☸️"]
    Ellipsis -.-> KubeIcon2["☸️"]
    ModelServing -.-> KubeIcon3["☸️"]

    DSCInitialization -.-> KubeIcon4["☸️"]
    DataScienceCluster -.-> KubeIcon5["☸️"]

    style FeatureTracker fill:#fff,stroke:#333
    style Resource fill:#fcb,stroke:#333
    style Dashboard fill:#dce,stroke:#333
    style Ellipsis fill:#dce,stroke:#333
    style ModelServing fill:#dce,stroke:#333
    style DSCIReconciler fill:#fcb,stroke:#333
    style DSCReconciler fill:#dce,stroke:#333
    style DSCInitialization fill:#fcb,stroke:#333
    style DataScienceCluster fill:#dce,stroke:#333
    style Resources stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style Components stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
    style PlatformAPI stroke:#333,stroke-width:1px,stroke-dasharray: 5 5
```

## Key Components

### Resources
- **Feature Tracker**: Manages feature-specific resources
- **Resource**: Generic resource management

### Reconcilers
- **DSCI Reconciler**: Reconciles DSCInitialization resources (Platform API)
- **DSC Reconciler**: Reconciles DataScienceCluster resources and Components

### Platform API
- **DSCInitialization**: Platform initialization configuration
- **DataScienceCluster**: Main cluster configuration

### Components
- **Dashboard**: User interface component
- **Model Serving**: Model serving infrastructure
- **Others**: Additional components indicated by ellipsis

## Architecture Notes

- Resources create and manage their respective reconcilers
- Reconcilers watch and react to changes in their associated platform resources
- Components are created and managed by the DSC Reconciler
- All components and resources ultimately interact with Kubernetes API (☸️)
