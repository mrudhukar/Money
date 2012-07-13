class SupportsController < ApplicationController
	def new
		@support = current_user.supports.new
	end

	def create
		current_user.supports.create!(params[:support])
	end

end
