module Hotels

    class PlansController < ApplicationController 
        def index 
            @plans=Plan.all
            render json: {plan: show_plans }, status: 200 
        end

        def show
            @plan = Plan.find(params[:id]) 
            render json: { Plan: @plan }, status: 200
        end

        def create 
            @plan=Plan.new(plan_params)
            variables_for_plan
            check_errors(@plan_cost, @plan_duration)
            return render json: { message: @errors }, status: 406 if @is_error

            if @plan.save
                render json: { message: "Plan Created Successfully." }, status: 201
            else 
                render json: {message: @plan.errors }, status: 406
            end
        end


        def update
            if @plan.update(plan_params) 
                variables_for_plan 
            check_errors(@plan_cost, @plan_duration)
                render json: { message: "Plan Updated Successfully "}, status: 200
            else 
                render json: { message: @plan.errors }
            end
        end

        def destroy
            @plan = Plan.find(params[:id]) 
            @plan.destroy
            render json: { message: "Plan Deleted Successfully "}, status: 200
        end

        def buy_plan
          if current_user.active_plan
            send_plan_is_activated_response
          else 
          @plan = Plan.find(params[:id])
              plan_duration = generate_time(Date.today.next_day(@plan.plan_duration))
              user = User.find(current_user.id)
              @expiry_date = Date.today.next_day(@plan.plan_duration)-1
              @activate_plan = ActivePlan.create(user_id: current_user.id, plan_id: @plan.id)
              send_plan_is_purchased_response
          end
        end

        # end plan buying
        

        # send plan response start

        def send_plan_is_purchased_response
            if @activate_plan.save
              if current_user.update(active_plan: true, plan_duration: @plan_duration.to_i, expiry_date: @expiry_date)
                render json: { message: 'purchase successfull', bill: generate_bill }, status: 200
              else
                render json: { message: 'something wrong' }, status: 500
              end
            else
              render json: { message: 'something wrong try again' }, status: 500
            end
        end

        # send plan response end 
        # send plan activate start

        def send_plan_is_activated_response
            render json: { message: "your plan is already activated try to buy after #{current_user.expiry_date}",
                              plan_expires_on: current_user.expiry_date }, status: 406
        end

        # send plan activate end
          # show plan day start 

          def show_plan_day
            plan_meals = []
            @plan.days.each do |day|
              plan_meal = {}
              plan_meal[:day] = day.for_day
              day.meals.each do |meal|
                plan_meal[meal.meal_category.name] = give_recipe(meal.recipe)
              end
              plan_meals << plan_meal
            end
            plan_meals
          end

          # show plan day end

          #show plans start 

          def show_plans
            plans = []
            @plans.each do |plan|
                plans << create_plan(plan)
            end
            plans
        end

          #show plans day end

          # create plan start 

          def create_plan(plan)
            {
              id: plan.id,
              name: plan.name,
              plan_duration: plan.plan_duration,
              plan_cost: plan.plan_cost,
              view_url: plan_url(plan),
              buy_url: buy_plan_url(plan)
            }
          end

          # create plan end

          #generate bill start 

          def generate_bill
            {
              plan_name: @plan.name,
              plan_cost: @plan.plan_cost,
              plan_duration: @plan.plan_duration,
              expiry_date: @expiry_date
            }
          end

          #generate bill end 

          def active_users
            users = User.where(active_plan: true)
            render json: {users: users}
        end

        def activated_users
            active_plan= AcivePlan.where(plan_id: @plan.id)
            users=[]
            active_plan.each do|active_plan|
                user= User.find(active_plan.user_id)
                users << user
            end
            render json: {activated_users: users }
        end

        private 

        def plan_params 
            params.require(:plan).permit(:name,:plan_duration,:plan_cost) 
        end
        def variables_for_plan
            @plan_cost = params[:plan][:plan_cost].to_i
            @plan_duration = params[:plan][:plan_duration].to_i
            @plan_meals = params[:plan][:plan_meals]
            @errors = {}
            @is_error = false
        end

        def check_errors(cost, duration)
            if cost < 1000
                @is_error = true
                @errors[:plan_cost] = 'Cost of the plan must be larger than 1000'
            end
            unless [7, 14, 21].include? duration
                @is_error = true
                @errors[:plan_duration] = 'Duration must be 7, 14 or 21'
            end
            @is_error
        end
    end
end
