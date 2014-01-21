class PropertiesController < DashboardController
  def index
    @properties = current_user.account.properties.order_by(:created_at => :desc)
  end

  def new
    @property = current_user.account.properties.build   
    @property.contact.addresses.build     
  end

  def create
    @property = current_user.account.properties.build property_params
    if @property.save
      redirect_to edit_property_path(@property), :notice => 'New property created successfully.' 
    else
      render :action => 'new'
    end
  end

  def edit
    @property = current_user.account.properties.find(params[:id])
    render :template => "errors/not_found", :status => :not_found unless @property 
  end

  def update
    @property = current_user.account.properties.find(params[:id])
    if @property.save
      redirect_to edit_property_path(@property), :notice => 'Property updated successfully.' 
    else
      render :action => 'edit'
    end
  end

  def destroy
    @property = current_user.account.properties.find(params[:id])
    if @property.destroy
      redirect_to properties_path, :notice => 'The property was successfully removed.'
    else
      redirect_to edit_property_path(@property), :error => 'Something went wrong trying to delete a property. We\'re already taking care of the issue.' 
    end
  end

  def show
    @property = current_user.account.properties.find(params[:id])
    render :template => "errors/not_found", :status => :not_found unless @property    
  end

  private

  def property_params
    pp = params[:property]
    if pp[:check_in].nil? && pp[:check_out].nil?
      check_in = Time.local(pp['check_in(1i)'], pp['check_in(2i)'], pp['check_in(3i)'], pp['check_in(4i)'], pp['check_in(5i)'])
      check_out = Time.local(pp['check_out(1i)'], pp['check_out(2i)'], pp['check_out(3i)'], pp['check_out(4i)'], pp['check_out(5i)'])
      params[:property].reject! {|k| k.include? 'check'}
      params[:property].merge!({:check_in => check_in, :check_out => check_out})
    end
    params.require(:property).permit(:name, :unit_type, :description, :check_in, :check_out, :property_size, :minimum_days, :num_persons_allowed, :pets_allowed, :contact)
  end
end