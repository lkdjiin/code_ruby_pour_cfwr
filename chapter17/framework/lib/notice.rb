class Notice
  def initialize(session)
    @session = session
    if @session['notice']
      @value = @session['notice']
      @session.delete('notice')
    else
      @value = nil
    end
  end

  def value=(v)
    @value = v
    @session.store('notice', v)
  end

  def value
    @value
  end
end
