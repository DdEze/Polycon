require './lib/polycon/models/patch'
require 'date'
module Polycon
     class Appointment include Patch

        def initialize(date, professional)
            begin
                 @date = self.date_format(date)
                 @professional = professional
            rescue
                  puts "Make sure the date you enter is in the format yyyy-mm-dd hh: mm"
            end
        end

        def valid_phone?(number)
             ((number.to_i.to_s.length) == 10 && number.length == 10)
        end

        def error_phone(number, method)
            begin
                if self.valid_phone?(number)
                     self.polycon(method)
                else
                     raise
                end
            rescue
                 puts "Invalid phone number, be sure to enter a phone number"
            end
        end

        def date_format(date_format)
            begin
             return DateTime.parse(date_format).strftime("%F_%R")
            rescue
             puts "Make sure the date you enter is in the format yyyy-mm-dd hh: mm"
            end
        end
        
        def professional_message(method)
            message = Proc.new do
                if self.professional_exist?(@professional)
                    self.date_message(method) 
                else
                    puts "The professional does not exist"
                end
            end
            self.polycon(message)
        end

        def date_message(method)
            if self.appointment_exist?(@professional, @date)
                method.call
            else
                puts "There is no appointmets for this date"
            end
        end

        def create(name, surname, phone, notes)
            create = Proc.new do
                 if (DateTime.now <= DateTime.parse(@date)) && (self.professional_exist?(@professional)) && !self.appointment_exist?(@professional, @date)
                     file=File.open(self.rute_appointment(@professional, @date),"w")
                     file.puts("Name: #{name}\nSurname: #{surname}\nPhone: #{phone}\nNotes: #{notes}")
                     file.close
                     puts "Appointments created correctly"
                 elsif !self.professional_exist?(@professional)
                     puts "The professional does not exist"
                 elsif  self.appointment_exist?(@professional, @date)
                     puts "Appointments already existing"
                 else
                     puts "Incorrect date"
                 end
            end
            self.error_phone(phone, create)
        end

        def show
           show = Proc.new do
                puts "Appointment\nProfessional: #{@professional}\nDate: #{@date.gsub("_"," ")}\n#{File.read(self.rute_appointment(@professional, @date))}"
           end
           self.professional_message(show)
        end

        def cancel
           cancel = Proc.new do
                FileUtils.rm_rf(self.rute_appointment(@professional,@date))
                puts "Appointments canceled"
           end
           self.professional_message(cancel)
        end

        def self.cancel_all(professional)
            extend Patch
            cancel_all = Proc.new do
                 if Dir.exist?(self.rute_professional(professional))
                     FileUtils.rm_rf(Dir.glob("#{self.rute_professional(professional)}/*"))
                     puts "They were tired all the appointments of the professional #{professional}"
                 else
                     puts "The proffsional does not exist"
                 end
            end
            self.polycon(cancel_all)
        end

        def self.list(professional)
           extend Patch
           list = Proc.new do
                 if self.professional_exist?(professional)
                     puts (Dir.entries(self.rute_professional(professional))).select {|f| !File.directory? f}
                 else
                     puts  "The professional does not exist"
                 end
            end
            self.polycon(list)
        end

        def self.reschedule(old_date,new_date, professional)
            extend Patch
            appointment=Appointment.new(old_date,professional)
            old_date_format= appointment.date_format(old_date)
            new_date_format= appointment.date_format(new_date)
            reschedule = Proc.new do
               if (self.appointment_exist?(professional, new_date_format))
                    puts "This appointment already exists"
               else
                    FileUtils.mv(self.rute_appointment(professional,old_date_format), self.rute_appointment(professional,new_date_format))
                    puts "Up-to-date appointment"
               end
            end
            appointment.professional_message(reschedule)
        end

        def edit(**options)
           edit = Proc.new do
                array = File.readlines(self.rute_appointment(@professional, @date))
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
                 file=File.open(self.rute_appointment(@professional,@date),"w")
                 file.puts(array)
                 file.close
                 puts "Up-to-date appointment"
           end
           if options.key?(:phone) && !self.valid_phone?(options[:phone])
             puts "Invalid phone number, be sure to enter a phone number"
           else
             self.professional_message(edit)
           end
        end
     end
end