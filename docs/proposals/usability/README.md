# Introduction on Onion Services Usability proposals

## About

This section summarizes the relevant proposals related to improve Onion
Services usability by offering:

1. [Certification](certificates.md): to
   securely tie a TLS/HTTPS certificate (and optionally an organization) to a
   given onion service.
2. [Service discovery](discovery/README.md): address
   translation or alternative naming systems for censorship and forgery
   resistant name discovery/lookup.

## Coexistence between implementations

This research analyzes many different proposals, which at first may not be
compatible with each other. Here we try see whether implementations can coexist
and what should be the minimum requirements for a proposal, in two levels:

1. **Technical specs**: for proposing and implementing service discovery and
   certification methods. What a proposal should have in order to be valid?
2. **Governance specs**: criteria and decision making procedures to
   accept or reject proposals.

These specs does not exist right now. Creating them is part of the plan.

## Towards prioritization criteria

Having valid proposals is just part of the plan: prioritizing which ones should
be considered first is the next step in roadmapping. Here we give some suggestions:

0. Rule out experimental or disruptive technology.
1. What can be implement by Tor developers?
2. What depends in other people/groups/community?
3. What depends on discussing/consensus due to different "world views" at Tor?
4. What depends on little-Tor implementation (specially due to current
   prioritization on [Arti][])?
5. What significantly increases the Tor Browser package size and then should be
   considered with care?
6. What is most important?
7. What could be included in sponsor work?
8. What would only work for modified clients such as The Tor Browser,
   not working by default to all use-cases such as `torify curl`.
9. Which (or part) of all proposals can be combined in a long-term (or
   incremental) solution?

[Arti]: https://gitlab.torproject.org/tpo/core/arti/

## Further references

### Other relevant usability proposals

There are some proposals currently not evaluated in this research, but are
listed here due to it's relevance or to be included in future:

* Onion Services implementation:
    * [Onion Service Revocation](https://gitlab.torproject.org/tpo/core/torspec/-/issues/87).
    * [prop224: Implement offline keys for v3 onion services (#29054)](https://gitlab.torproject.org/tpo/core/tor/-/issues/29054).
* Tor Browser:
    * [Verification of onion service integrity (#41041) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41041).
    * [URI scheme for Tor (#41017) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41017).

<!--
### Related issues

* [Organize documentation about Onion Services UX improvements](https://gitlab.torproject.org/tpo/onion-services/onion-support/-/issues/64).
* [Create Onion alias url for torproject.org sites](https://gitlab.torproject.org/tpo/onion-services/onion-support/-/issues/67).
-->

### Past discussions

This research is heavily inspired by previous documentation:

* [202209MeetingOnionPlan](https://gitlab.torproject.org/tpo/team/-/wikis/202209MeetingOnionPlan).
* [S27: Onion Services Project Planning](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2019/2019Stockholm/Notes/S27).
* [OnionV3ux](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2018/2018MexicoCity/Notes/OnionV3ux).
* [OnionServiceNamingSystems](https://gitlab.torproject.org/legacy/trac/-/wikis/doc/OnionServiceNamingSystems).

### Other research

* [USENIX Security '18 - How Do Tor Users Interact With Onion Services? - YouTube](https://www.youtube.com/watch?v=MYR4sB3wPOg)
  ([paper](https://nymity.ch/onion-services/pdf/sec18-onion-services.pdf)).
