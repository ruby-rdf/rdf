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
