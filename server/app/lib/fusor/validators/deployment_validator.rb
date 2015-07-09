module Fusor
  module Validators
    class DeploymentValidator < ActiveModel::Validator
      def validate(deployment)
        if not (deployment.deploy_rhev or deployment.deploy_cfme or deployment.deploy_openstack)
          deployment.errors[:base] << _('You must deploy something...')
        end

        if deployment.deploy_rhev
          # 1) must have a root password
          # 2) must have a rhev manager password
          # 2) must have valid storage type
          # 3) must have valid storage options to match that type
          # 4) must have engine
          # 5) must have at least one hypervisor
          if deployment.rhev_root_password.empty?
            deployment.errors[:rhev_root_password] << _('RHEV deployments must specify a root password for the RHEV machines')
          end

          if deployment.rhev_engine_admin_password.empty?
            deployment.errors[:rhev_engine_admin_password] << _('RHEV deployments must specify an admin password for the RHEV Engine')
          end

          if deployment.rhev_storage_type.empty? or not ['NFS', 'Local', 'Gluster'].include?(deployment.rhev_storage_type)
            deployment.errors[:rhev_storage_type] << _('RHEV deployments must specify a valid storage type (NFS, Local, Gluster)')
          end

          if deployment.rhev_storage_type == 'NFS' 
            if deployment.rhev_storage_address.empty?
              deployment.errors[:rhev_storage_address] << _('NFS share specified but missing address of NFS server')
            end

            if deployment.rhev_share_path.empty?
              deployment.errors[:rhev_share_path] << _('NFS share specified but missing path to the share')
            end
          end


          if deployment.rhev_storage_type == 'Local' 
            if deployment.rhev_local_storage_path.empty?
              deployment.errors[:rhev_local_storage_path] << _('Local storage specified but missing local storage path')
            end
          end

          if deployment.rhev_storage_type == 'Gluster'
            if deployment.rhev_gluster_node_name.empty?
              deployment.errors[:rhev_gluster_node_name] << _('Gluster storage specified but missing Gluster node name')
            end

            if deployment.rhev_gluster_node_address.empty?
              deployment.errors[:rhev_gluster_node_address] << _('Gluster storage specified but missing Gluster node address')
            end

            if deployment.rhev_gluster_root_password.empty?
              deployment.errors[:rhev_gluster_root_password] << _('Gluster storage specified but missing Gluster root password')
            end
          end

          if deployment.rhev_engine_host_id.nil?
            deployment.errors[:rhev_engine_host_id] << _('RHEV deployments must have a RHEV Engine Host')
          end

          if deployment.rhev_hypervisor_hosts.count < 1
            deployment.errors[:rhev_hypervisor_hosts] << _('RHEV deployments must have at least one Hypervisor')
          end
        end

        if deployment.deploy_cfme
          # 1) must also deploy either rhev or openstack
          # 2) must have install location
          # 3) must have cfme root password
          if not (deployment.deploy_rhev or deployment.deploy_openstack)
            deployment.errors[:deploy_cfme] << _("CloudForms deployments must also deploy either RHEV or OpenStack")
          end

          if deployment.cfme_install_loc.empty?
            deployment.errors[:cfme_install_loc] << _('CloudForms deployments must specify an install location')
          end

          if deployment.cfme_root_password.empty?
            deployment.errors[:cfme_root_password] << _('CloudForms deployments must specify a root password for the CloudForms machines')
          end
        end
      end
    end
  end
end
