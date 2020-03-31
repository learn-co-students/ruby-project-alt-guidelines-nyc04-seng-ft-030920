class Reservation < ActiveRecord::Base

    belongs_to :restaurant
    belongs_to :user

    @prompt = TTY::Prompt.new(active_color: :blue)

    def self.open
        Reservation.all.where(user_id: nil).sort_by(&:datetime)
    end

    def self.closed
        Reservation.all.where.not(user_id: nil).sort_by(&:datetime)
    end

    def self.done
        puts `clear`
        puts "\n\n\n#---------Thanks For Using FreeTable---------#".colorize(:color => :green)
        exit
    end
end