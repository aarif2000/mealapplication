class Users::UsersController < ApplicationController
  load_and_authorize_resource
      def index
        @users = User.all
        render json: { users: @users }, status: 200
      end
  
      def show
        @user=User.find(params[:id])
        render json: { user: @user }, status: 200
      end

      def destroy 
        @user=User.find(params[:id])
        @user.destroy 
        render json: {message: 'User deleted successfully', user: @user }, status: 200
      end

      def update 
          @user=User.find(params[:id])
          if @user.update(user_params)
            render json: { message: 'User updated succesfully', user: @user }, status: 200
          else
            render json: { message: @user.errors.messages }, status: 406
          end
      end
  
      private 

      def user_params
        params.require(:user).permit(:name, :email, :age, :weight, :role)
      end
      
    end