---
layout: post
title: Building Cloud Native Network Functions using Rust
author: CNDP Team
---

The [Rust](#rust) programming language has been steadily gaining
popularity over the last several years. Many developers and companies use
Rust in production today for fast, low-resource, cross-platform
solutions. Rust is fast and memory efficient, with no runtime or garbage
collector. It also has a rich type-system and ownership model with
guarantees for memory and thread safety which eliminates many classes of
bugs at compile-time. Rust's predictable performance, low resource
footprint, reliability, security, and fearless concurrency at scale
makes it a good candidate for building Cloud native Network Functions
(CNFs).

There is a growing list of cloud native applications and services built
using Rust. [AWS firecracker](#aws-fire-cracker) and [Linkerd service mesh
proxy](#linkerd) are two examples. More projects could be found at [Rust
Cloud Native GitHub](#rust-cloud-native-github).

This paper describes how Rust applications can be integrated with the
Cloud Native Data Plane ([CNDP](#cndp-io)) to rapidly develop flexible and
high-performance packet processing applications.

CNDP is a set of user space libraries created to address the need for a
data plane framework designed for packet processing microservices in
cloud deployments. CNDP aims to provide better performance than standard
network socket interfaces using an I/O layer primarily built on Linux
[AF_XDP](#af-xdp), an address family that is optimized for high
performance packet processing. It provides an interface that delivers
packets directly to user space, bypassing the kernel networking stack.
More details on CNDP can be found at [cndp.io](#cndp-io)

### CNDP Rust Crate

CNDP is natively implemented in the C programming language. CNDP
provides language bindings for Rust which enable cloud native developers
to build user space network functions using Rust and CNDP. The CNDP Rust
crate provides high-level APIs that allow a Rust developer to interact
with CNDP without having to fully understand the low-level details. It
abstracts the complexities of network I/O and memory buffer management,
allowing the developer to focus on their application.

Rust interfaces with C with minimal overhead using a Foreign Function
Interface (FFI) to C libraries. Rust provides two modules *std::ffi* and
*std::os::raw* for transforming data types between Rust and C. In
addition, Rust has tools like [bindgen](#rust-bindgen) which
automatically generate Rust FFI bindings to C.

CNDP provides two Rust crates

1.  Low-level bindings crate (cne-sys) which exposes a minimal low-level
    C interface to Rust.

2.  High-level Rust APIs crate (cne) which uses low-level bindings
    crate.

Since CNDP is built on AF_XDP, it delivers packets directly to user
space, bypassing the kernel networking stack. Rust user space network
functions using the CNDP CNE crate can benefit from the network I/O
performance offered by Linux kernel AF_XDP. It's expected that most Rust
applications using CNDP only require the high-level Rust API crate and
should not program directly to low-level crate.

<div class="text-center">
 <figure class="figure">
  <img src="/assets/images/blog/CNDP-Rust-Crate.png" class="figure-img img-fluid" alt="CNDP Rust Crate">
  <figcaption class="figure-caption text-center">Figure 1: CNDP Rust Crate</figcaption>
 </figure>
</div>


Figure 1 shows how the Rust application relates to CNDP and its Rust
crates.

The CNDP CNE Rust crate provides the following functionality.

1.  Interface to configure the underlying system using a human readable
    JSON-C file format.

2.  Higher level abstraction for AF-XDP socket (using Port interface) to
    send and receive network packets from/to user space from multiple
    threads and to get network I/O statistics for this Port.

3.  Higher level abstraction for packets (using Packet interface) which
    are sent and received to/from AF-XDP socket without additional
    memory copy overhead. This is possible because Rust allows access to
    C memory pointers.

4.  Creates and provides access to single instance of CNDP per process
    since CNDP design allows only single instance per application
    process.

5.  Hides the complexities of "unsafe" Rust which is a mode of Rust
    which gives the programmer more autonomy (for example it allows to
    operate on raw C-like pointers), but it doesn't provide memory
    safety guarantees enforced by Rust at compile time and the code may
    break.

In addition to CNDP Rust crates, CNF and Cloud application developers
can also leverage CNDP Kubernetes deployment models for their
applications using the [AF-XDP device plugin and CNIs](#af-xdp-dp).

#### Example Applications using the CNDP Rust Crate

Following are some example applications developed using the CNDP CNE
Rust high-level API crate.

1)  Echo server implementation using CNDP CNE and [libpnet](#libpnet)
    crate. CNDP receives and sends layer 2 packets using AF-XDP socket.
    The libpnet receives and sends layer 2 packets using AF_PACKET.

2)  Wireguard Rust user space VPN uses the CNDP CNE Rust Crate for
    optimized network I/O. More details on CNDP Rust Wireguard
    implementation can be found [here](#cndp-rust-wg).

During development of the Rust CNDP crate, several memory and thread
safety issues were fixed at compile time itself, thanks to Rust
ownership and concurrency model. Wireguard VPN was able to send/receive
Wireguard UDP packets via AF_XDP sockets (using CNDP CNE Rust crate)
from multiple threads safely using Rust's concurrency model.

#### How to get the CNDP Rust Crate

The Rust CNE crate is not yet published in [Rust package
registry](#rust-registry). The CNDP Rust crate is hosted on
[GitHub](#cndp-rust-crate-github) along with documentation and example
applications. To use the CNDP Rust CNE crate in your application,
directly get it from CNDP GitHub and include it in your project's
*Cargo.toml* file as shown below.

`cndp-cne = {git = "https://github.com/CloudNativeDataPlane/cndp",
branch = "main"}`

The [readme](https://github.com/CloudNativeDataPlane/cndp/blob/main/lang/rs/README.md)
document gives more details on how to setup CNDP and run example Rust applications.

### Summary

The Rust ecosystem is continuously growing, and it's expected that many
more cloud native applications will be developed using Rust due to its
inherent features suitable for cloud native development.

Since CNDP is implemented in C language, we created CNDP Rust crate to
expose high-level APIs allowing a Rust developer to interact with CNDP.
The high-level Rust APIs abstract the low-level network I/O complexities
and enable cloud native developers to build high performance packet
processing applications using Rust and deploy at cloud scale.

While the learning curve of Rust may slow you down, we gain much more in
terms of predictable performance, low resource footprint, memory and
thread safety, security, concurrency at scale required for building
Cloud native Network Functions (CNFs).

### References

1.  <a id="af-xdp"> AF_XDP -
    <https://www.kernel.org/doc/html/v4.18/networking/af_xdp.html> </a>

2.  <a id="af-xdp-dp"> AF-XDP device plugin and CNIs for k8s -
    <https://github.com/intel/afxdp-plugins-for-kubernetes> </a>

3.  <a id="aws-fire-cracker"> AWS firecracker - <https://firecracker-microvm.github.io> </a>

4.  <a id="cndp-io"> CNDP - <https://cndp.io> </a>

5.  <a id="cndp-rust-wg"> CNDP Rust Wireguard -
    <https://cndp.io/guide/sample_app_ug/WireGuard.html> </a>

6.  <a id="cndp-rust-crate-github"> CNDP Rust crate -
    <https://github.com/CloudNativeDataPlane/cndp/tree/main/lang/rs> </a>

7.  <a id="libpnet"> Libpnet crate - <https://docs.rs/pnet/latest/pnet> </a>

8.  <a id="linkerd"> Linkerd service mesh proxy -
    <https://linkerd.io/2020/07/23/under-the-hood-of-linkerds-state-of-the-art-rust-proxy-linkerd2-proxy> </a>

9.  <a id="rust"> Rust - <https://www.rust-lang.org> </a>

10. <a id="rust-bindgen"> Rust Bindgen <https://rust-lang.github.io/rust-bindgen> </a>

11. <a id="rust-cloud-native-github"> Rust Cloud Native GitHub -
    <https://rust-cloud-native.github.io> </a>

12. <a id="rust-registry"> Rust Package Registry - <https://crates.io> </a>
