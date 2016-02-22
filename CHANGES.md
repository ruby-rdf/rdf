Release 2.0.0
=============

* A new class `RDF::Changeset` has been added. This is meant to replace any
  previous use of `RDF::Transaction`, which in fact used to in RDF.rb 1.x
  represent more of a buffered changeset than a genuine transaction scope.

  - Instead of `RDF::Transaction.execute`, use `RDF::Changeset.apply`.
  - Instead of `RDF::Transaction#execute`, use `RDF::Changeset#apply`.

* The `RDF::Transaction` class has been substantially revamped, including
  some minor backwards-incompatible changes. These changes will mostly
  affect repository implementors, not so much general RDF.rb users.

  The changes reflect the expanded purpose of the class: instead of being a
  mere buffered changeset (for which, see `RDF::Changeset`), transactions
  are now intended to provide a proper ACID scope for repository queries and
  mutations.

  We always now also carefully distinguish between read-only and read/write
  transactions, in order to enable repository implementations to take out the
  appropriate locks for concurrency control. Note as well that transactions
  are now read-only by default; mutability must be explicitly requested on
  construction in order to obtain a read/write transaction.

  In case repository implementations should be unable to provide actual ACID
  guarantees for transactions, that must be clearly indicated in their
  documentation. Similarly, implementations should throw an exception when
  appropriate in case they don't provide write transaction support.

  - `RDF::Transaction#initialize` now takes the target repository as its
    first argument. Transactions are now always tied to a specific
    repository instance, instead of being free-floating objects as they used
    to be (for that, see `RDF::Changeset`).

  - `RDF::Transaction` now mixes in `RDF::Queryable` and `RDF::Enumerable`,
    enabling quad-pattern matches and BGP queries to execute in a proper
    transaction scope.

  - The `RDF::Transaction#context` accessor, and its aliases, have been
    removed. Transactions aren't necessarily scoped to a single graph only.

  - There is a new `RDF::Transaction#repository` accessor for retrieving the
    target repository object that the transaction operates upon.

  - There is a new `RDF::Transaction#buffered?` predicate for testing
    whether the changeset that constitutes a transaction is available for
    introspection. Particular repository implementations may support both
    options and permit the user the choice on transaction construction.

  - The `RDF::Transaction#inserts` and `#deletes` methods are deprecated.
    Instead, there is a new `RDF::Transaction#changes` accessor to retrieve
    an `RDF::Changeset` instance, which contains corresponding methods.
    For unbuffered transactions, `#changes` returns `nil`.

* Enumerables vs. Enumerators

  - `RDF::Queryable#query` and `RDF::Query#execute` not return an enumerable, which may be an enumerator. Most internal uses return an Array now, which aides performance for small result sets, but potentially causes problems for large result sets. Implementations may still return an Enumerator, and Enumerators may be passed as arguments.
  - `RDF::Enumerable#statements`, `#quads`, `#triples`, `#subjects`, `#predicates`, `#objects`, and `#contexts` now return an array rather than an Enumerator.

* The following vocabularies are deprecated and have been moved to the rdf-vocab gem.

  - `RDF::CC`     - Creative Commons (CC)
  - `RDF::CERT`   - W3 Authentication Certificate (CERT)
  - `RDF::DC`     - Dublin Core (DC)
  - `RDF::DC11`   - Dublin Core 1.1 (DC11) _deprecated_
  - `RDF::DOAP`   - Description of a Project (DOAP)
  - `RDF::EXIF`   - Exchangeable Image File Format (EXIF)
  - `RDF::FOAF`   - Friend of a Friend (FOAF)
  - `RDF::GEO`    - WGS84 Geo Positioning (GEO)
  - `RDF::GR`     - GoodRelations (GR)
  - `RDF::HT`     - Hypertext Transfer Protocol (HT)
  - `RDF::ICAL`   - RDF Calendar Workspace (ICAL)
  - `RDF::MA`     - Media Resources (MA)
  - `RDF::MO`     - Music Ontology (MO)
  - `RDF::OG`     - Open Graph protocol (OG)
  - `RDF::PROV`   - Provenance on the web (PROV)
  - `RDF::RSA`    - W3 RSA Keys (RSA)
  - `RDF::RSS`    - RDF Site Summary (RSS)
  - `RDF::SCHEMA` - Schema.org (SCHEMA)
  - `RDF::SIOC`   - Semantically-Interlinked Online Communities (SIOC)
  - `RDF::SKOS`   - Simple Knowledge Organization System (SKOS)
  - `RDF::SKOSXL` - SKOS eXtension for Labels (SKOSXL)
  - `RDF::V`      - RDF data vocabulary (V)
  - `RDF::VCARD`  - Ontology for vCards (VCARD)
  - `RDF::VMD`    - Data-Vocabulary.org (VMD)
  - `RDF::VOID`   - Vocabulary of Interlinked Datasets (VOID)
  - `RDF::VS`     - SemWeb Vocab Status ontology (VS)
  - `RDF::WDRS`   - Protocol for Web Description Resources (WDRS)
  - `RDF::WOT`    - Web of Trust (WOT)
  - `RDF::XHTML`  - Extensible HyperText Markup Language (XHTML)
  - `RDF::XHV`    - XHTML Vocabulary (XHV)
