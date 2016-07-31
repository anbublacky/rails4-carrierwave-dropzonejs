class Student < ActiveRecord::Base
  mount_uploaders :imagefile, ImageUploader

  # validates :name, :presence => true
  # validates :age, :presence => true, :numericality => { :only_integer => true }
  validate :image_present

	def image_present
	  if imagefile.present? && imagefile.map {|image| image.size}.sum + imagefile.size > 10.megabytes
	    errors.add(:image, "Limit of 10MB has been reached.")
	  end
	end

end
