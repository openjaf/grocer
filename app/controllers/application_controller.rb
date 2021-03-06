class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  around_filter :scope_current_account
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_start_date
    session[:start_date].to_date if session[:start_date]
  end

  def current_amount
    session[:amount]
  end

  def current_compare_start_date
    session[:compare_start_date].to_date if session[:compare_start_date]
  end

  def current_compare_amount
    session[:compare_amount]
  end
  
  before_filter :authenticate_user!

  private
 
    def scope_current_account
      if current_user && current_user.account.nil?
        new_account = Account.create(organization: Organization.new)
        current_user.account = new_account
        current_user.save(validate: false)
      end  
      Account.current = current_user.account if signed_in?
      puts "******************** entro en Account.current #{Account.current.inspect} ************
      current_user: #{current_user.inspect}"
      yield
    ensure
      Account.current = nil
    end

end
