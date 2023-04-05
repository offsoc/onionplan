# Low-hanging fruit

* Status: DRAFT
* Version: v2022.Q4

This appendix contains tasks considered with lower complexity that can
significantly improve Onion Services usability.

They can be included in the roadmap from any phase.

## Index

[TOC]

## Usability

## General UI fixes

* [Onion Services show broken padlock instead of Secure Onion icon in the URL
  bar on Android](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41087).
* [Verify onion reachability before redirect (#40637) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40637)
* [Verify features that are made "HTTPS-only" should be available on .onion sites as well (#21728) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/21728)
* [Setting Origin: null header still breaks CORS in Tor Browser 9.5 (#32865) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/32865)

### Onion-Location for Tor Browser

* Desktop only:
    * [Easier flow to navigate back to clear-URL after an Onion-Location redirect](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40031).
* Desktop and mobile:
    * [Onion-Location icon takes too long to appear](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40100),
      only after the page is fully loaded. Is there's a reasoning/need for this behavior?
    * [Disable self-signed certificate warnings when visiting .onion sites](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/13410).
    * [non-onionsite gives interstitial "Onionsite Has Disconnected" page](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40434).
    * [Onion rewrites should add eTLDs](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41022).
* Mobile only:
    * [Implement Onion Location UI on Android](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41230).

### Alt-Svc

* [Indicate Alt-Svc Onion explicitly in the urlbar](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40587).
* [Show onion redirects in the tor circuit panel](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41703)
  (previously: [Display .onion alt-svc route in the circuit display](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/27590)).
