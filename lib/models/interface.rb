
class Interface

    attr_accessor :prompt, :user

    def initialize
        @prompt = TTY::Prompt.new(active_color: :blue)
    end
    def whirly_beginning
        Whirly.start do
            Whirly.status = " Loading 🍕🍟🌮🍕🍟🌮🍕🍟🌮🍕🍟🌮"
            sleep 1

            Whirly.status = "Lets Eat"
          
            sleep 1
            Whirly.stop
        end
          
    end 

    def whirly_wait
        Whirly.start do
            puts "\n"
            Whirly.status = "Returning to Main Menu"
            sleep 1
        end 
    end 

    def welcome
        puts "\nWelcome to FreeTable! 🍽".colorize(:color => :blue)
        puts "\n---------------------\n"
        puts "\n"
        self.whirly_beginning
        puts "\n"
    
    end

    def user_or_restaurant
        answer =  prompt.select("Are you a User or Restaurant?") do |menu|
            menu.choice "User"
            menu.choice "Restaurant"
        end
    end

    def user_menu(user)
        prompt.select("") do |q|
            q.choice 'Make a Reservation', -> {user.book}   
            q.choice 'View Existing Reservations', -> {user.find_resos}
            q.choice 'Cancel a Reservation', -> {user.cancel_reso}
            q.choice 'Done', -> {Reservation.done}
        end
        # (sleep 5)
       
        self.whirly_wait
        puts `clear`
        puts "What else would you like to do?"
        user_menu(user)
    end

    def restaurant_menu(restaurant)
        prompt.select("") do |q|
            q.choice 'Check Reserved Tables', -> {restaurant.reserved}
            q.choice 'Show Open Tables', -> {restaurant.open}
            q.choice 'Cancel a Users Reservation', -> {restaurant.delete_booked_reso}
            q.choice 'Cancel an Open Reservation', -> {restaurant.delete_open_reso}
            q.choice 'Create Listing', -> {restaurant.create}
            q.choice 'Update Open Listing', -> {restaurant.update}
            q.choice 'Change Password', -> {restaurant.change_password}
            q.choice 'Done', -> {Reservation.done}

        end
        # (sleep 3)

        self.whirly_wait
        puts `clear`
        puts "What else would you like to do?"
        restaurant_menu(restaurant)
    end
end