require './lib/polycon/models/appointment'
require './lib/polycon/models/filter'
require './lib/polycon/models/professional'

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
          begin
           warn Appointment.new(date, professional).create(name, surname, phone, notes)
          rescue
            warn "Make sure the date you enter is in the format yyyy-mm-dd hh: mm"
          end

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
          begin
              warn (Appointment.new(date, professional)).show
          rescue
              warn "Make sure the date you enter is in the format yyyy-mm-dd hh: mm"
          end

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
          begin
              warn (Appointment.new(date, professional)).cancel
          rescue
              warn "Make sure the date you enter is in the format yyyy-mm-dd hh: mm"
          end
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
          warn Appointment.cancel_all(professional)

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
          warn Appointment.list(professional)

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
          begin
             warn Appointment.reschedule(old_date, new_date, professional)
          rescue
             warn "Make sure the date you enter is in the format yyyy-mm-dd hh: mm"
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

          #warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
           warn (Appointment.new(date, professional)).edit(**options)
          rescue
            warn "Make sure the date you enter is in the format yyyy-mm-dd hh: mm"
          end

        end
      end

      class List_By_Day < Dry::CLI::Command

        desc 'list all the appointmnts of a particular day'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: false, desc: 'Full name of the professional'

        example [
          '"2021-09-16" # Show all appointments on that date in html file.',
          '"2021-09-16" --professional="Alma Estevez" #Show all appointments on that date in html file of the professional Alma Estevez.',
        ]

        def call (date:, professional: nil)
          
           begin
             warn Appointment.day(date, professional)
           rescue
             warn "Make sure the date you enter is in the format yyyy-mm-dd"
           end
        end

      end

      class List_By_Week < Dry::CLI::Command 
        
        desc 'list all the appointmnts of a particular day'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: false, desc: 'Full name of the professional'

        example [
          '"2021-09-16" # Show all appointments in that week in html file.',
          '"2021-09-16" --professional="Alma Estevez" #Show all appointments in that week in html file of the professional Alma Estevez.',
        ]

        def call (date:, professional: nil)
           begin
              warn Appointment.week(DateTime.parse(date).strftime("%F_08:00"),professional)
           rescue
             warn "Make sure the date you enter is in the format yyyy-mm-dd hh"
           end
        end

      end

    end
  end
end
