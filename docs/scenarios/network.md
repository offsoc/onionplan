# Network Layer Roadmap Scenarios

* Version: v2024.Q3

## DoS defenses

### The problem

* [Tor is slow right now. Here is what is happening. | The Tor Project](https://blog.torproject.org/tor-network-ddos-attack/)

### Proposal 327

About:

* [proposals/327-pow-over-intro.txt · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/327-pow-over-intro.txt)
* [Proposal: A First Take at PoW Over Introduction Circuits](https://lists.torproject.org/pipermail/tor-dev/2020-April/014215.html)

Status:

* Implemented on Tor 0.4.8.4 as part of the "Onion Services resource
  coalition" sponsored work.
* Check the [PoW FAQ](https://gitlab.torproject.org/tpo/onion-services/onion-support/-/wikis/Documentation/PoW-FAQ) for details.

### Relevant DoS-related issues

* [Design a PoW scheme for HS DoS defence (#134) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/134)
* [prop327: Implement PoW over Introduction Circuits (#40634) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/40634)
* [Understand code performance of onion services under DoS (#33704) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/33704)
* [Research  approaches for improving the availability of services under DoS  (#31223) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/31223)
* [attacker can force intro point rotation by ddos (#26294) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/26294)
* [DoS resistence measures from C tor (#351) · Arti](https://gitlab.torproject.org/tpo/core/arti/-/issues/351)

## Performance improvements

* Needs input from the Network Team for what can be included here.

## Metrics

* Needs input from the Network, Network Health and Metrics Teams for what can be included here.

## Non DoS-related health improvements for Onion Services

Fixes:

* [Make it even harder to become HSDir (#19162) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/19162)
* [We should make HSv3 desc upload less frequent (#163) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/163)
* [Tor  node that is not part of the consensus should not be used as rendezvous  point with the onion service (#33129) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/33129)
* [hs: Do not allow more than one control cell on a circuit (#157) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/157)
* [Long circuit build times when connecting to onion services (#40570) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/40570)

Features, probably only for [arti](https://gitlab.torproject.org/tpo/core/arti/):

* [Proposal: Hidden Service Revocation (#87) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/87)
* ['Hidden' Authenticatd Onion Services (#119) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/119)
* [prop224: Implement offline keys for v3 onion services (#29054) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/29054)

## Relevant metrics feature requests

* [Add backend ID when exposing circuitid with HiddenServiceExportCircuitID (#32428) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/32428)
    * [Create new directive HiddenServiceExportStats. (#32690) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/32690)
    * [Add an optional flag for the export circuit id protocol on the port-by-port basis (#40530) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/40530)
    * [Tor should provide a mechanism for hidden services to differentiate authorized clients and circuits (#4700) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/4700)
    * [Add features improving onion services' interaction with Tor. (#32511) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/32511)
* [Additional metricsport stats for various stages of onionservice handshake (#40717) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/40717)

## Onion Service support in Arti

Check:

* Arti's [1.1.3](https://blog.torproject.org/arti_113_released/) and
  [1.1.4](https://blog.torproject.org/arti_114_released/) release notes for
  initial client implementation.
* Arti's [1.1.8](https://blog.torproject.org/arti_118_released/): for Onion service
  server infrastructure.
* Arti's [1.1.9](https://blog.torproject.org/arti_119_released/): Assembling
  the onions.
* [Arti 1.2.7: onion services, RPC, and more](https://blog.torproject.org/arti_1_2_7_released/)
* [Arti 1.2.6: onion services, RPC, and more](https://blog.torproject.org/arti_1_2_6_released/)
* [Arti 1.2.5: onion services development, security fixes](https://blog.torproject.org/arti_1_2_5_released/)
* [Arti 1.2.4: onion services development, security fixes](https://blog.torproject.org/arti_1_2_4_released/)
* [Arti 1.2.3 (security release)](https://blog.torproject.org/arti_1_2_3_released/)
* [Arti 1.2.2: onion services development](https://blog.torproject.org/arti_1_2_2_released/)
* [Arti 1.2.1: onion services development](https://blog.torproject.org/arti_1_2_1_released/)
* [Arti 1.2.0: onion services development](https://blog.torproject.org/arti_1_2_0_released/)

## Relevant issue boards

* [Onion Services in general](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services)
* Onion Services performance issues:
    * [Performance Impact](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services&label_name[]=Performance%20Impact)
    * [Performance](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services&label_name[]=Performance)
    * [DoS](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services&label_name[]=DoS)

## References

* [Proposal 327: A First Take at PoW Over Introduction Circuits](https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/327-pow-over-intro.txt).
