# Usability Roadmap Scenarios - User Experience (UX)

* Version: v2023.Q2

## Summary

This document tracks other relevant usability improvements, mostly related to
user experience for tools like [Tor Browser][].

Needs input from UX and Applications Teams on what to include in the roadmap.

[Tor Browser]: https://www.torproject.org/download/

## Tor Browser

### Quality Assurance

* Quality Assurance for Tor Browser regarding Onion Services (initial workload
  estimate for 2 months full time during 2023.Q3 - 2024.Q2).

### Onion-Location for Tor Browser

* Desktop only:
    * [Easier flow to navigate back to clear-URL after an Onion-Location redirect (#40031)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40031).
* Mobile only:
    * [Implement Onion Location UI on Android (#41230)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41230).
* Desktop and mobile:
    * [Onion-Location icon takes too long to appear (#40100)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40100),
      only after the page is fully loaded. Is there's a reasoning/need for this behavior?
    * [non-onionsite gives interstitial "Onionsite Has Disconnected" page (#40434)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40434).
    * [Onion rewrites should add eTLDs (#41022)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41022).

### Alt-Svc

* [Verify onion reachability before redirect (#40637)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40637)
* [Indicate Alt-Svc Onion explicitly in the urlbar (#40587)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40587).
* [Show onion redirects in the tor circuit panel (#41703)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41703)
  (previously: [Display .onion alt-svc route in the circuit display (#27590)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/27590)).

### Other UI fixes

* [Onion Services show broken padlock instead of Secure Onion icon in the URL
  bar on Android (#41087)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41087).
* [Verify features that are made "HTTPS-only" should be available on .onion sites as well (#21728)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/21728)
* [Setting Origin: null header still breaks CORS in Tor Browser 9.5 (#32865)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/32865)
* [document.referrer leaks hidden service to clearnet service. (#25484)](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/25484)

## Existing research

This section contain references on some existing research to improve Onion
Services usability from the User Experience (UX) perspective:

* 2018:
    * [How Do Tor Users Interact with Onion Services? - sec18-onion-services.pdf](https://nymity.ch/onion-services/pdf/sec18-onion-services.pdf):
        * [USENIX Security '18 - How Do Tor Users Interact With Onion Services? - YouTube](https://www.youtube.com/watch?v=MYR4sB3wPOg).
* 2017:
    * [Take Part in a Study to Help Improve Onion Services | The Tor Project](https://blog.torproject.org/take-part-study-help-improve-onion-services/):
        * [Onion service interaction](https://nymity.ch/onion-services/).
    * [Leakage of .onion at the DNS Root: Measurements, Causes, and Countermeasures](https://seal.cs.ucf.edu/doc/tnet17.pdf)
      ([discussion](https://gitlab.torproject.org/tpo/onion-services/onion-support/-/issues/53)).
