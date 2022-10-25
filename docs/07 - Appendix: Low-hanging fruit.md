# Appendix: Low-hanging fruit

* This appendix contains tasks considered with low complexity that can
  significantly improve Onion Services usability.
* They can be included in the roadmap from any phase.

## Usability

## General UI fixes

* Onion Services show broken padlock instead of Secure Onion icon in the URL
  bar on Android.

### Onion-Location for Tor Browser

* Desktop only:
  * [Easier flow to navigate back to clear-URL after an Onion-Location redirect](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40031 "Easier flow to navigate back to clear-URL after an onion-location redirect, e.g. when onion is broken").
* Desktop and mobile:
  * [Onion-Location should not work with v2 addresses](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40491 "Don't auto-pick a v2 address when it's in Onion-Location header").
  * [Onion-Location icon takes too long to appear](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40100 "Tor Browser waits for the page to fully finish loading before showing Onion Location pill"), only after the page is fully loaded. Is there's a reasoning/need for this behavior?
  * [Disable self-signed certificate warnings when visiting .onion sites](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/13410 "Disable self-signed certificate warnings when visiting .onion sites").
  * [non-onionsite gives interstitial "Onionsite Has Disconnected" page](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40434 "non-onionsite gives interstitial \"Onionsite Has Disconnected\" page").
  * [Onion rewrites should add eTLDs](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41022).
* Mobile only:
  * [Implement Onion Location UI on Android](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41230 "Implement Onion Location UI on Android").
  * [Implement a setting to always prefer onion sites](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41394 "Implement a setting to always prefer onion sites").

## Alt-Svc

* [Indicate Alt-Svc Onion explicitly in the urlbar](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40587 "Indicate alt-svc onion explicitly in the urlbar").
