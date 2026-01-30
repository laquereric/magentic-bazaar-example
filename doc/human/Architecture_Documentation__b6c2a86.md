# Architecture Documentation

> **Document Analysis:** This document has been processed through the enhanced ingest workflow with UML glossary integration and classified as a **use_case** type (behavioral subtype).

## Document Overview

**Source:** architecture_documentation__b6c2a86.md
**Processed:** 2026-01-30 16:38:29
**Git SHA:** 36608b4f0138686546af8bc887377866f51b531d
**UUID7:** b6c2a86
**Word Count:** 2165 words
**Main Sections:** Magentic Bazaar Multi-Platform Architecture, Executive Summary, Architecture Overview, Diagram 1: Multi-Device Deployment Architecture, Key Components, User Devices, Magentic Bazaar Service Platform, Third-Party Services, Security Architecture, Diagram 2: Configuration and Monitoring Flow, Configuration Request Flow, Monitoring Request Flow, Real-Time Monitoring, Diagram 3: Service Request Flow, LLM Query Flow, MCP Tool Call Flow, Security Guarantees, Diagram 4: User Types and Access Patterns, User Type Categories, Individual User, Group User, Developer, Platform User (Federated), Unified Communication Protocol, Access Point Flexibility, JSON-RPC-LD Protocol, Key Features, Example Request, Example Response, Implementation Considerations, WebSocket Connection Management, Message Validation Performance, Third-Party Service Integration, Multi-Tenancy and Isolation, Scalability Architecture, Horizontal Scaling, Caching Strategy, Monitoring and Observability, Metrics Collection, Logging Strategy, Alerting, Security Considerations, Authentication and Authorization, Data Protection, Audit Logging, Conclusion
**UML Classification:** use_case (behavioral)

## Visual Resources

### UML Diagram
**Type:** Use Case Diagram
**Subtype:** behavioral
**File:** [Architecture_Documentation__use_case__b6c2a86.puml](/Users/ericlaquer/Documents/GitHub/magentic-bazaar-example/doc/uml/Architecture_Documentation__use_case__b6c2a86.puml)

The UML diagram has been generated using enhanced analysis with UML glossary knowledge, providing accurate visualization of the use case concept described in this document.

### Technical Summary
**File:** [Architecture_Documentation__b6c2a86.md](/Users/ericlaquer/Documents/GitHub/magentic-bazaar-example/doc/skills/Architecture_Documentation__b6c2a86.md)

The technical summary contains structured metadata, key insights, and AI-optimized content with UML context for automated processing.

### UML Glossary
**Reference:** [skills/uml-glossary.md](/Users/ericlaquer/.rbenv/versions/3.4.5/lib/ruby/gems/3.4.0/bundler/gems/magentic-bazaar-86cf9cd2d674/skills/uml-glossary.md)

The comprehensive UML glossary provides definitions and explanations of UML concepts, relationships, and diagram types used in this analysis.

## Key Concepts
- **Magentic**
- **Bazaar**
- **Multi**
- **Platform**
- **Architecture**
- **Executive**
- **Summary**
- **This**
- **The**
- **Overview**
- **Unified**
- **Communication**
- **Protocol**
- **All**
- **WebSockets**
- **Zero**
- **Trust**
- **Security**
- **Model**
- **Every**
- **No**
- **Exclusive**
- **Service**
- **Intermediation**
- **Diagram**
- **Device**
- **Deployment**
- **Key**
- **Components**
- **WebSocket**
- **User**
- **Devices**
- **Users**
- **Laptop**
- **Web**
- **Browser**
- **Full**
- **Phone**
- **Mobile**
- **Responsive**
- **Native**
- **App**
- **Android**
- **Server**
- **Command**
- **Gateway**
- **Layer**
- **Handler**
- **Manages**
- **Authentication**
- **Authorization**
- **Validates**
- **Rate**
- **Limiting**
- **Monitoring**
- **Tracks**
- **Core**
- **Services**
- **Orchestrates**
- **Context**
- **Handles**
- **Ingestion**
- **Processes**
- **Data**
- **Database**
- **Stores**
- **Third**
- **Party**
- **Providers**
- **Anthropic**
- **Google**
- **Servers**
- **GitHub**
- **File**
- **System**
- **External**
- **Weather**
- **Calendar**
- **Centralized**
- **Comprehensive**
- **Protection**
- **Ability**
- **Configuration**
- **Flow**
- **Request**
- **When**
- **Action**
- **Processing**
- **Response**
- **Status**
- **Metrics**
- **Retrieval**
- **Real**
- **Time**
- **Query**
- **Summarize**
- **Call**
- **Client**
- **Tool**
- **Get**
- **Issues**
- **Guarantees**
- **Types**
- **Access**
- **Patterns**
- **Type**
- **Categories**
- **Individual**
- **Personal**
- **Multiple**
- **Group**
- **Team**
- **Collaborative**
- **Shared**
- **Developer**
- **Higher**
- **Federated**
- **Enterprise**
- **Cross**
- **Integration**
- **Despite**
- **Interface**
- **Same**
- **Consistent**
- **Identical**
- **Validation**
- **Rules**
- **Point**
- **Flexibility**
- **Each**
- **Developers**
- **It**
- **Features**
- **Mandatory**
- **Internationalized**
- **Resource**
- **Identifiers**
- **Linked**
- **Shapes**
- **Constraint**
- **Language**
- **Example**
- **Implementation**
- **Considerations**
- **Connection**
- **Management**
- **Automatic**
- **Heartbeat**
- **Graceful**
- **Message**
- **Performance**
- **Caching**
- **Asynchronous**
- **Robust**
- **Circuit**
- **Tenancy**
- **Isolation**
- **Audit**
- **Scalability**
- **Horizontal**
- **Scaling**
- **Stateless**
- **Read**
- **Connections**
- **Distributed**
- **Strategy**
- **To**
- **Redis**
- **Cache**
- **For**
- **Pooling**
- **Observability**
- **Collection**
- **Error**
- **Logging**
- **Structured**
- **Alerting**
- **Proactive**
- **Unusual**
- **Email**
- **Password**
- **Keys**
- **Tokens**
- **Level**
- **Enforces**
- **Row**
- **Encryption**
- **Rest**
- **Transit**
- **Storage**
- **Encrypted**
- **Handling**
- **Redaction**
- **Conclusion**
- **By**

## Main Takeaways
- **Laptop (Web Browser)**: Full-featured web application providing comprehensive access to all services
- **Phone (Mobile Browser)**: Responsive web interface optimized for mobile viewing
- **Phone (Native App)**: iOS/Android native application with enhanced mobile features
- **Server/CLI**: Command-line interface and SDK for programmatic access and automation
- WebSocket Handler: Manages all WebSocket connections and JSON-RPC-LD message routing

## UML Analysis Notes

This document was processed using UML glossary knowledge, enabling:
- Accurate diagram type classification
- Enhanced understanding of UML terminology
- Improved visualization based on UML standards
- Better context for technical documentation

## Original Content

---

# Magentic Bazaar Multi-Platform Architecture

## Executive Summary

This document presents a comprehensive architectural design for the Magentic Bazaar platform, showing how a single user can access LLM, MCP, and SKILL services through multiple devices using secure JSON-RPC-LD zero-trust websockets. The architecture ensures that all communication with third-party services is exclusively mediated through the Magentic Bazaar platform, providing a secure, scalable, and unified service layer.

## Architecture Overview

The Magentic Bazaar architecture is designed around three core principles:

1. **Unified Communication Protocol**: All client-server communication uses JSON-RPC-LD over WebSockets, providing semantic meaning through mandatory `@context` fields and SHACL validation for all messages.

2. **Zero-Trust Security Model**: Every message is validated, authenticated, and authorized. No direct access to third-party services is permitted from client devices.

3. **Exclusive Service Intermediation**: All calls to third-party services (LLM providers, MCP servers, external APIs) originate from and terminate at the Magentic Bazaar platform.

## Diagram 1: Multi-Device Deployment Architecture

![Deployment Architecture](Magentic_Bazaar_Deployment_Architecture.png)

### Key Components

The deployment architecture illustrates how a single user identity spans across multiple devices, all communicating with the Magentic Bazaar service platform through secure JSON-RPC-LD WebSocket connections.

#### User Devices

Users can access the platform through four primary device categories:

- **Laptop (Web Browser)**: Full-featured web application providing comprehensive access to all services
- **Phone (Mobile Browser)**: Responsive web interface optimized for mobile viewing
- **Phone (Native App)**: iOS/Android native application with enhanced mobile features
- **Server/CLI**: Command-line interface and SDK for programmatic access and automation

All devices maintain synchronized state and provide a consistent user experience through the unified authentication system.

#### Magentic Bazaar Service Platform

The platform consists of three layers:

**API Gateway Layer**
- WebSocket Handler: Manages all WebSocket connections and JSON-RPC-LD message routing
- Authentication & Authorization: Validates tokens, checks permissions, and enforces access control
- Rate Limiting & Monitoring: Tracks usage, enforces quotas, and monitors system health

**Core Services Layer**
- LLM Service: Manages interactions with large language model providers
- MCP Service: Orchestrates Model Context Protocol server connections
- SKILL Service: Handles skill definition storage and retrieval
- Ingestion Service: Processes document uploads and transformations

**Data Layer**
- PostgreSQL Database: Stores user data, configurations, usage metrics, and service state

#### Third-Party Services

All external service calls are routed through the Magentic Bazaar platform:

- **LLM Providers**: OpenAI, Anthropic, Google (accessed via HTTPS)
- **MCP Servers**: GitHub MCP, Database MCP, File System MCP (accessed via MCP Protocol)
- **External APIs**: Weather API, Calendar API, and other integrations (accessed via HTTPS)

### Security Architecture

The architecture enforces a strict security model where client devices never directly access third-party services. All external API calls originate from the Magentic Bazaar platform, which acts as a secure proxy. This provides several benefits:

- Centralized API key management and rotation
- Unified rate limiting and quota enforcement
- Comprehensive audit logging of all external service calls
- Protection of sensitive credentials from client exposure
- Ability to implement caching and request optimization

## Diagram 2: Configuration and Monitoring Flow

![Configuration and Monitoring](Configuration_and_Monitoring_Flow.png)

### Configuration Request Flow

When users configure services (such as adding an LLM provider), the following sequence occurs:

1. **User Action**: User initiates configuration through their device
2. **JSON-RPC-LD Request**: Device sends a structured request with semantic context
3. **Authentication**: WebSocket handler validates the user's token and permissions
4. **Configuration Processing**: Configuration service stores the settings in the database
5. **Response**: User receives confirmation with the new configuration ID

All configuration data is encrypted at rest and in transit. API keys and sensitive credentials are stored using industry-standard encryption and are never exposed to client devices.

### Monitoring Request Flow

Users can query service status and metrics through the monitoring interface:

1. **Status Request**: User requests service health information
2. **Authentication**: System validates user permissions for monitoring data
3. **Metrics Retrieval**: Monitoring service queries the database for current metrics
4. **Status Response**: User receives real-time status information for all services

### Real-Time Monitoring

The platform supports real-time monitoring through WebSocket push notifications. When significant events occur (such as high usage alerts or service degradation), the monitoring service proactively pushes notifications to connected clients without requiring polling.

## Diagram 3: Service Request Flow

![Service Request Flow](Service_Request_Flow.png)

### LLM Query Flow

This diagram illustrates a typical LLM completion request:

1. **User Request**: User submits a prompt (e.g., "Summarize this document")
2. **JSON-RPC-LD Request**: Device sends a semantically structured request with `@context` defining the meaning of each field
3. **Authentication & Rate Limiting**: System validates the request and checks quota availability
4. **LLM Service Processing**: The LLM service logs the request and prepares to call the external provider
5. **Third-Party API Call**: **CRITICAL** - The call to OpenAI (or other provider) originates exclusively from the Magentic Bazaar platform
6. **Response Processing**: The response is received at Magentic Bazaar, logged, and usage metrics are updated
7. **Client Response**: The processed result is sent back to the client with semantic context

### MCP Tool Call Flow

The diagram also shows an example of calling an MCP tool:

1. **User Request**: User requests data from an MCP server (e.g., "Get my GitHub issues")
2. **JSON-RPC-LD Request**: Device sends an MCP tool invocation request
3. **MCP Service Processing**: The MCP service executes the tool call
4. **MCP Protocol Call**: The call to the GitHub MCP server originates from Magentic Bazaar only
5. **Response**: Issues data is returned to the platform and forwarded to the client

### Security Guarantees

The architecture provides four critical security guarantees:

1. User devices never directly access third-party services
2. All external calls are mediated through Magentic Bazaar
3. JSON-RPC-LD ensures semantic validation of all messages
4. Zero-trust model: Every message is validated against SHACL shapes

## Diagram 4: User Types and Access Patterns

![User Types and Access Patterns](User_Types_and_Access_Patterns.png)

### User Type Categories

The platform supports four distinct user types, each with tailored authentication and access patterns:

#### Individual User
- Personal account with email/password authentication
- Multiple devices synchronized under a single identity
- Personal usage limits and quotas
- Full access to all platform features

#### Group User
- Team or organization account with shared resources
- Team-based permissions and role assignments
- Collaborative features for shared workspaces
- Shared usage quotas across team members
- Team management capabilities

#### Developer
- API access with programmatic authentication
- SDK and CLI tools for automation
- API key-based authentication
- Higher rate limits for development use cases
- Access to developer documentation and sandbox environments

#### Platform User (Federated)
- Enterprise single sign-on (SSO) integration
- OAuth and SAML support for federated identity
- Cross-platform access with unified credentials
- Enterprise security policies and compliance features
- Integration with corporate identity providers

### Unified Communication Protocol

Despite the diversity of user types and devices, all communication flows through the same JSON-RPC-LD WebSocket protocol. This provides:

- **Unified Interface**: Same API surface for all clients
- **Consistent Security Model**: Identical authentication and authorization flows
- **Same Validation Rules**: All messages validated with SHACL shapes
- **Zero-Trust Architecture**: Every request is authenticated and authorized

### Access Point Flexibility

Each user type can access the platform through multiple devices simultaneously:

- Individual users can use laptops, phones, and tablets
- Group users can share workstations while maintaining individual mobile access
- Developers can use development laptops, server applications, and CLI tools
- Platform users can access through enterprise workstations, federated apps, and SSO portals

All devices maintain synchronized state, ensuring a seamless experience when switching between access points.

## JSON-RPC-LD Protocol

The JSON-RPC-LD protocol is a lightweight extension to JSON-RPC 2.0 that adds semantic meaning and validation capabilities. It is the exclusive communication protocol between client devices and the Magentic Bazaar platform.

### Key Features

**Mandatory @context**: Every request and response must include a `@context` field that provides semantic meaning to the data. This context maps terms to IRIs (Internationalized Resource Identifiers), enabling the data to be interpreted as Linked Data.

**SHACL Validation**: The platform provides SHACL (Shapes Constraint Language) shapes that define the expected structure and types of parameters and results for each method. All messages are validated against these shapes before processing.

**Zero-Trust Security**: The protocol enforces a zero-trust security model where no data types are unconstrained. All data must be explicitly defined through JSON-LD contexts and validated against SHACL shapes.

### Example Request

```json
{
  "jsonrpc": "2.0",
  "method": "llm.complete",
  "params": {
    "@context": {
      "prompt": "http://schema.org/text",
      "model": "http://example.org/model"
    },
    "prompt": "Summarize this document",
    "model": "gpt-4"
  },
  "id": 1
}
```

### Example Response

```json
{
  "jsonrpc": "2.0",
  "result": {
    "@context": {
      "completion": "http://schema.org/text",
      "usage": "http://example.org/usage"
    },
    "completion": "Summary text...",
    "usage": {"tokens": 150}
  },
  "id": 1
}
```

## Implementation Considerations

### WebSocket Connection Management

The platform must handle thousands of concurrent WebSocket connections from diverse clients. Key considerations include:

- Connection pooling and load balancing across multiple gateway instances
- Automatic reconnection with exponential backoff for client libraries
- Heartbeat/ping-pong mechanisms to detect stale connections
- Graceful degradation when backend services are unavailable

### Message Validation Performance

SHACL validation can be computationally expensive. The platform should implement:

- Caching of compiled SHACL shapes for fast validation
- Asynchronous validation for non-critical paths
- Validation result caching for repeated message patterns
- Performance monitoring to identify validation bottlenecks

### Third-Party Service Integration

The platform acts as a proxy for all third-party services. This requires:

- Robust retry logic with exponential backoff for failed API calls
- Circuit breaker patterns to prevent cascading failures
- Request queuing and rate limiting to respect provider limits
- Response caching where appropriate to reduce external API calls
- Comprehensive error handling and user-friendly error messages

### Multi-Tenancy and Isolation

The platform must ensure proper isolation between users and organizations:

- Database-level isolation using row-level security or schema separation
- API key rotation and secure credential storage
- Audit logging of all access to sensitive resources
- Resource quotas and rate limiting per user/organization

## Scalability Architecture

### Horizontal Scaling

The architecture supports horizontal scaling at multiple layers:

- **API Gateway**: Multiple gateway instances behind a load balancer
- **Core Services**: Stateless service instances that can be scaled independently
- **Database**: Read replicas for query workloads, connection pooling
- **WebSocket Connections**: Distributed across gateway instances with sticky sessions

### Caching Strategy

To reduce load on backend services and improve response times:

- **Redis Cache**: For frequently accessed data (user profiles, configurations)
- **CDN**: For static assets and public content
- **Response Caching**: For deterministic API responses (e.g., skill definitions)
- **Connection Pooling**: For database and third-party API connections

## Monitoring and Observability

### Metrics Collection

The platform should collect comprehensive metrics:

- WebSocket connection counts and durations
- Request rates and latencies per endpoint
- Third-party API call rates and response times
- Error rates and types
- Resource utilization (CPU, memory, network)

### Logging Strategy

Structured logging should capture:

- All JSON-RPC-LD requests and responses (with PII redaction)
- Authentication and authorization events
- Third-party API calls and responses
- Error conditions and stack traces
- Performance metrics and slow queries

### Alerting

Proactive alerting should notify operators of:

- Service degradation or outages
- Unusual error rates or patterns
- Rate limit violations
- Security events (failed authentication, suspicious activity)
- Resource exhaustion (disk space, connection limits)

## Security Considerations

### Authentication and Authorization

The platform implements multiple authentication mechanisms:

- **Email/Password**: For individual users with bcrypt password hashing
- **API Keys**: For developers with secure key generation and rotation
- **OAuth/SAML**: For federated platform users with enterprise SSO
- **JWT Tokens**: For session management with short expiration times

Authorization is enforced at multiple levels:

- **Gateway Level**: Validates tokens and checks basic permissions
- **Service Level**: Enforces fine-grained access control for specific resources
- **Database Level**: Row-level security policies for data isolation

### Data Protection

All sensitive data is protected:

- **Encryption at Rest**: Database encryption for sensitive fields
- **Encryption in Transit**: TLS 1.3 for all WebSocket and HTTPS connections
- **API Key Storage**: Encrypted storage with hardware security module (HSM) support
- **PII Handling**: Redaction in logs, minimal retention, GDPR compliance

### Audit Logging

Comprehensive audit logs capture:

- User authentication and authorization events
- Configuration changes and administrative actions
- Access to sensitive resources
- Third-party API calls with request/response data
- Security events and anomalies

## Conclusion

The Magentic Bazaar multi-platform architecture provides a secure, scalable, and unified approach to delivering LLM, MCP, and SKILL services across diverse devices and user types. By enforcing JSON-RPC-LD communication with zero-trust security and exclusive service intermediation, the platform ensures that all interactions are semantically validated, properly authenticated, and comprehensively audited.

The architecture supports multiple user types (individual, group, developer, platform/federated) through a unified protocol while maintaining flexibility in authentication and access patterns. All third-party service calls are mediated through the Magentic Bazaar platform, providing centralized control, security, and observability.

This design provides a solid foundation for building a production-ready service that can scale to support thousands of users across multiple devices while maintaining the highest standards of security and reliability.

