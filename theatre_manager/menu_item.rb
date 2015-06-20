class MenuItem
  attr_reader :key_user_returns, :user_message, :do_if_chosen
  
  def initialize(args)
    @key_user_returns = args[:key_user_returns].to_s
    @user_message = args[:user_message]
    @do_if_chosen = args[:do_if_chosen]
  end
end