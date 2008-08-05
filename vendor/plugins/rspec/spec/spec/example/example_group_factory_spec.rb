require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe ExampleGroupFactory, "with :foobar registered as custom type" do

      before do
        @example_group = Class.new(ExampleGroup)
        ExampleGroupFactory.register(:foobar, @example_group)
      end

      after do
        ExampleGroupFactory.reset
      end

      it "should #get the default ExampleGroup type when passed nil" do
        ExampleGroupFactory.get(nil).should == ExampleGroup
      end

      it "should #get the default ExampleGroup for unregistered non-nil values" do
        ExampleGroupFactory.get(:does_not_exist).should == ExampleGroup
      end

      it "should #get custom type for :foobar" do
        ExampleGroupFactory.get(:foobar).should == @example_group
      end

      it "should #get the actual type when that is passed in" do
        ExampleGroupFactory.get(@example_group).should == @example_group
      end

      it "should get the custom type after setting the default" do
        @example_group2 = Class.new(ExampleGroup)
        ExampleGroupFactory.default(@example_group2)
        ExampleGroupFactory.get(:foobar).should == @example_group
      end

    end    

    describe ExampleGroupFactory, "#create_example_group" do
      it "should create a uniquely named class" do
        example_group = Spec::Example::ExampleGroupFactory.create_example_group("example_group") {}
        example_group.name.should =~ /Spec::Example::ExampleGroup::Subclass_\d+/
      end

      it "should create a Spec::Example::Example subclass by default" do
        example_group = Spec::Example::ExampleGroupFactory.create_example_group("example_group") {}
        example_group.superclass.should == Spec::Example::ExampleGroup
      end

      it "should create a Spec::Example::Example when :type => :default" do
        example_group = Spec::Example::ExampleGroupFactory.create_example_group(
          "example_group", :type => :default
        ) {}
        example_group.superclass.should == Spec::Example::ExampleGroup
      end

      it "should create a Spec::Example::Example when :type => :default" do
        example_group = Spec::Example::ExampleGroupFactory.create_example_group(
          "example_group", :type => :default
        ) {}
        example_group.superclass.should == Spec::Example::ExampleGroup
      end

      it "should create specified type when :type => :something_other_than_default" do
        klass = Class.new(ExampleGroup) do
          def initialize(*args, &block); end
        end
        Spec::Example::ExampleGroupFactory.register(:something_other_than_default, klass)
        example_group = Spec::Example::ExampleGroupFactory.create_example_group(
          "example_group", :type => :something_other_than_default
        ) {}
        example_group.superclass.should == klass
      end
      
      it "should create a type indicated by :spec_path" do
        klass = Class.new(ExampleGroup) do
          def initialize(*args, &block); end
        end
        Spec::Example::ExampleGroupFactory.register(:something_other_than_default, klass)
        example_group = Spec::Example::ExampleGroupFactory.create_example_group(
          "example_group", :spec_path => "./spec/something_other_than_default/some_spec.rb"
        ) {}
        example_group.superclass.should == klass
      end
      
      it "should create a type indicated by :spec_path (with spec_path generated by caller on windows)" do
        klass = Class.new(ExampleGroup) do
          def initialize(*args, &block); end
        end
        Spec::Example::ExampleGroupFactory.register(:something_other_than_default, klass)
        example_group = Spec::Example::ExampleGroupFactory.create_example_group(
          "example_group", :spec_path => "./spec\\something_other_than_default\\some_spec.rb"
        ) {}
        example_group.superclass.should == klass
      end
      
      it "should create and register a Spec::Example::Example if :shared => true" do
        shared_example_group = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/models/blah.rb', :type => :controller, :shared => true
        ) {}
        shared_example_group.should be_an_instance_of(Spec::Example::SharedExampleGroup)
        SharedExampleGroup.shared_example_groups.should include(shared_example_group)
      end

      it "should favor the :type over the :spec_path" do
        klass = Class.new(ExampleGroup) do
          def initialize(*args, &block); end
        end
        Spec::Example::ExampleGroupFactory.register(:something_other_than_default, klass)
        example_group = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/models/blah.rb', :type => :something_other_than_default
        ) {}
        example_group.superclass.should == klass
      end

      it "should register ExampleGroup by default" do
        example_group = Spec::Example::ExampleGroupFactory.create_example_group("The ExampleGroup") do
        end
        rspec_options.example_groups.should include(example_group)
      end

      it "should enable unregistering of ExampleGroups" do
        example_group = Spec::Example::ExampleGroupFactory.create_example_group("The ExampleGroup") do
          unregister
        end
        rspec_options.example_groups.should_not include(example_group)
      end
      
      after(:each) do
        Spec::Example::ExampleGroupFactory.reset
      end
    end
  end
end
