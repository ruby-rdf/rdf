require 'rdf'

Spec::Matchers.define :be_a_statement do
  match do |statement|
    statement.should be_instance_of(RDF::Statement)
    statement.subject.should be_a_kind_of(RDF::Resource)
    statement.predicate.should be_a_kind_of(RDF::URI)
    statement.object.should be_a_kind_of(RDF::Value) unless statement.object.is_a?(String) # FIXME
    true
  end
end

Spec::Matchers.define :be_a_triple do
  match do |triple|
    triple.should be_instance_of(Array)
    triple.size.should == 3
    triple[0].should be_a_kind_of(RDF::Resource)
    triple[1].should be_a_kind_of(RDF::URI)
    triple[2].should be_a_kind_of(RDF::Value) unless triple[2].is_a?(String) # FIXME
    true
  end
end

Spec::Matchers.define :be_a_quad do
  match do |quad|
    quad.should be_instance_of(Array)
    quad.size.should == 4
    quad[0].should be_a_kind_of(RDF::Resource)
    quad[1].should be_a_kind_of(RDF::URI)
    quad[2].should be_a_kind_of(RDF::Value) unless quad[2].is_a?(String) # FIXME
    quad[3].should be_a_kind_of(RDF::Resource) unless quad[3].nil?
    true
  end
end

Spec::Matchers.define :be_a_resource do
  match do |value|
    value.should be_a_kind_of(RDF::Resource)
    true
  end
end

Spec::Matchers.define :be_a_uri do
  match do |value|
    value.should be_a_kind_of(RDF::URI)
    true
  end
end

Spec::Matchers.define :be_a_value do
  match do |value|
    value.should be_a_kind_of(RDF::Value) unless value.is_a?(String) # FIXME
    true
  end
end
