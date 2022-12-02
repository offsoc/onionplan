# Introduction

<!--[[_TOC_]]-->

## About

This section summarizes the relevant proposals related to improve Onion
Services usability by offering:

1. [Certification](Certification): to
   securely tie a TLS/HTTPS certificate (and optionally an organization) to a
   given onion service.
2. [Service discovery](Discovery): address
   translation or alternative naming systems for censorship and forgery
   resistant name discovery/lookup.

## Coexistence between implementations

It's possible to make implementations to coexist, which needs:

1. **Technical specs**: for proposing and implementing service discovery and
   certification methods. What a proposal should have in order to be valid?
2. **Governance specs**: criteria and decision making procedures to
   accept or reject proposals.

These specs does not exist right now. Creating them is part of the plan.

## Towards prioritization criteria

Suggestions about how to prioritize:

0. Rule out experimental or disruptive technology.
1. What can be implement by Tor developers?
2. What depends in other people/groups/community?
3. What depends on discussing/consensus due to different "world views" at Tor?
4. What depends on little-Tor implementation (specially due to current
   prioritization on arti)?
5. What significantly increases the Tor Browser package size and then should be
   considered with care?
6. What is most important?
7. What could be included in sponsor work?
8. What would only work for modified clients such as The Tor Browser,
   not working by default to all use-cases such as `torify curl`.
9. Which (or part) of all proposals can be combined in a long-term (or
   incremental) solution?

## Further references

### Other relevant usability proposals

* [Verification of onion service integrity (#41041) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41041).
* [URI scheme for Tor (#41017) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41017).
* [Onion Service Revocation](https://gitlab.torproject.org/tpo/core/torspec/-/issues/87)..
* [prop224: Implement offline keys for v3 onion services (#29054)](https://gitlab.torproject.org/tpo/core/tor/-/issues/29054).

### Related issues

* [Organize documentation about Onion Services UX improvements](https://gitlab.torproject.org/tpo/onion-services/onion-support/-/issues/64).
* [Create Onion alias url for torproject.org sites](https://gitlab.torproject.org/tpo/onion-services/onion-support/-/issues/67).

### Past discussions

* [202209MeetingOnionPlan](https://gitlab.torproject.org/tpo/team/-/wikis/202209MeetingOnionPlan).
* [S27: Onion Services Project Planning · Wiki · Organization](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2019/2019Stockholm/Notes/S27).
* [OnionV3ux · Organization · GitLab](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2018/2018MexicoCity/Notes/OnionV3ux).

### Talks

* [USENIX Security '18 - How Do Tor Users Interact With Onion Services? - YouTube](https://www.youtube.com/watch?v=MYR4sB3wPOg).
