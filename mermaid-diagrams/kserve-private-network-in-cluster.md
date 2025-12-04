# KServe Private Network Architecture

## Diagram 1: mTLS with Local Gateway

```mermaid
graph TB
    subgraph External["External Access"]
        WorkloadOutside["Workload outside the mesh<br/>(no istio sidecar)"]
    end

    subgraph Mesh["Knative/Serverless configs/domain, untouched"]
        VirtualServiceMesh["VirtualService with 'mesh' gateway"]
        VirtualServiceKnativeLocal["VirtualService with 'knative-local-gateway' gateway"]

        WorkloadProxy["Any Workload<br/>(Pod - with proxy)"]
        InferenceWorkload["Inference Workload<br/>(Pod - with proxy)"]
        ActivatorKnativeServing["Activator knative-serving<br/>(Pod - with proxy)"]

        WorkloadNoProxy["Any Workload<br/>(Pod - no proxy)"]
        IstioIngressGateway["istio-ingressgateway<br/>(Pod)"]

        KnativeLocalGW["knative-local-gateway<br/>(Gateway)<br/>- mTLS (A)"]

        VirtualServiceMesh -->|mTLS| InferenceWorkload
        VirtualServiceKnativeLocal -->|"istio_mutual: mTLS (A)"| IstioIngressGateway
        WorkloadProxy -->|mTLS| InferenceWorkload
        IstioIngressGateway -->|mTLS| InferenceWorkload
        IstioIngressGateway -->|mTLS| ActivatorKnativeServing
        WorkloadNoProxy -.->|X| IstioIngressGateway
        KnativeLocalGW -->|mTLS| IstioIngressGateway
    end

    subgraph Lower["KServe Gateway"]
        KserveIngressGW["kserve-ingressgateway<br/>(Pod)"]
        KserveLocalGW["Kserve-local-gateway<br/>(Gateway)<br/>- Plain HTTP<br/>- TLS (simple)<br/>-> one entry per ISVC"]

        ISVCResource["InferenceService<br/>resource"]
        V1Service["v1/Service resource"]

        OpenShiftCert["OpenShift serving cert<br/>Secret"]
        OpenShiftCertCopy["OpenShift serving cert<br/>Secret (copy)"]
    end

    WorkloadOutside -->|"Either plain text or simple TLS"| KserveIngressGW
    WorkloadMeshProxy["Workload inside the mesh<br/>(with proxy)"]
    WorkloadMeshProxy -->|mTLS| KserveIngressGW

    KserveIngressGW --> KserveLocalGW
    KserveLocalGW -.->|Add TLS entry| OpenShiftCertCopy
    ISVCResource --> V1Service
    V1Service --> OpenShiftCert
    OpenShiftCert --> OpenShiftCertCopy

    Note1["Bypasses kserve<br/>gateway, because of<br/>VirtualService"]

    style VirtualServiceMesh fill:#ffd,stroke:#333
    style VirtualServiceKnativeLocal fill:#ffd,stroke:#333
    style WorkloadNoProxy fill:#def,stroke:#333
    style WorkloadProxy fill:#eee,stroke:#333
    style InferenceWorkload fill:#eee,stroke:#333
    style ActivatorKnativeServing fill:#eee,stroke:#333
    style IstioIngressGateway fill:#eee,stroke:#333
    style KnativeLocalGW fill:#dfd,stroke:#333
    style KserveLocalGW fill:#dfd,stroke:#333
    style KserveIngressGW fill:#eee,stroke:#333
    style WorkloadMeshProxy fill:#def,stroke:#333
    style WorkloadOutside fill:#def,stroke:#333
    style OpenShiftCert fill:#fbb,stroke:#333
    style OpenShiftCertCopy fill:#fdd,stroke:#333
    style Note1 fill:#ffd,stroke:#333
    style Mesh stroke:#f00,stroke-width:3px,stroke-dasharray: 5 5
```

## Notes

- **mTLS Communication**: Pods with proxy communicate using mutual TLS within the service mesh
- **Gateway Bypass**: VirtualService configuration allows workloads to bypass the kserve gateway
- **Certificate Management**: OpenShift serving certificates are copied and added as TLS entries to the gateway
- **Mixed Traffic**: Supports both plain text and TLS traffic from workloads outside the mesh

