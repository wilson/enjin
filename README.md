### enjin: Meta as a Service
### 円陣: クラウドのむこう

> clouds endless clouds climbing beyond
>
> ask nothing from words on a page
>
> 一休宗純 (Ikkyu)

### Core principles

* The Corrolary to Moore's Law implies that stack depth gets cheaper over time
* Linear increases in stack depth represent exponential increases in abstraction
* Your Hypervisor can read your memory, live with it.

### Description

Pick your own altitude in the cloud. Always a work in progress.

Today's popular cloud implementations generally target a single abstraction of computing, and offer a product or set of products using it. "Ruby Cloud", "Node.js Cloud", are the terms of the day. Customers often have complex and evolving needs however, and most clouds either abdicate automation of key infrastructure (e.g. key management, failure recovery, DNS), or box customers in a limited platform abstraction to simplify maintenance and development. This is understandable, and many such products are successful. If customer needs change enough, previous decisions can start to look like fierce technical debt.

### Rules

* Commercial cloud or your hardware guarded with guys with rifles
* Learn from the domain of hierarchical protection to unify IaaS and PaaS
* Don't write encryption software
* No clouds that can't host and deploy themselves
* Build a truly fault-tolerant open-source multi-cloud abstraction

What does that mean? Just as UNIX systems can create unprivileged users, the IaaS layer should be able to call upon the resources of PaaS-style service implementations to do its business. It owns them, after all.

### Concepts

ring 0 is Meta as a Service, ring 1 is Infrastructure as a Service, ring 2 is Platform as a Service.

* a 'ring 0' node communicates on the ring 0 network and is expected to be able to supervise 'ring 1' nodes
* a 'ring 1' node communicates on the ring 1 network and is expected to be able to supervise 'ring 2' nodes
* a 'ring 2' node typically supervises only its own internal processes

One possible ring 2 node is a UNIX user, but it could be a nested VM or FreeBSD jail.
In a PaaS offering a ring 2 node would generally be serving HTTP traffic on a port allocated to it by ring 1.

A ring 0 node could be a physical machine, a VM with the privileges required to instantiate others like itself, or anything else with suitable resources.

Each ring manages the ACLs and keys for the ring it contains.
Rings communicate with private pub/sub networks e.g. ZeroMQ, NATS, &c.
Private channels accept onl signed messages from whitelisted origins.

### Infrastructure as a Service (IaaS)

Groups of machines that share a locality, either physical (in the same rack) or logical (on some mysteriously-fast private network with each other) are a key abstraction for infrastructure.
Let's call them 'Compartments'. They might as well be able to contain other compartments, and be a directed graph. Think NUMA shenanigans. Ring 0 cares about these though ring 1 agents have limited ability to request to be instantiated in a specific one.

> I would like to collect power usage metrics at this level as well, especially since actual machines in racks these days tend to be homogenous. HP has their neat vertically-cooled blades, Cisco has the 'Unified Computing System', &c.

These compartments can share private communications with each other, and agree on reciprocal access to each other if needed. Assume such links have the semantics of OpenVPN.
In an IaaS offering, both ring 1 (the services running the product) and ring 2 (customer instances) may be running on the same hypervisor.

### Platform as a Service (PaaS)

In a PaaS offering, ring 2 nodes are 'applications', rather than VMs.
Plan for multi-tenant capabilities; once you have them, single-tenant is a degenerate case.
Practical options for multi-tenant, lightest to heaviest:

* ring 1 is a UNIX box where apps run as separate locked-down users
* ring 1 is a FreeBSD box (lol) where apps run in separate jails
* ring 1 is a box running a hypervisor where apps run in separate VMs
* ring 1 is a mysterious combination of the above

Ring 2 nodes are therefore PaaS apps and are in the end simply open sockets managed by the ring 1 agent.
Successfully presenting that illusion requires various other machinery running in ring 1, such as HTTP routers, a watchdog process for apps, &c.
Arguably a 'ring 2 compartment' is analogous to 'customer application environment running various instances' at this layer. The chosen configuration (using the various implemented strategies) determines what actually happens at the end of the day. There are as many possible clouds as there are potential managed product offerings.

### What Goes Where

ring 0 services:

* meta http api
* key generation
* node authentication
* traffic managers, bastions
* ring 0 resource allocation (bootstrap)
* ring 1 resource allocation

ring 1 services:

* http api
* user authentication
* distributed data
* package management (os packages,gems, &c)
* vm pool management
* infrastructure monitoring
* job execution (code updates, periodic tasks, &c)
* ring 2 resource allocation (e.g. running multi-tenant user code)

ring 2 services:

* deployment packaging
* sockets and traffic management
* application monitoring
* backup and recovery
* logging
* metric collection

### Whats That Go Where

(TODO: This section now seems quaintly out of date)

    User
    Role
    Membership
    Network
    NetworkInterface
      >  ring
      >  strategy (e.g. vpn or local)
    AccessRuleSet
    AccessRule
    Compartment
      > ring
      > parent_compartment
    Node
      >  uuid
      >  ring
      >  label
      >  supervision_strategy
      >  compartment
    JobOffer
    NodeObservation
      >  node_id
      >  observation_strategy
      >  state
      >  timestamp

![Mimosa](http://farm2.static.flickr.com/1124/909585864_b603258792_m.jpg "Mimosa")

つずく。。
