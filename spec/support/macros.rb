ActiveSupport::TestCase.class_eval do

  def object
    @object || Factory.build(@factory)
  end

  def default_action(action)
    method = {
      :new     => :get,
      :create  => :post,
      :index   => :get,
      :show    => :get,
      :edit    => :get,
      :update  => :put,
      :destroy => :delete
    }[action]

    @params ||= {
      :new     => {},
      :create  => proc {
        raise "undefined @param" unless @param
        {@param => Factory.attributes_for(@factory).except(:skip_session_maintenance)}},
      :index   => {},
      :show    => proc {{:id => object.id}},
      :edit    => proc {{:id => object.id}},
      :update  => proc {{:id => object.id, @param => Factory.attributes_for(@factory)}},
      :destroy => proc {{:id => object.id}}
    }[action]
    @params = @params.call if @params.is_a?(Proc)

    send method, action, @params
  end

  def eval_request(action = nil)
    meth = "do_#{action || @action}"
    if respond_to?(meth)
      send(meth)
    else
      default_action(action || @action)
    end
  end

  def self.describe_action(action, &block)
    describe(action) do
      before(:each) {@action = action}
      instance_eval(&block)
    end
  end

  def self.it_should_redirect_to(url = nil, &block)
    it "should redirect to #{url}" do
      eval_request
      if block
        url = instance_eval(&block)
      end
      should redirect_to(url)
    end
  end

  def self.it_should_require_login
    it_should_redirect_to "/login"
  end

  def self.it_should_render_template(template)
    it "should render template #{template}" do
      eval_request
      should render_template(template)
    end
  end

  def self.it_should_assign(var)
    it "should assign #{var}" do
      eval_request
      assigns[var].should_not be_nil
    end
  end

  def self.it_should_assign(var)
    it "should assign #{var}" do
      eval_request
      assigns[var].should_not be_nil
    end
  end

  def self.it_should_fail_to_find
    it "should throw ActiveRecord::RecordNotFound" do
      proc {eval_request}.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  def self.it_should_not_route(action)
    it "should not route #{action}" do
      proc {eval_request(action)}.should raise_error(ActionController::RoutingError)
    end
  end
end
