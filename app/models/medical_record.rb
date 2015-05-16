class MedicalRecord < ActiveRecord::Base
  mount_uploader :emr, MedicalRecordUploader

  belongs_to :record, polymorphic: true
  default_scope { order('updated_at DESC') }

  after_save :record_activity

  def record_activity
    title = 'Medical Record uploaded'
    badge = 'Medical Record'
    description = ''

    customer.activities.create(activity_type: self.class.name, action: :create, associated_id: self.id,
                               title: title, description: description, badge: badge, url: self.emr.url,
                               file_name: self.emr.file.filename)

    customer.timeline_activities.create(activity_type: self.class.name, action: :create, associated_id: self.id,
                                       assessment_activity_id: assessment_activity_id, title: title, description: description, badge: badge, url: self.emr.url,
                                       file_name: self.emr.file.filename)
  end

  def assessment_activity_id
    if is_customer?
      return 0
    else
      #assessment_activity = Timeline.find_by(associated_id: self.record.id)
      #return assessment_activity.id
      assessment_id = self.record.id
      assessment_id
    end
  end

  def customer
    is_customer? ? self.record : self.record.customer
  end

  def is_customer?
    self.record_type == 'Customer'
  end

  def default_icon_url
    medical_record_extensions = ['zip', 'rar', 'ppt', 'pptx', 'pdf', 'docx', 'doc', 'xls', 'xlsx']
    file_extension = self.emr.url.split('.').last
    if medical_record_extensions.include? file_extension
      return "#{file_extension}.png"
    else
      return 'default.png'
    end
  end
end
