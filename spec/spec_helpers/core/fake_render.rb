#
# Pulled this in from timocratic's blog, this should be put somewhere else
# http://www.timocracy.com/articles/2007/12/17/isolated-controller-and-view-testing-in-merb
#
class FakeController
  def catch_content(sym)
  end
end

def fake_render(template, ivars={})
  dummy = FakeController.new
  ivars.each do |key, value|
    dummy.instance_variable_set "@#{key.to_s}", value
  end
  template = "#{Merb.root}/app/views/#{template}"
  engine = Merb::Template.engine_for(template)
  view_context = Merb::ViewContext.new dummy
  engine.transform(:file => template, :view_context => view_context)
end