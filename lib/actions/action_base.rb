class Action
  class Base
    attr_accessor :next_action

    def then
      last_action_in_chain.next_action = yield
      self
    end

    def end_action
      if @next_action
        @character.action = @next_action
      else
        @character.finish
      end
    end

    def abandon_action
      @character.finish
    end

    def replace_action(new_action)
      @character.action = new_action
    end

    def start
    end

    private

    def last_action_in_chain
      actions_chain = [self]

      while actions_chain.last.next_action
        actions_chain << actions_chain.last.next_action
      end

      actions_chain.last
    end
  end
end
