require 'date'

module Polycon
 module Filter
    def monday_week(date)
        case DateTime.parse(date).strftime("%A")
         when "Monday"
            DateTime.parse(date)
         when "Tuesday"
            (DateTime.parse(date)-1)
         when "Wednesday"
            (DateTime.parse(date)-2)
         when "Thursday"
            (DateTime.parse(date)-3)
         when "Friday"
            (DateTime.parse(date)-4)
         when "Saturday"
            (DateTime.parse(date)-5)
         when "Sunday"
            (DateTime.parse(date)-6)
        end
    end
 end
end