class StaticPagesController < ApplicationController
    add_breadcrumb "Home", :root_path
    def home
    end
end
