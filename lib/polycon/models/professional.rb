require './lib/polycon/models/patch'

module Polycon
     class Professional include Patch

         def initialize(professional)
             @professional=professional
         end

         def name
            @professional
         end
        
         def create
             create = Proc.new do
                 if self.professional_exist?(@professional)
                     "This professional already exists"
                 else
                     Dir.mkdir(self.rute_professional(@professional))
                     "Creates a new professional named '#{@professional}'"
                 end
             end
             self.polycon(create)
         end

         def delete
             delete = Proc.new do
                if self.professional_exist?(@professional) && (Dir.empty?(self.rute_professional(@professional)))
                      FileUtils.rm_rf(self.rute_professional(@professional))
                      "#{@professional} was removed from the system"
                elsif (self.professional_exist?(@professional))&&(!Dir.empty?(self.rute_professional(@professional)))
                      "To delete #{@professional} from the system first cancel your appointments"
                else
                      "This professional does not exist"
                end
             end
             self.polycon(delete)
         end

         def self.list
             extend Patch
             list = Proc.new do
                 (Dir.entries(Dir.home + "/.polycon")).map {|f| 
                     if !File.directory? f
                         f.gsub("_", " ")
                     end
                     }.compact
             end
             self.polycon(list)
         end
       
         def self.rename(old_name, new_name)
             extend Patch
             rename = Proc.new do
                 if self.professional_exist?(old_name) && !self.professional_exist?(new_name)
                     FileUtils.mv(self.rute_professional(old_name), self.rute_professional(new_name))
                     "Up-to-date professional"
                 elsif self.professional_exist?(old_name) && self.professional_exist?(new_name)
                     "You can't change to that name"
                 else
                     "This professional does not exist"
                 end
             end
             self.polycon(rename) 
         end

         def self.appointments(professional)
            Appointment.list(professional)
         end

         def data_of_patient(day)
             if (self.appointment_exist?(@professional, day))
                 "#{Appointment.new(day, @professional).surname_of_patient} #{Appointment.new(day, @professional).name_of_patient}"
             else
                " Sin turno "
             end
         end

         def self.appointments_week?(professional, week)
             range = week..(week + 6)
             array = Professional.appointments(professional).select {|appointment| range.include?(DateTime.parse(appointment))}
             (array.size == 0)
         end
     end
end