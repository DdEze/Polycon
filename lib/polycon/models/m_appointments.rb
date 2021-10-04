require 'time'
require './lib/polycon/models/patch'
module Polycon
     module Appointmets_methods include Patch
        def professional_message(professional, date, proc)
            if self.professional_exist?(professional)
                self.date_message(professional, date, proc) 
            else
                puts "The professional does not exist"
            end
        end

        def date_message(professional, date, proc)
            if self.appointment_exist?(professional, date)
                proc.call
            else
                puts "There is no appointmets for this date"
            end
        end

        def create_appointmet(date, professional, name, surname, phone, notes)
            if (Time.now <= Time.parse(date)) && (self.professional_exist?(professional)) && !self.appointment_exist?(professional, date)
                file=File.open(self.rute_appointment(professional, date),"w")
                file.puts("Name: #{name}\nSurname: #{surname}\nPhone: #{phone}\nNotes: #{notes}")
                file.close
                puts "Appointments created correctly"
            elsif !self.professional_exist?(professional)
                puts "The professional does not exist"
            elsif  self.appointment_exist?(professional, date)
                puts "Appointments already existing"
            else
                puts "Incorrect date"
            end
        end

        def show_appointment(date, professional)
           show = Proc.new do
                puts "Appointment\nProfessional: #{professional}\nDate: #{date}\n#{File.read(self.rute_appointment(professional, date))}"
           end
           self.professional_message(professional,date,show)
        end

        def cancel_appointment(date, professional)
           cancel = Proc.new do
                FileUtils.rm_rf(self.rute_appointment(professional,date))
                puts "Appointments canceled"
           end
           self.professional_message(professional,date,cancel)
        end

        def cancel_all_appointment(professional)
            if Dir.exist?(self.rute_professional(professional))
                FileUtils.rm_rf(Dir.glob("#{self.rute_professional(professional)}/*"))
                puts "They were tired all the appointments of the professional #{professional}"
            else
                puts "The proffsional does not exist"
            end
        end

        def list_appointmets(professional)
           if self.professional_exist?(professional)
                puts (Dir.entries(self.rute_professional(professional))).select {|f| !File.directory? f}
           else
                puts  "The professional does not exist"
           end
        end

        def reschedule_appointment(old_date,new_date, professional)
            reschedule = Proc.new do
               if (self.appointment_exist?(professional, new_date))
                   puts "This appointment already exists"
               else
                    FileUtils.mv(self.rute_appointment(professional,old_date), self.rute_appointment(professional,new_date))
                    puts "Up-to-date appointment"
               end
            end
            self.professional_message(professional,old_date,reschedule)
        end

        def edit_appointment(date, professional, **options)
           edit = Proc.new do
                array = File.readlines(self.rute_appointment(professional, date))
                options.each do |clave, valor|
                   case clave.to_s
                     when "name"
                       array[0]="#{clave.capitalize}: #{valor}"
                     when "surname"
                       array[1]="#{clave.capitalize}: #{valor}"
                     when "phone"
                       array[2]="#{clave.capitalize}: #{valor}"
                     when "notes"
                       array[3]="#{clave.capitalize}: #{valor}"
                   end
                end
                 file=File.open(self.rute_appointment(professional,date),"w")
                 file.puts(array)
                 file.close
                 puts "Up-to-date appointment"
           end
           self.professional_message(professional,date,edit)
        end
     end
end