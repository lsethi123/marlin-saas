class Picture
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :property
  mount_uploader :image, PictureUploader
end