# This file generated automatically using vocab-fetch from http://usefulinc.com/ns/doap#
require 'rdf'
module RDF
  class DOAP < StrictVocabulary("http://usefulinc.com/ns/doap#")

    # Class definitions
    property :BazaarBranch, :label => 'Bazaar Branch', :comment =>
      %(Bazaar source code branch.)
    property :BKRepository, :label => 'BitKeeper Repository', :comment =>
      %(BitKeeper source code repository.)
    property :BKRepository, :label => 'BitKeeper Repository', :comment =>
      %(BitKeeper source code repository.)
    property :CVSRepository, :label => 'CVS Repository', :comment =>
      %(CVS source code repository.)
    property :CVSRepository, :label => 'CVS Repository', :comment =>
      %(CVS source code repository.)
    property :ArchRepository, :label => 'GNU Arch repository', :comment =>
      %(GNU Arch source code repository.)
    property :ArchRepository, :label => 'GNU Arch repository', :comment =>
      %(GNU Arch source code repository.)
    property :GitRepository, :label => 'Git Repository', :comment =>
      %(Git source code repository.)
    property :HgRepository, :label => 'Mercurial Repository', :comment =>
      %(Mercurial source code repository.)
    property :Project, :label => 'Project', :comment =>
      %(A project.)
    property :Repository, :label => 'Repository', :comment =>
      %(Source code repository.)
    property :Specification, :label => 'Specification', :comment =>
      %(A specification of a system's aspects, technical or otherwise.)
    property :SVNRepository, :label => 'Subversion Repository', :comment =>
      %(Subversion source code repository.)
    property :Version, :label => 'Version', :comment =>
      %(Version information of a project release.)
    property :DarcsRepository, :label => 'darcs Repository', :comment =>
      %(darcs source code repository.)

    # Property definitions
    property :implements, :label => 'Implements specification', :comment =>
      %(A specification that a project implements. Could be a
        standard, API or legally defined level of conformance.)
    property :"anon-root", :label => 'anonymous root', :comment =>
      %(Repository for anonymous access.)
    property :audience, :label => 'audience', :comment =>
      %(Description of target user base)
    property :blog, :label => 'blog', :comment =>
      %(URI of a blog related to a project)
    property :browse, :label => 'browse', :comment =>
      %(Web browser interface to repository.)
    property :"bug-database", :label => 'bug database', :comment =>
      %(Bug tracker for a project.)
    property :category, :label => 'category', :comment =>
      %(A category of project.)
    property :created, :label => 'created', :comment =>
      %(Date when something was created, in YYYY-MM-DD form. e.g.
        2004-04-05)
    property :description, :label => 'description', :comment =>
      %(Plain text description of a project, of 2-4 sentences in
        length.)
    property :developer, :label => 'developer', :comment =>
      %(Developer of software for the project.)
    property :documenter, :label => 'documenter', :comment =>
      %(Contributor of documentation to the project.)
    property :"download-mirror", :label => 'download mirror', :comment =>
      %(Mirror of software download web page.)
    property :"download-page", :label => 'download page', :comment =>
      %(Web page from which the project software can be downloaded.)
    property :"file-release", :label => 'file-release', :comment =>
      %(URI of download associated with this release.)
    property :helper, :label => 'helper', :comment =>
      %(Project contributor.)
    property :homepage, :label => 'homepage', :comment =>
      %(URL of a project's homepage, associated with exactly one
        project.)
    property :language, :label => 'language', :comment =>
      %(ISO language code a project has been translated into)
    property :license, :label => 'license', :comment =>
      %(The URI of an RDF description of the license the software is
        distributed under.)
    property :"mailing-list", :label => 'mailing list', :comment =>
      %(Mailing list home page or email address.)
    property :maintainer, :label => 'maintainer', :comment =>
      %(Maintainer of a project, a project leader.)
    property :module, :label => 'module', :comment =>
      %(Module name of a repository.)
    property :name, :label => 'name', :comment =>
      %(A name of something.)
    property :"old-homepage", :label => 'old homepage', :comment =>
      %(URL of a project's past homepage, associated with exactly one
        project.)
    property :os, :label => 'operating system', :comment =>
      %(Operating system that a project is limited to. Omit this
        property if the project is not OS-specific.)
    property :platform, :label => 'platform', :comment =>
      %(Indicator of software platform \(non-OS specific\), e.g. Java,
        Firefox, ECMA CLR)
    property :"programming-language", :label => 'programming language', :comment =>
      %(Programming language a project is implemented in or intended
        for use with.)
    property :release, :label => 'release', :comment =>
      %(A project release.)
    property :repository, :label => 'repository', :comment =>
      %(Source code repository.)
    property :location, :label => 'repository location', :comment =>
      %(Location of a repository.)
    property :revision, :label => 'revision', :comment =>
      %(Revision identifier of a software release.)
    property :screenshots, :label => 'screenshots', :comment =>
      %(Web page with screenshots of project.)
    property :"service-endpoint", :label => 'service endpoint', :comment =>
      %(The URI of a web service endpoint where software as a service
        may be accessed)
    property :shortdesc, :label => 'short description', :comment =>
      %(Short \(8 or 9 words\) plain text description of a project.)
    property :tester, :label => 'tester', :comment =>
      %(A tester or other quality control contributor.)
    property :translator, :label => 'translator', :comment =>
      %(Contributor of translations to the project.)
    property :vendor, :label => 'vendor', :comment =>
      %(Vendor organization: commercial, free or otherwise)
    property :wiki, :label => 'wiki', :comment =>
      %(URL of Wiki for collaborative discussion of project.)
  end
end
