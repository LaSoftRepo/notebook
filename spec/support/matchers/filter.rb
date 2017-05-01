# Not the best realization, but it will do for simple before actions
RSpec::Matchers.define :filter do |kind, filter|
  match do |controller|
    callback = controller._process_action_callbacks.find do |x|
      x.kind == kind && x.filter == filter[:with]
    end

    if filter[:except].present?
      extra = callback.instance_variable_get(:@unless)[0]
      actions = filter[:except]
    elsif filter[:only].present?
      extra = callback.instance_variable_get(:@if)[0]
      actions = filter[:only]
    else
      return callback.present?
    end

    actions.all? { |action| extra.call ActionMatcher.new(action) }
  end
end

class ActionMatcher
  attr_reader :action_name

  def initialize(action_name)
    @action_name = action_name.to_s
  end
end
