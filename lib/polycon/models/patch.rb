module Polycon
 module Patch

     #rutas de los profesionales y turno

     def rute_professional(professional)
         (Dir.home) + "/.polycon/#{professional.gsub(" ","_")}"
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

     def polycon_exist?
         Dir.exist?((Dir.home) + "/.polycon")
     end

    #metodo para verificar la carpeta polycon

     def polycon(method)
         if self.polycon_exist?
              method.call
         else
             Dir.mkdir(Dir.home + "/.polycon")
             "Directory #{(Dir.home)}/.polycon does not exist\nA .polycon directory will be created in your home directory"
         end
     end
 
 end
end