# Tooling Roadmap

* Status: DRAFT
* Version: v2023.Q2

## Index

[TOC]

## Introduction

This roadmap deals with tools and libraries for Onion Services.

## Developing

From the development perspective, a generic "Onion Service Stack" could be
useful for anyone:

1. Not wanting to bother with IP allocation and routing.
2. Wishing DoS protections built-in the stack (hopefully true when PoW
   is fully working).
3. Interested in all other Onion Service properties.

So adoption could be encouraged not only to applications that really
need anonymity/privacy/anti-censorship. And not only to "native"
Onion Service applications (i.e, those which requires the technology
to work), but also to "hybrid" ones (in the sense that they could
fallback to non-onion connections).

Being a bit more specific, the following properties are desirable
for Onion Service libraries:

* [ ] It should be really easy to develop an application based on Onion
      Services:
  * [ ] Setting up the development environment should be easy.
  * [ ] Doing the actual development should be easy.
* [ ] Porting to different systems and architectures should be supported.
* [ ] Packaging and distributing applications should be easy.
* [ ] Best-practices should also be provided to avoiding risking privacy and
      security of users.
* [ ] Consider whether Tor should also provide Quality Assurance / Audits /
      Certification on the software. Otherwise it may be easy to make low quality
      software and promote it as "Onion Services" capable.
* [ ] Bring built-in Onion Services support to existing popular webservers
      (as plugin, modules etc, optionally pre-packaged) (this item
      is more web-oriented).

Additionally:

* Libraries should have good documentation for newcomers (that can be
  hard to do until the library is stable enough).
* Some simple examples need to be provided, for learning purposes or
  as boilerplates for more complex applications.
* Having bindings for popular languages like Python and JavaScript.
  Maybe a library could be distributed as a binary with those bindings.

For reference, [Stem][] and [txtorcon][] are good examples: they're easy
to install, relatively easy to develop and both have good documentation
and API.

[Stem]: https://stem.torproject.org/
[txtorcon]: https://txtorcon.readthedocs.io/

## Operating

* The [Onion Services][] technology currently is not very well integrated into
  development/operation (DevOps) solutions.
* Toolset and configurations are needed to make system administration life
  easier, including Onion Services' keys life cycle.
* This document is still a placeholder to outline tooling improvements to make
  easier to manage [Onion Services][].

[Onion Services]: https://community.torproject.org/onion-services

### Onionbalance (scaling)

* Needs to [define a new maintainer](https://gitlab.torproject.org/tpo/core/onionbalance/-/issues/10).
* Improvements package. Which
  [issues](https://gitlab.torproject.org/tpo/core/onionbalance/-/issues) to
  include?

### Onionprobe (metrics)

* [Onionprobe][]: a tool for testing and monitoring status of Tor Onion Services.
* There are many improvements towards making it kind of a multi-tool for Onion Services testing and debugging.
* For 2023, the initial workload estimate for Onionprobe sums up to 1 month full time dedication.
* Improvements package need to be defined. Which
  [issues](https://gitlab.torproject.org/tpo/onion-services/onionprobe/-/issues)
  to include?

[Onionprobe]: https://tpo.pages.torproject.net/onion-services/onionprobe/

### Oniongrove (management)

* [Oniongroove][]: a suite for Onion Services deployment.
* Right now it's only an specification, and we hope to make a prototype still on 2023.
* It should probably be built with Arti from start.
* For 2023, the initial workload estimate for Onionprobe sums up to 2 months full time dedication,
  which could be concentrated in:
    * Reviewing specs.
    * Creating the [threat model](https://gitlab.torproject.org/tpo/onion-services/oniongroove/-/issues/2).
    * Finishing [deployment research](https://gitlab.torproject.org/tpo/onion-services/oniongroove/-/issues/1).
    * Doing the initial proof of concept implementation.

[Oniongroove]: https://tpo.pages.torproject.net/onion-services/oniongroove/

### Vanguards (protections)

* Improvements package. Which
  [issues](https://github.com/mikeperry-tor/vanguards/issues) to include?

### Other

* [Stem][]: seems not to be maintained, but many Onion Services applications
  depends on it.
* Interesting contributions from the community:
    * [https://github.com/bugfest/tor-controller][]
    * [https://codeberg.org/systemfailure.net/ansible_onion_services][]

[Stem]: https://stem.torproject.org/
[https://github.com/bugfest/tor-controller]: https://github.com/bugfest/tor-controller
[https://codeberg.org/systemfailure.net/ansible_onion_services]: https://codeberg.org/systemfailure.net/ansible_onion_services
