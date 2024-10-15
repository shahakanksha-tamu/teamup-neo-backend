class UsersController < ApplicationController
    def search_full_name
      query = params[:q].to_s.strip
      first_name, last_name = query.split(' ', 2)
  
      @users = User.where("lower(first_name) LIKE :first OR lower(last_name) LIKE :last OR lower(concat(first_name, ' ', last_name)) LIKE :full", 
                          first: "#{first_name.downcase}%", 
                          last: "#{last_name&.downcase || first_name.downcase}%", 
                          full: "%#{query.downcase}%")
                   .limit(20)
  
      render json: { 
        items: @users.map { |u| { id: u.id, text: u.full_name } }, 
        total_count: @users.count 
      }
    end
  end