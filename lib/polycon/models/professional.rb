require './lib/polycon/models/patch'
module Polycon
     class Professional include Patch

         def initialize(professional)
             @professional=professional
         end
        
         def create
             create = Proc.new do
                 if self.professional_exist?(@professional)
                     puts "This professional already exists"
                 else
                     Dir.mkdir(self.rute_professional(@professional))
                     puts "Creates a new professional named '#{@professional}'"
                 end
             end
             self.polycon(create)
         end

         def delete
             delete = Proc.new do
                if self.professional_exist?(@professional)
                      FileUtils.rm_rf(self.rute_professional(@professional))
                      puts "This professional was successfully deleted and his appointments canceled"
                else
                      puts "This professional does not exist"
                end
             end
             self.polycon(delete)
         end

         def self.list
             extend Patch
             list = Proc.new do
                 puts (Dir.entries(Dir.home + "/.polycon")).select {|f| !File.directory? f}
             end
             self.polycon(list)
         end
       
         def self.rename(old_name, new_name)
             extend Patch
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