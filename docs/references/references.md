# References

Last updated on 2025-02-06.

## Current research

* [Tor Project Research][research]: contains guidelines
  researching [Tor][], tech reports and other resources.
* [Anonbib - Free Haven's Selected Papers in Anonymity][anonbib]
  has recent and past research on [Tor][], including Onion Services.

[Tor]: https://torproject.org
[tor-research]: https://research.torproject.org/
[anonbib]: https://www.freehaven.net/anonbib/

## Curated list of research

Highlights from the [Anonbib][anobib]:

* 2020:
    * [Bypassing Tor Exit Blocking with Exit Bridge Onion Services](https://dl.acm.org/doi/10.1145/3372297.3417245) (HebTor)
* 2024:
    * [A Study of Deanonymization Attacks of Onion Services](https://dl.gi.de/items/56ca4791-6b90-43ef-bc55-c838086115e5) ([PDF](https://dl.gi.de/server/api/core/bitstreams/60051049-690c-4dd3-bd17-a4e9f7c490f9/content)).
    * [Onion Services in the Wild: A Study of Deanonymization Attacks](https://petsymposium.org/popets/2024/popets-2024-0117.php)

Selected papers (still) not indexed on [Tor Project Research][tor-research]
neither in the [Anonbib][]:

* 2018:
    * [How Do Tor Users Interact with Onion Services? - sec18-onion-services.pdf](https://nymity.ch/onion-services/pdf/sec18-onion-services.pdf):
        * [USENIX Security '18 - How Do Tor Users Interact With Onion Services? - YouTube](https://www.youtube.com/watch?v=MYR4sB3wPOg)
* 2021:
    * [On the state of V3 onion services | Proceedings of the ACM SIGCOMM 2021 Workshop on Free and Open Communications on the Internet](https://dl.acm.org/doi/10.1145/3473604.3474565):
        * [V3 onion services usage | The Tor Project](https://blog.torproject.org/v3-onion-services-usage/)
* 2024:
    * [HSDirSniper: A New Attack Exploiting Vulnerabilities in Tor's Hidden Service
      Directories | Proceedings of the ACM Web Conference
      2024](https://dl.acm.org/doi/10.1145/3589334.3645591), disclosing an issue
      further mitigated on [C Tor 0.4.8.14][].

[C Tor 0.4.8.14]: https://forum.torproject.org/t/stable-release-0-4-8-14/17242

## Historical

Historical research:

* [The Once and Future Onion](https://link.springer.com/chapter/10.1007/978-3-319-66402-6_3):
  includes a historic overview of Onion Services technology.
* [Onion Routing](https://www.onion-router.net/): the onion-router.net site
  formerly hosted at the Center for High Assurance Computer Systems of the U.S.
  Naval Research Laboratory (NRL). It primarily covers the work done at NRL during
  the first decade of onion routing and reflects the onion-router.net site
  roughly as it existed circa 2005. As a historical site it may contain dead
  external links and other signs of age.
* [Anonbib][anonbib] also goes back since 1977, listing the most relevant
  papers that lead to Onion Services development.

Historical highlights from the [Anonbib][anobib]:

* 2006:
    * [Locating Hidden Servers](https://www.freehaven.net/anonbib/cache/hs-attack06.pdf)
    * [Valet Services: Improving Hidden Servers with a Personal Touch](https://www.freehaven.net/anonbib/cache/valet:pet2006.pdf)
* 2007:
    * [Improving Efficiency and Simplicity of Tor circuit establishment and hidden services](https://www.freehaven.net/anonbib/cache/overlier-pet2007.pdf)
* 2008:
    * [Performance Measurements and Statistics of Tor Hidden Services](https://www.freehaven.net/anonbib/cache/loesing2008performance.pdf)
* 2009:
    * [Performance Measurements of Tor Hidden Services in Low-Bandwidth Access Networks](https://www.freehaven.net/anonbib/cache/lenhard2009hidserv-lowbw.pdf)

Historical articles:

* 2013:
    * [Hidden Services need some love | The Tor Project](https://blog.torproject.org/hidden-services-need-some-love/), covering:
        * Scaling and performance.
        * DoS protections.
        * Attacks on HSDirs.
        * Recommends the use of "Encrypted Services" instead of Exit Enclaves.
* 2014:
    * [Facebook, hidden services, and https certs | The Tor Project](https://blog.torproject.org/facebook-hidden-services-and-https-certs/), covering:
        * Still pre-v3 services.
        * Discussion on vanity addresses.
        * Discussion about HTTPS certificates for Onion Service websites.
        * What still needs to be done (from that time perspective).

## Related

Although not focused in the Onion Service, other references might be relevant,
like those covering anti-censorship:

* [CensorBib](https://censorbib.nymity.ch/): an archive of selected academic
  research papers on Internet censorship.
