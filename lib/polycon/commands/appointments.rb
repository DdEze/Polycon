require 'time'

module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          #warn "TODO: Implementar creación de un turno con fecha '#{date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        
          if Dir.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}") && Time.now <= Time.parse(date) && !(File.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf"))
             file=File.open(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf","w")
             file.puts("Name: #{name}\nSurname: #{surname}\nPhone: #{phone}\nNotes: #{notes}")
             file.close
             puts "Appointments created correctly"
          elsif Time.now >= Time.parse(date)
             puts "Incorrect date"
          elsif File.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf")
             puts "Appointments already existing" 
          else
             puts "The proffsional does not exist"
          end
          #
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          if File.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf")
             puts "Appointment\nProfessional: #{professional}\nDate: #{date}\n#{File.read(Dir.home + "/.Polycon/Professionals/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf")}"
          elsif !(Dir.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}"))
            puts "The proffsional does not exist"
          else
             puts "There is no turn for this date"
          end  
          #

        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #warn "TODO: Implementar borrado de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          
          if File.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf")
             FileUtils.rm_rf(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf")
            puts "Appointments canceled"
            elsif !(Dir.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}"))
             puts "The proffsional does not exist"
          else
             puts "There is no turn for this date"
          end
          #
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          #warn "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          if Dir.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}")
            FileUtils.rm_rf(Dir.glob(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/*"))
            puts "They were tired all the appointments of the professional #{professional}"
          else
            puts "The proffsional does not exist"
          end
          #
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'

        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:)
          #warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          puts (Dir.entries(Dir.home + "/.Polycon/#{professional}")).select {|f| !File.directory? f}
          #
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          #warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          if File.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{old_date.gsub(" ", "_")}.paf")
            FileUtils.mv(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{old_date.gsub(" ", "_")}.paf", Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{new_date.gsub(" ", "_")}.paf")
            puts "Up-to-date appointments"
          elsif !Dir.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}")
            puts "This professional does not exist"
          else
            puts "This appointment does not exist"
          end
          #
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          if File.exist?(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf")
             file = File.open(Dir.home + "/.Polycon/#{professional.gsub(" ","_")}/#{date.gsub(" ", "_")}.paf", "r")
             s=""
             file.each_line do |line|
               s = s + line
             end
             file.close
          end
          #
        end
      end
    end
  end
end
