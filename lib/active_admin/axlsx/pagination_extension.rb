module ActiveAdmin
  module Axlsx
    module ResourceController
      module Collection
        module Pagination

          # Again, like the resource controller extention for index - this
          # needs to have some changes in ActiveAdmin. We should not be
          # redefining this method. The configuration needs to support a 
          # per_page option for all formats
          def per_page
            return max_csv_records if %w(text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet).include? request.format 
            return max_per_page if active_admin_config.paginate == false

            @per_page || active_admin_config.per_page
          end

        end
      end
    end
  end
end
