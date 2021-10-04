module Polycon
 module Patch
        
     #rutas de los profesionales y turno
        
     def rute_professional(professional)
         (Dir.home) + "/.Polycon/#{professional.gsub(" ","_")}"
     end

     def rute_appointment(professional, date)
         self.rute_professional(professional) + "/#{date.gsub(" ","_")}.paf"
     end

     #metodos exist?

     def professional_exist?(professional)
         Dir.exists?(self.rute_professional(professional))
     end

     def appointment_exist?(professional, date)
         File.exist?(self.rute_appointment(professional,date))
     end
         
 end
end