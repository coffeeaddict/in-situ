# In-situ

module InSitu
  # Helpers for the view
  module Helper
    # render a partial with the value of the given object, clickable to
    # display the form
    def in_situ(object, attribute, options = {})
      render(
        :partial => "in-situ/show",
        :locals  => {
          :object    => object,
          :attribute => attribute,
          :format    => options[:format],
          :type      => options[:type]
        }
      )
    end
     # make a nice little element id from object, id and attribute name
    def in_situ_id(object, attribute)
      return [ object.class.name, object.id, attribute ].join("_")
    end

    def in_situ_element(id)
      (type,id,attribute) = id.split "_"
    end
  end

  # methods for in the controllers
  module Controller
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_in_situ
        include InSitu::Controller::InstanceMethods
      end
    end

    module InstanceMethods
      # show a form for the given object / attribute
      def in_situ
        klass = nil
        eval "klass = #{params[:type]}"
    
        @object    = klass.find(params[:id])
        @attribute = params[:attribute]
    
        render :update do |page|
          page.replace_html(
            in_situ_id(@object, @attribute),
            :partial => "in-situ/form"
          )
        end
      end

      # cancel the in-situ editing. Needles, but comforting to some
      def in_situ_cancel
        klass = nil
        eval "klass = #{params[:type]}"
    
        @object    = klass.find(params[:id])
        @attribute = params[:attribute]
    
        render :update do |page|
          page.replace_html(
            in_situ_id(@object, @attribute),
            :partial => "in-situ/show",
            :locals => {
              :object    => @object,
              :attribute => @attribute,
              :format    => nil,
            }
          )
        end        
      end

      # store the new object / attribute and re-display the in-situ clickable
      def in_situ_update
        klass = nil
        eval "klass = #{params[:type]}"
        object    = klass.find(params[:id])
        attribute = params[:attribute]
     
        if object.update_attributes(params[params[:type].downcase])
          render :update do |page|
            page.replace(
              in_situ_id(object, attribute),
              :partial => "in-situ/show",
              :locals  => {
                :object    => object,
                :attribute => attribute,
                :format => nil
              }
            )
          end
        else
          render :update do |page|
            page.replace_html(in_situ_ud(object,attribute), "error")
          end
        end                     
      end

    end # /InstanceMethods
  end # /Controller
end # /InSitu
