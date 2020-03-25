class Restaurant < ActiveRecord::Base

    @prompt = TTY::Prompt.new

    def self.list_by_name
        Restaurant.all.map(&:name)
    end

    def self.log_in
        @prompt.select("Please select your restaurant from the following: ", list_by_name)
    # ^^^ needs to be a restaurant instance
    end

    def show_open
        Reservation.all.where(user_id: nil && restaurant == self)
    end

    def reserved
        # Return reserved instances for a particular restaurant instance
    end

    def delete
        # Prompt restaurant with list of reservations and ask which they wish to cancel
    end

    def change
        # Prompt restaurant with change options
    end
end