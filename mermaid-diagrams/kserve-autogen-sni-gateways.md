# KServe Autogen SNI Gateways Architecture

## Diagram 2: HTTPS with Autogen SNI Gateways

```mermaid
graph TB
    subgraph Mesh["Knative/Serverless configs/domain, untouched"]
        VirtualServiceMesh["VirtualService with 'mesh' gateway"]
        VirtualServiceKnativeLocal["VirtualService with 'knative-local-gateway' gateway"]

        WorkloadProxy["Any Workload<br/>(Pod - with proxy)"]
        InferenceWorkload["Inference Workload<br/>(Pod - with proxy)"]
        ActivatorKnativeServing["Activator knative-serving<br/>(Pod - with proxy)"]

        IstioIngressGateway["istio-ingressgateway<br/>(Pod)"]

        VirtualServiceMesh -->|mTLS| InferenceWorkload
        VirtualServiceKnativeLocal -->|"https (B)"| IstioIngressGateway
        WorkloadProxy -->|"https (B)"| IstioIngressGateway
        IstioIngressGateway -->|mTLS| InferenceWorkload
        IstioIngressGateway -->|mTLS| ActivatorKnativeServing
    end

    subgraph Gateways["Gateway Configuration"]
        KnativeLocalGW["knative-local-gateway<br/>(Gateway)<br/>no longer in use"]
        AutogenSNI["Autogen SNI gateways<br/>(Gateway)<br/>- https (B)"]

        Note1["Needs at least one certificate per<br/>namespace with:<br/>*.<namespace>.svc.cluster.local"]
    end

    subgraph External["External Workloads"]
        WorkloadNoProxy["Any Workload<br/>(Pod - no proxy)"]
        Note2["Must trust the CA that<br/>signed the https certs<br/>(B)"]
    end

    WorkloadNoProxy -->|"https (B)"| IstioIngressGateway
    AutogenSNI --> IstioIngressGateway
    KnativeLocalGW -.->|deprecated| KnativeLocalGW

    Note3["(B) https needs dynamic creation of certificates in<br/>some form and distribution and reloading of CA<br/>trust."]

    style VirtualServiceMesh fill:#ffd,stroke:#333
    style VirtualServiceKnativeLocal fill:#ffd,stroke:#333
    style WorkloadNoProxy fill:#def,stroke:#333
    style WorkloadProxy fill:#eee,stroke:#333
    style InferenceWorkload fill:#eee,stroke:#333
    style ActivatorKnativeServing fill:#eee,stroke:#333
    style IstioIngressGateway fill:#eee,stroke:#333
    style KnativeLocalGW fill:#dfd,stroke:#333
    style AutogenSNI fill:#fcc,stroke:#333
    style Note1 fill:#ffd,stroke:#333
    style Note2 fill:#ffd,stroke:#333
    style Note3 fill:#fff,stroke:#333
    style Mesh stroke:#333,stroke-width:2px
```

## Notes

- **HTTPS Communication**: Uses HTTPS (B) instead of mTLS for internal cluster communication
- **Dynamic Certificates**: Requires dynamic creation of certificates and distribution of CA trust
- **SNI Gateways**: Autogen SNI gateways replace the knative-local-gateway approach
- **Certificate Requirements**: Needs at least one certificate per namespace following pattern: `*.<namespace>.svc.cluster.local`
- **CA Trust**: Workloads must trust the CA that signed the HTTPS certificates
- **Deprecated**: The knative-local-gateway is no longer in use with this approach

