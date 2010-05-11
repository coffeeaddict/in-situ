# Include hook code here

require 'in_situ'

ActionView::Base.send( :include, InSitu::Helper )
ActionController::Base.send( :include, InSitu::Controller )

RAILS_DEFAULT_LOGGER.info "In-situ in-place"
