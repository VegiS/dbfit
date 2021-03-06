include_recipe "dbfit_test::2gb_swapfile"

package "libaio"
#package "pam.i686" - fails with: ERROR: package[pam.i686] (dbfit_test::db2 line 4) had an error: NoMethodError: undefined method `arch' for Chef::Resource::Package
# So we use:
yum_package "pam.i686"
package "numactl"
package "libstdc++.i686"

execute 'install DB2 package if available' do
  project_root = node['dbfit']['project_root']

  user 'root'
  command "#{project_root}/dbfit-java/db2/src/integration-test/resources/install_db2.sh -dl"
  not_if "#{project_root}/dbfit-java/db2/src/integration-test/resources/detect_db2.sh"
  action :run
  returns [0, 2, 3]
end

