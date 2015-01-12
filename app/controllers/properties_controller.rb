class PropertiesController < DashboardController
  before_action :set_property, :except => [:index, :new, :create, :tags]
  respond_to :json, :only => :booking_detail

  def index
    @properties = current_account.properties.order_by(:created_at => :desc).page(params[:page]).per(10)
  end

  def new
    @property = current_account.properties.build
    @property.contact.build_address(local_info)
    @property = @property.decorate
  end

  def create
    @property = current_account.properties.build property_params
    if @property.save
      redirect_to property_path(@property), :notice => 'New property created successfully.' 
    else
      render :action => 'new'
    end
  end

  def update
    if @property.update(property_params)
      redirect_to property_path(@property), :notice => 'Property updated successfully.' 
    else
      render :action => 'edit'
    end
  end

  def destroy
    @property = current_account.properties.find(params[:id])
    if @property.destroy
      redirect_to properties_path, :notice => 'The property was successfully removed.'
    else
      redirect_to edit_property_path(@property), :error => 'Something went wrong trying to delete a property. We\'re already taking care of the issue.' 
    end
  end

  def tags
    respond_to do |format|
      format.html
      format.json { 
        re = /#{Regexp.escape(params[:q])}/i
        tags = current_account.properties.only(:tags).where(:tags.ne => nil).map {|p| p.tags }
        tags.flatten!
        tags = tags.grep re
        tags.map! { |t| {:id => t, :name => t} }
        render :json => tags
      }
    end
  end

  def booking_detail
    render :json => @property.booking_info(params[:check_in], params[:check_out])
  end

  def rental_history
    @dt_start = params[:dt_start].present? ? Date.parse(params[:dt_start]) : (Date.today - 1.month) rescue Date.today
    @dt_end   = params[:dt_end].present? ? Date.parse(params[:dt_end]) : Date.today rescue Date.today

    @bookings = @property.reservations.any_of( 
      {'$and' => [{:check_in.gte => @dt_start}, {:check_in.lte => @dt_end}]},
      {'$and' => [{:check_out.gte => @dt_start}, {:check_out.lte => @dt_end}]}
    ).order_by(check_in: :asc).page(params[:page]||1).per(20)
  end

  def booking_calendar
    @date     = params[:date] ? Date.parse(params[:date]) : Date.today.beginning_of_month
    @end_date = (@date + 3.months).end_of_month
    @bookings = @property.reservations.any_of( 
      {'$and' => [{:check_in.gte => @date}, {:check_in.lte => @end_date}]},
      {'$and' => [{:check_out.gte => @date}, {:check_out.lte => @end_date}]}
    )
  end

  private

  def set_property
    @property = current_account.properties.find(params[:id])
    render :template => "errors/not_found", :status => :not_found unless @property 
    @property = @property.decorate if @property.present?
  end

  def local_info
    Geocoder.configure(:timeout => 5)
    local = request.ip.eql?('127.0.0.1') ? Geocoder.search("204.57.220.1").first : request.location
    local.nil? ? {} : {:country => local.country_code, :state => local.state_code, :city => local.city, :zip_code => local.data['zip_code']}
  end

  def property_params
    return {} if params[:property].empty?
    pp = params[:property]
    if pp[:check_in].nil? && pp[:check_out].nil? && params[:date].present?
      check_in = "#{params[:date][:ci_hour]}:#{params[:date][:ci_minutes]}" 
      check_out = "#{params[:date][:co_hour]}:#{params[:date][:co_minutes]}"
      params[:property].reject! {|k| k.include? 'check'}
      params[:property].merge!({:check_in => check_in, :check_out => check_out})
    end
    params[:property][:tags] = params[:property][:tags].split(',') if params[:property][:tags].present?
    params.require(:property).permit(:name, :unit_type, :description, { tags: [] }, :check_in, :check_out, :property_size, :minimum_days, 
      :num_persons_allowed, :pets_allowed, :directions, :bedrooms, :bathrooms, :garages, :kitchen, :bedding, :amenities, 
      :contact_attributes => {:address_attributes =>  [:country, :city, :state, :zip_code, :area, :street] })
  end
end
