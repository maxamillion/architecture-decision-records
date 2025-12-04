# Dashboard Feature Flags Architecture

## Feature Flag System Flow

```mermaid
graph TB
    Client["1b: client browser"]

    subgraph K8sCluster["K8s Cluster"]
        subgraph RedhatODSApps["redhat-ods-applications"]
            ODHDashboard["1c: rhods-dashboard-id"]
            DashboardRoute["1a: Dashboard Route"]

            OdhDashboardApp["OdhDashboardApplication - cached"]

            ODHDashboard --> OdhDashboardApp
        end

        subgraph ODHDashboardNS["odh-dashboard-id"]
            ODHDashboardConfig["OdhDashboardApplication - odh-dashboard-config"]
        end

        DSCandDSCI["DSC and DSCI - cluster CRs"]

        Client -->|1b| Areas
        Areas["Areas"]

        Areas -->|Am I Enabled?| FeatureDecision{"2: Feature A"}

        FeatureDecision -->|Feature B| FeatureB["Feature B"]
        FeatureDecision --> FeatureEllipsis["... Feature"]

        Areas -->|"3a: Gets various stack information"| DSCandDSCI
        Areas -->|"3b: Calls pod and gets cached value"| ODHDashboard

        ODHDashboard -->|"4: Refresh cache every 2 mins"| OdhDashboardApp
        OdhDashboardApp --> ODHDashboardConfig
    end

    DashboardRoute --> Client

    style Client fill:#9cf,stroke:#333
    style Areas fill:#fff,stroke:#333
    style FeatureDecision fill:#fff,stroke:#333
    style FeatureB fill:#fff,stroke:#333
    style FeatureEllipsis fill:#fff,stroke:#333
    style DSCandDSCI fill:#99f,stroke:#333
    style ODHDashboard fill:#9ad,stroke:#333
    style DashboardRoute fill:#9ad,stroke:#333
    style OdhDashboardApp fill:#9ad,stroke:#333
    style ODHDashboardConfig fill:#9ad,stroke:#333
    style K8sCluster stroke:#333,stroke-width:2px
    style RedhatODSApps stroke:#333,stroke-width:1px
    style ODHDashboardNS stroke:#333,stroke-width:1px
```

## Component Flow Description

### 1. Initial Request Flow
- **1a**: Dashboard Route receives external requests
- **1b**: Client browser accesses the dashboard through the route
- **1c**: Request is forwarded to the rhods-dashboard pod

### 2. Feature Evaluation
- Client browser queries **"Areas"** component
- Areas component checks if features (A, B, etc.) are enabled
- Decision logic determines which features to activate

### 3. Information Gathering
- **3a**: Areas component retrieves stack information from DSC & DSCI (cluster CRs)
- **3b**: Areas calls the dashboard pod and retrieves cached configuration values

### 4. Cache Management
- Dashboard pod refreshes its cache **every 2 minutes**
- Cache pulls from OdhDashboardApplication (cached) resource
- Configuration sourced from odh-dashboard-config in the application namespace

## Key Components

### Namespaces
- **redhat-ods-applications**: Contains dashboard deployment and route
- **odh-dashboard-{id}**: Contains dashboard configuration

### Resources
- **DSC & DSCI**: Cluster-level custom resources defining platform state
- **OdhDashboardApplication**: Dashboard configuration resource (with caching)
- **Dashboard Route**: Entry point for browser-based access

### Caching Strategy
- 2-minute refresh interval for configuration cache
- Reduces load on Kubernetes API server
- Ensures relatively fresh configuration without constant API calls

## Feature Flag Decision Points
Features are evaluated based on:
1. Cluster-level configuration (DSC & DSCI)
2. Dashboard-specific configuration (OdhDashboardApplication)
3. Cached state from the dashboard pod
