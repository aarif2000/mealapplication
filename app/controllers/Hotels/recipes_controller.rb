        class Hotel::RecipesController < ApplicationController 
            load_and_authorize_resource
            def index 
                @recipe=Recipe.all
                render json: {recipe: @recipe }
            end
        
            def show 
                render json: {recipe: @recipe }
            
            end
        
            def create 

                @recipe=Recipe.new(recipe_params)
                if @recipe.save 
                    render json: { message: "Recipe Created Successfully", recipe: @recipe }, status: 201
                else 
                    render json: { message: @recipe.errors.messages }, status: 406
                end
           end 
       
           def update 
                @recipe=Recipe.find(params[:id])
                if @recipe.update(recipe_params)
                    render json: {message: "Recipe Updated Succesfully"}, status: 200
                end
           end
       
       
           def destroy 
            @recipe.destroy 
            render json: {message: "Recipe Deleted  Successfully"}
        
           end
       
       
         private 
       
          def recipe_params 
           params.require(:recipe).permit(:name,:description,:ingredients)
        
         end
     
        end
        