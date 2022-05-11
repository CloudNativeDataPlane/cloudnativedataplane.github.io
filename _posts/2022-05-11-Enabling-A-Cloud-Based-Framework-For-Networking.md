---
layout: post
title: Enabling a cloud-based framework for networking
author: Rajesh Gadiyar
excerpt_separator: <!--more-->
---

### The Motivation for CNDP

As software has moved to the cloud, software development has also changed; from virtual machines
to containers and from monolithic to microservices. But the ability to deploy and manage
networking functions efficiently in a cloud native environment has been lacking. Intel has been
looking into this gap and developed CNDP, an open-source solution to address cloud native
networking.

<!--more-->

### What is CNDP?

<div class="text-center">
 <figure class="figure">
  <img src="/assets/images/blog/CNDP-Overview.png" class="figure-img img-fluid" alt="CNDP Overview">
  <figcaption class="figure-caption text-center">Figure 1: CNDP Overview</figcaption>
 </figure>
</div>

CNDP is a set of user space libraries (Figure 1) created to address the need for a data plane
framework designed for packet processing microservices in cloud deployments.

* Abstracting software from hardware to deploy application components flexibly throughout public,
  hybrid, and private cloud
* Provisioning, orchestrating, and managing microservices at scale efficiently with close alignment
  to Kubernetes deployments
* Built on top of standard Linux libraries for open-source CI/CD

### Where to use CNDP?

Intel has engaged with CoSPs, enterprise security, wireless core, and RAN partners to identify
areas where CNDP's capabilities can be best utilized in cloud deployments. The libraries will take
advantage of Intel Technologies to maximize performance and provide product differentiation. These
CNDP components are key elements that enable ease of adoption and allow developers to focus on
business logic.

* Implementing packet classifiers, flow tables, Access Control Lists (ACLs), and routing
  information bases with CNDP's optimized libraries on top of network interfaces using AF_XDP for
  hardware abstraction benefits firewalls, load balancers, and gateways
* Accelerating packet processing for service meshes with a user space network stack to free compute
  cycles and increase capacity to execute more services
* Integrating tightly with Rust and Go run times to align with a broad section of cloud developers
  whose workloads can benefit from CNDP

Developers with pain points that CNDP can address may take this opportunity to learn more. For
additional information, please go to [https://cndp.io/](https://cndp.io/).
