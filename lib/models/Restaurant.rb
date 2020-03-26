class Restaurant < ActiveRecord::Base
    
    @@prompt = TTY::Prompt.new(active_color: :blue)
    has_many :reservations

    def self.log_in
       restaurant = @@prompt.select("Please select your restaurant from the following: ") do |q|
            Restaurant.all.each do |restaurant|
               q.choice restaurant.name, -> {restaurant}
            end
        end 
        self.verify(restaurant)
        return restaurant
    end

    def self.verify(restaurant)
        input = @@prompt.mask("Please Enter Your Password:")
        if restaurant.password == input
            puts "Verified".colorize(:color => :green)
        else
            puts "ERROR: Incorrect Password".colorize(:color => :red)
            verify(restaurant)
        end
    end

    def change_password
        input = @@prompt.mask("Please Enter Your New Password:")
        input2 = @@prompt.mask("Re-enter The Same Password:")
        if input != input2
            puts "ERROR: Password Mismatch. Try Again".colorize(:color => :red)
            self.change_password
        else
            self.update_column(:password, input)
            puts "***Password Reset***".colorize(:color => :green)
        end
    end

    def open
        resos = Reservation.where(restaurant: self, user_id: nil)
        if resos.length > 0
            puts "The following have not yet been reserved:\n\n"
            resos.sort_by(&:datetime).each do |reso| 
                puts "#{reso.datetime} - Table of #{reso.table_size}"
            end
        else
            puts "All of your reservation listings are fully booked.".colorize(:color => :red)
        end
    end

    def reserved
        # resos = Reservation.where(restaurant: self , user_id: (1..100) )
       resos = Reservation.where.not(user_id: nil ).where(restaurant: self)
        if resos.length > 0
            resos.sort_by(&:datetime).each do |reso| 
                puts self.class.print_reso(reso)
            end
        else
            puts "No tables are currently reserved at your restaurant.".colorize(:color => :red)
        end
    end 

    def self.print_reso(reso)
        if reso.user != nil
            "#{reso.user.name} - table of #{reso.table_size} - datetime: #{reso.datetime}"
        else
            "table of #{reso.table_size} - datetime: #{reso.datetime}"
        end
    end

    def delete_booked_reso
        resos = Reservation.where.not(user_id: nil ).where(restaurant: self)
        if resos.length > 0
            @@prompt.select("Which reservation would you like to cancel?") do |q|
                resos.sort_by(&:datetime).each do |reso|
                    q.choice Restaurant.print_reso(reso), -> {reso}
                end
            end.destroy
            puts "*** RESERVATION CANCELED ***".colorize(:color => :green)
        else
            puts "There are no booked reservations to cancel.".colorize(:color => :red)
        end
    end

    def delete_open_reso
        resos = Reservation.all.where(restaurant: self, user_id: nil)
        if resos.length > 0
            @@prompt.select("Which reservation would you like to cancel?") do |q|
                resos.sort_by(&:datetime).each do |reso|
                    q.choice Restaurant.print_reso(reso), -> {reso}
                end
            end.destroy
            puts "*** RESERVATION CANCELED ***".colorize(:color => :green)
        else
            puts "There are no open reservations to cancel.".colorize(:color => :red)
        end
    end

    def create
        puts "What is the table size?"  
        table_size = gets.chomp
        puts "What time would you like to create an open reservation for?"
        datetime = gets.chomp 
        created = Reservation.create!(restaurant: self, table_size: table_size, datetime: DateTime.strptime(datetime, "%m/%d/%y %H:%M"))
        puts "\nCreating listing for table of #{created.table_size} at #{created.datetime}........"
        puts "*** Your reservation listing has been created ***".colorize(:color => :green)
    end

    def update
        resos = Reservation.all.where(restaurant: self, user_id: nil)
        if resos.length > 0
            reso_chosen = @@prompt.select("Which listing would you like to update?") do |q|
                resos.sort_by(&:datetime).each do |reso|
                    q.choice Restaurant.print_reso(reso), -> {reso}
                end
            end
            puts "What would you like to change the table size to?"
            table_size = gets.chomp
            reso_chosen.update(table_size: table_size)
            puts "*** Reservation Updated ***".colorize(:color => :green)
        else
            puts "There are no open reservations to update.".colorize(:color => :red)
        end
    end
end