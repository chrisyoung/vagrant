require "log4r"

module Vagrant
  module Action
    module Builtin
      # This action will run the cleanup methods on provisioners and should
      # be used as part of any Destroy action.
      class ProvisionerCleanup
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::action::builtin::provision_cleanup")
        end

        def call(env)
          # Ask the provisioners to modify the configuration if needed
          provisioners.each do |p|
            env[:ui].info(I18n.t(
              "vagrant.provisioner_cleanup",
              name: provisioner_type_map[p].to_s))
            p.cleanup
          end

          # Continue, we need the VM to be booted.
          @app.call(env)
        end
      end
    end
  end
end
