class DefaultController < ApplicationController
  def index
    # Pagination requests excluded, due size of the scope
    #   A single request around 1.000 records only take 170ms
    #   on full render. Only 8ms on sql query.
    @contacts = current_user.contacts
  end
end
