# CONTROL GRAPH SCHEMA

## 1.0 Purpose
Defines a machine-queryable graph schema that unifies ETHOS, rationale, assurance, and architecture layers.

## 2.0 Node Types
### 2.1 `Control`
Key: `control_id`

### 2.2 `Rationale`
Key: `rationale_id`

### 2.3 `Framework`
Key: `framework_id` (`OCEG`, `NZISM`, `FAIR`, `NIST_RMF`)

### 2.4 `Evidence`
Key: `evidence_id`

### 2.5 `ArchitectureArtifact`
Key: `artifact_id`

## 3.0 Relationship Types
### 3.1 `(:Control)-[:HAS_RATIONALE]->(:Rationale)`
From assurance register `Linked_Rationale_Ref`.

### 3.2 `(:Rationale)-[:MAPS_TO]->(:Framework)`
Fixed mapping from rationale layer.

### 3.3 `(:Control)-[:IMPLEMENTED_BY]->(:ArchitectureArtifact)`
From `System_Component` values.

### 3.4 `(:Control)-[:HAS_EVIDENCE]->(:Evidence)`
From assurance register `Evidence` values.

## 4.0 Neo4j Property Schema
```cypher
CREATE CONSTRAINT control_id IF NOT EXISTS FOR (c:Control) REQUIRE c.control_id IS UNIQUE;
CREATE CONSTRAINT rationale_id IF NOT EXISTS FOR (r:Rationale) REQUIRE r.rationale_id IS UNIQUE;
CREATE CONSTRAINT framework_id IF NOT EXISTS FOR (f:Framework) REQUIRE f.framework_id IS UNIQUE;
CREATE CONSTRAINT evidence_id IF NOT EXISTS FOR (e:Evidence) REQUIRE e.evidence_id IS UNIQUE;
CREATE CONSTRAINT artifact_id IF NOT EXISTS FOR (a:ArchitectureArtifact) REQUIRE a.artifact_id IS UNIQUE;
```

## 5.0 RDF/OWL Class and Predicate Set
```ttl
@prefix sira: <https://example.org/sira#> .

sira:Control a rdfs:Class .
sira:Rationale a rdfs:Class .
sira:Framework a rdfs:Class .
sira:Evidence a rdfs:Class .
sira:ArchitectureArtifact a rdfs:Class .

sira:hasRationale a rdf:Property .
sira:mapsToFramework a rdf:Property .
sira:implementedBy a rdf:Property .
sira:hasEvidence a rdf:Property .
```

## 6.0 Canonical Data Sources
- `docs/ETHOS.md`
- `docs/GRC_CONTROL_RATIONALE_CROSSWALK.md`
- `docs/CONTROL_ASSURANCE_REGISTER.csv`
- `docs/IATO_MCP_ARCHITECTURE.md`
- `docs/CREDIT_RISK_LAYER.md`
- `docs/DELIVERY.md`
