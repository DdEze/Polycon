require './lib/polycon/models/patch'
require './lib/polycon/models/filter'
require './lib/polycon/models/professional'
require "erb"

module Polycon
    class Appointment include Patch

        def initialize(date, professional)
         @date = self.date_format(date)
         @professional = professional
        end

        def date
         @date
        end

        def professional
         @professional
        end

        def valid_phone?(number)
            ((number.to_i.to_s.length) == 10 && number.length == 10)
        end

        def valid_date?(date)
             d = DateTime.parse(date)
             (8..20).include?(d.hour) && (d.min == 0 || d.min == 30) && (d.hour != 20 || d.min != 30)
        end

        def error_valid(date, number, method)
             if self.valid_phone?(number) && self.valid_date?(date)
                 self.polycon(method)
             elsif !self.valid_phone?(number)
                 "Invalid phone number, be sure to enter a phone number" 
             else
                 "Appointments are given at the hour or hour and a half, between 8 and 20, enter the corresponding time"
             end
        end

        def date_format(date_format)
            DateTime.parse(date_format).strftime("%F_%R")
        end
        
        def professional_message(method)
            message = Proc.new do
                if self.professional_exist?(@professional)
                    self.date_message(method) 
                else
                   "The professional does not exist"
                end
            end
            self.polycon(message)
        end

        def date_message(method)
            if self.appointment_exist?(@professional, @date)
                method.call
            else
                "There is no appointmets for this date"
            end
        end

        def self.professional_message(method, professional)
            extend Patch
            menssage= Proc.new do
                 if  (professional.nil?) || (self.professional_exist?(professional))
                     method.call
                 else
                     "The professional does not exist"
                 end
            end
            self.polycon(menssage)
        end

        def create(name, surname, phone, notes)
            create = Proc.new do
                if (DateTime.now <= DateTime.parse(@date)) && (self.professional_exist?(@professional)) && !self.appointment_exist?(@professional, @date)
                 file=File.open(self.rute_appointment(@professional, @date),"w")
                 file.puts("Name: #{name}\nSurname: #{surname}\nPhone: #{phone}\nNotes: #{notes}")
                 file.close
                 "Appointments created correctly"
                elsif !self.professional_exist?(@professional)
                 "The professional does not exist"
                elsif  self.appointment_exist?(@professional, @date)
                 "Appointments already existing"
                else
                 "Incorrect date"
                end
            end
            self.error_valid(date, phone, create)
        end

        def show
            show = Proc.new do
             "Appointment\nProfessional: #{@professional}\nDate: #{@date.gsub("_"," ")}\n#{File.read(self.rute_appointment(@professional, @date))}"
            end
             self.professional_message(show)
        end

        def cancel
           cancel = Proc.new do
                FileUtils.rm_rf(self.rute_appointment(@professional,@date))
                "Appointments canceled"
           end
           self.professional_message(cancel)
        end

        def self.cancel_all(professional)
            extend Patch
            cancel_all = Proc.new do
                 if Dir.exist?(self.rute_professional(professional))
                     FileUtils.rm_rf(Dir.glob("#{self.rute_professional(professional)}/*"))
                     "They were tired all the appointments of the professional #{professional}"
                 else
                     "The proffesional does not exist"
                 end
            end
            self.polycon(cancel_all)
        end

        def self.list(professional)
           extend Patch
           list = Proc.new do
                 if self.professional_exist?(professional)
                     (Dir.entries(self.rute_professional(professional))).map {|f| 
                     if !File.directory? f
                        DateTime.parse(f).strftime("%F %R")
                     end
                     }.compact.sort{|app1, app2| DateTime.parse(app1) <=> DateTime.parse(app2)}
                 else
                     "The professional does not exist"
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
                    "This appointment already exists"
               else
                    FileUtils.mv(self.rute_appointment(professional,old_date_format), self.rute_appointment(professional,new_date_format))
                    "Up-to-date appointment"
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
                 "Up-to-date appointment"
           end
           if options.key?(:phone) && !self.valid_phone?(options[:phone])
             "Invalid phone number, be sure to enter a phone number"
           else
             self.professional_message(edit)
           end
        end

        def name_of_patient
            file= File.read(self.rute_appointment(@professional, @date)).split("\n")
            file[0].gsub("Name: ","")
        end

        def surname_of_patient
            file= File.read(self.rute_appointment(@professional, @date)).split("\n")
            file[1].gsub("Surname: ","")
        end

        def phone_of_patient
            file= File.read(self.rute_appointment(@professional, @date)).split("\n")
            file[2].gsub("Phone: ","")
        end

        def self.filter_by_day(date, professional)
            extend Patch
            new_date = DateTime.parse(date).strftime("%F")
            array = (Dir.entries(self.rute_professional(professional))).map {|f| 
            if  (!File.directory? f) && (DateTime.parse(f).strftime("%F")==new_date)
               Appointment.new(f.to_s,professional)
            end
            }.compact
        end

        def self.list_by_day(date, professional)
            extend Patch
            if professional.nil?
                 array2 = []
                 array=Professional.list
                 array.each do |pro| array2 = array2 + Appointment.filter_by_day(date, pro)
                 end
                 array2
            else 
                 begin
                     Appointment.filter_by_day(date, professional)
                 rescue
                     raise
                 end
            end
        end

        def self.day(date, professional)
          day=Proc.new do
             appointments = Appointment.list_by_day(date, professional).sort{ |app1, app2| app1.date <=> app2.date }
             templete = <<-ERB
                 <html lang="en">
                 <head>
                     <meta charset="UTF-8">
                     <meta http-equiv="X-UA-Compatible" content="IE-edge">
                     <meta name="viewport" content="width=device-width, initial-scale=1.0">
                     <title>Appointments by day</title>
                 </head>
                 <body>
                     <h1 align="center"> Appointments of <%= DateTime.parse(date).strftime("%F") %>  </h1>
                     <br></br>
                     <table align="center" border= 2>
                         <tr bgcolor="aqua" border= 2>
                             <th> Professional </th>
                             <th> Hour </th>
                             <th> Name of patient </th>
                             <th> Surname of patient </th>
                             <th> Phone of patient </th>
                         </tr>
                         <% appointments.each do |appointment| %>
                             <tr bgcolor="E7DEDD" border= 2>           
                                 <td align="center"> <%= appointment.professional.gsub("_"," ") %> </td>
                                 <td align="center"> <%= DateTime.parse(appointment.date).strftime("%H:%M") %> </td>
                                 <td align="center"> <%= appointment.name_of_patient %> </td>
                                 <td align="center"> <%= appointment.surname_of_patient %> </td>
                                 <td align="center"> <%= appointment.phone_of_patient %> </td>
                             </tr>
                        <%end%>
                     </table>
                 </body>
                 </html>
                ERB
                erb = ERB.new(templete)
                output = erb.result_with_hash(appointments: appointments, date:date)
                File.write(Dir.home + '/polycon_appointments.html', output)
                "polycon_appointmentts.html .update"
            end
            Appointment.professional_message(day, professional)
        end

        def self.professionals_week(professional, week)
            extend Patch
            if (professional.nil?)
              array=Professional.list
              array=array.map{|prof| 
                  if Professional.appointments_week?(prof,week)
                     Professional.new(prof)
                  end
                }.compact
            elsif self.professional_exist?(professional)
                 array=[Professional.new(professional)]
            else
                raise
            end
        end

        def self.week(date, professional)
            extend Filter
            extend Patch
            week=Proc.new do
             monday = Appointment.monday_week(date)
             professionals= Appointment.professionals_week(professional, monday)
             templete = <<-ERB
                 <html lang="en">
                 <head>
                     <meta charset="UTF-8">
                     <meta http-equiv="X-UA-Compatible" content="IE-edge">
                     <meta name="viewport" content="width=device-width, initial-scale=1.0">
                     <title>Appointments by week</title>
                 </head>
                 <body>
                     <h1 align="center"> Appointments <%= monday.strftime("%F") %> to  <%= (monday + 6).strftime("%F") %>  </h1>
                     <br></br>
                     <table align="center" border = 2>
                         <tr bgcolor="aqua" border = 2>
                             <th> Professional </th>
                             <th> Hour </th>
                             <%range = monday..(monday + 6)%>
                             <% range.to_a.each do | date | %>
                             <th>  <%= date.strftime("%A") %>  </th>
                             <% end %>
                         </tr>
                             <% date=monday %>
                             <% while (date.hour != 20) || (date.minute != 30)
                                 professionals.each do |professional| %>
                                     <tr bgcolor="E7DEDD" border = 2>
                                         <td align="center"> <%= professional.name.gsub("_"," ") %> </td>
                                         <td align="center"> <%= date.strftime("%R") %> </td>
                                         <td align="center"> <%= professional.data_of_patient(date.strftime("%F_%R")) %> </td>
                                         <td align="center"> <%= professional.data_of_patient((date + 1).strftime("%F_%R")) %> </td>
                                         <td align="center"> <%= professional.data_of_patient((date + 2).strftime("%F_%R")) %> </td>
                                         <td align="center"> <%= professional.data_of_patient((date + 3).strftime("%F_%R")) %> </td>
                                         <td align="center"> <%= professional.data_of_patient((date + 4).strftime("%F_%R")) %> </td>
                                         <td align="center"> <%= professional.data_of_patient((date + 5).strftime("%F_%R")) %> </td>
                                         <td align="center"> <%= professional.data_of_patient((date + 6).strftime("%F_%R")) %></td>
                                     </tr>
                                  <%end
                                  date = date + (30/1440.0)
                               end%>            
                        </table>
                    </body>
                    </html>
                ERB
                erb = ERB.new(templete)
                output = erb.result_with_hash( professionals: professionals, monday: monday)
                File.write(Dir.home + '/polycon_appointments.html', output)
                "polycon_appointmentts.html .update"
            end
            Appointment.professional_message(week, professional)
        end
    end
end