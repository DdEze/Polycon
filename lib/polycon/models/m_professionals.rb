require './lib/polycon/models/patch'
module Polycon
     module Professionals_methods include Patch
         def create_professional(professional)
             create = Proc.new do
                 if self.professional_exist?(professional)
                     puts "This professional already exists"
                 else
                     Dir.mkdir(self.rute_professional(professional))
                     puts "Creates a new professional named '#{professional}'"
                 end
             end
             self.polycon(create)
         end

         def delete_professional(professional)
             delete = Proc.new do
                if self.professional_exist?(professional)
                      FileUtils.rm_rf(self.rute_professional(professional))
                      puts "This professional was successfully deleted"
                else
                      puts "This professional does not exist"
                end
             end
             self.polycon(delete)
         end

         def list_professionals
             list = Proc.new do
                 puts (Dir.entries(Dir.home + "/.Polycon")).select {|f| !File.directory? f}
             end
             self.polycon(list)
         end
       
         def rename_professional(old_name, new_name)
             rename = Proc.new do
                 if self.professional_exist?(old_name)
                     FileUtils.mv(self.rute_professional(old_name), self.rute_professional(new_name))
                     puts "Up-to-date professional"
                 elsif self.professional_exist?(new_name)
                     puts "You can't change to that name"
                 else
                     puts "This professional does not exist"
                 end
             end
             self.polycon(rename) 
         end
     end
end