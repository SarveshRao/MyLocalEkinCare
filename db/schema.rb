# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150505063615) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "activity_type"
    t.string   "action"
    t.text     "text"
    t.integer  "associated_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "title"
    t.text     "description"
    t.string   "badge"
    t.string   "url"
    t.string   "file_name"
  end

  create_table "addresses", force: true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "addressee_id"
    t.string   "addressee_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "allergies", force: true do |t|
    t.string   "name"
    t.string   "reaction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointment_providers", force: true do |t|
    t.integer "provider_id"
    t.integer "appointment_id"
  end

  create_table "appointments", force: true do |t|
    t.date     "appointment_date"
    t.string   "time"
    t.string   "description"
    t.string   "appointment_type"
    t.integer  "appointmentee_id"
    t.string   "appointmentee_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "customer_address",   default: false
  end

  create_table "blog_posts", force: true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "tags"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "blood_groups", force: true do |t|
    t.string   "blood_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corrections", force: true do |t|
    t.integer  "prescription_id"
    t.string   "eye"
    t.string   "condition"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_sources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", force: true do |t|
    t.string   "code"
    t.float    "price"
    t.integer  "no_of_users_used"
    t.datetime "valid_from"
    t.datetime "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coupon_source_id"
  end

  create_table "customer_allergies", force: true do |t|
    t.integer  "customer_id"
    t.integer  "allergy_id"
    t.string   "severity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_coupons", force: true do |t|
    t.integer  "customer_id"
    t.integer  "coupon_id"
    t.boolean  "is_used"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "txn_id"
  end

  create_table "customer_immunizations", force: true do |t|
    t.integer  "customer_id"
    t.integer  "immunization_id"
    t.date     "date"
    t.string   "dosage"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_medical_conditions", force: true do |t|
    t.integer  "customer_id"
    t.integer  "medical_condition_id"
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_procedures", force: true do |t|
    t.integer  "customer_id"
    t.integer  "procedure_id"
    t.date     "date"
    t.integer  "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_vitals", force: true do |t|
    t.string   "customer_id"
    t.string   "weight"
    t.integer  "blood_group_id"
    t.integer  "feet"
    t.integer  "inches"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "waist"
    t.string   "wizard_status"
  end

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "martial_status"
    t.string   "religious_affiliation"
    t.string   "language_spoken"
    t.string   "email"
    t.date     "date_of_birth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "guardian_id"
    t.string   "mobile_number"
    t.string   "alternative_mobile_number"
    t.string   "customer_type"
    t.string   "customer_id"
    t.string   "weight"
    t.integer  "number_of_children"
    t.string   "daily_activity"
    t.string   "frequency_of_exercise"
    t.string   "smoke"
    t.string   "alcohol"
    t.string   "medical_insurance"
    t.integer  "blood_group_id"
    t.string   "diet"
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "feet"
    t.integer  "inches"
    t.string   "status"
    t.text     "general_issues"
    t.text     "other_body_parts"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "image"
    t.string   "otp_secret_key"
    t.string   "is_hypertensive"
    t.string   "diabetic"
    t.string   "is_obese"
    t.string   "is_over_weight"
  end

  add_index "customers", ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true, using: :btree
  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree
  add_index "customers", ["invitation_token"], name: "index_customers_on_invitation_token", unique: true, using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree

  create_table "doctor_opinions", force: true do |t|
    t.integer  "customer_id"
    t.string   "doctor_name"
    t.string   "doctor_mobile_number"
    t.string   "doctor_email"
    t.string   "otp_secret_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugs", force: true do |t|
    t.string   "name"
    t.string   "icd_code"
    t.string   "therepeutic_classification_type"
    t.text     "indian_names"
    t.text     "international_names"
    t.text     "why_it_is_prescribed"
    t.text     "when_it_is_not_to_be_taken"
    t.string   "pregnancy_category"
    t.text     "dosage_and_when_it_is_to_be_taken"
    t.text     "how_it_should_be_taken"
    t.text     "warnings_and_precautions"
    t.text     "side_effects"
    t.text     "other_precautions"
    t.text     "storage_conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "encounters", force: true do |t|
    t.string   "encounter"
    t.date     "date"
    t.integer  "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enterprises", force: true do |t|
    t.string   "name"
    t.string   "telephone"
    t.string   "offline_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "enterprise_id"
    t.string   "service_type"
  end

  create_table "examinations", force: true do |t|
    t.integer  "dental_assessment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "family_medical_conditions", force: true do |t|
    t.integer  "family_medical_history_id"
    t.integer  "medical_condition_id"
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "family_medical_histories", force: true do |t|
    t.string   "name"
    t.string   "relation"
    t.integer  "age"
    t.string   "status"
    t.string   "medical_condition_1"
    t.string   "medical_condition_2"
    t.string   "medical_condition_3"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "family_medical_condition"
    t.string   "mother_medical_condition"
  end

  create_table "health_assessment_promo_codes", force: true do |t|
    t.integer  "health_assessment_id"
    t.integer  "promo_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "health_assessments", force: true do |t|
    t.datetime "request_date"
    t.string   "assessment_type"
    t.boolean  "paid"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "package_type"
    t.string   "health_assessment_id"
    t.string   "type"
    t.integer  "status_code"
    t.string   "doctor_name"
    t.integer  "enterprise_id"
  end

  create_table "identities", force: true do |t|
    t.integer  "customer_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["customer_id"], name: "index_identities_on_customer_id", using: :btree

  create_table "immunizations", force: true do |t|
    t.string   "name"
    t.string   "immunization_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inboxes", force: true do |t|
    t.string   "activity_type"
    t.string   "action"
    t.text     "text"
    t.integer  "associated_id"
    t.integer  "customer_id"
    t.string   "title"
    t.text     "description"
    t.string   "badge"
    t.text     "url"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "associated_date"
    t.boolean  "status"
  end

  create_table "lab_results", force: true do |t|
    t.integer  "body_assessment_id"
    t.integer  "test_component_id"
    t.string   "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_tests", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "enterprise_id"
    t.string   "info"
  end

  create_table "medical_conditions", force: true do |t|
    t.string   "name"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medical_records", force: true do |t|
    t.string   "title"
    t.string   "record_type"
    t.integer  "record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "emr"
    t.date     "record_date"
    t.date     "date"
  end

  create_table "medications", force: true do |t|
    t.integer  "customer_id"
    t.datetime "date"
    t.integer  "drug_id"
    t.integer  "provider_id"
    t.string   "medication_type"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rate_quantity"
    t.string   "dose_quantity"
    t.boolean  "active",          default: true
    t.string   "prescriber_name"
    t.string   "name"
  end

  create_table "message_prompts", force: true do |t|
    t.integer  "risk_factor_id"
    t.string   "gender"
    t.string   "range"
    t.string   "message"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.text     "description"
    t.integer  "health_assessment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "staff_id"
  end

  create_table "package_details", force: true do |t|
    t.integer  "customer_id"
    t.integer  "package_id"
    t.float    "amount"
    t.datetime "appointment_body"
    t.datetime "appointment_dental"
    t.datetime "appointment_vision"
    t.string   "provider_body"
    t.integer  "provider_dental"
    t.integer  "provider_vision"
    t.string   "txnid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", force: true do |t|
    t.string   "code"
    t.string   "title"
    t.string   "poc"
    t.text     "description"
    t.string   "email"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_details", force: true do |t|
    t.string   "txnid"
    t.string   "status"
    t.float    "amount"
    t.string   "mihpayid"
    t.string   "mode"
    t.float    "discount"
    t.string   "checksum"
    t.string   "error"
    t.string   "pg_type"
    t.string   "bank_ref_num"
    t.string   "unmappedstatus"
    t.string   "payumoney_id"
    t.integer  "package_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prescriptions", force: true do |t|
    t.integer  "vision_assessment_id"
    t.string   "lens_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedures", force: true do |t|
    t.string   "procedure"
    t.string   "procedure_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promo_codes", force: true do |t|
    t.string   "code"
    t.integer  "customer_id"
    t.integer  "promotion_id"
    t.integer  "staff_id"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partner_id"
  end

  create_table "promotions", force: true do |t|
    t.string   "prefix"
    t.string   "title"
    t.string   "description"
    t.date     "start_date"
    t.date     "expiry_date"
    t.integer  "generate_codes"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provider_tests", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "mrp"
    t.float    "cost"
    t.float    "discount"
    t.integer  "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "selling_price"
    t.string   "service_type"
  end

  create_table "providers", force: true do |t|
    t.string   "name"
    t.string   "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider_id"
    t.string   "provider_type"
    t.string   "branch"
    t.string   "poc"
    t.string   "offline_number"
    t.string   "email"
    t.integer  "enterprise_id"
  end

  create_table "reactions", force: true do |t|
    t.integer  "allergy_id"
    t.string   "reaction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommendations", force: true do |t|
    t.integer  "recommend_id"
    t.string   "recommend_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
  end

  create_table "results", force: true do |t|
    t.integer  "examination_id"
    t.string   "dentition"
    t.integer  "tooth_number"
    t.text     "diagnosis"
    t.text     "recommendation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risk_factors", force: true do |t|
    t.string   "Name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "staff", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_salt"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin_id"
    t.string   "admin_type"
  end

  create_table "standard_ranges", force: true do |t|
    t.integer "test_component_id"
    t.string  "gender"
    t.string  "range_value"
    t.string  "age_limit"
    t.string  "age_male_range_value"
    t.string  "age_female_range_value"
    t.integer "enterprise_id"
  end

  create_table "test_components", force: true do |t|
    t.string   "name"
    t.string   "units"
    t.integer  "lab_test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "info"
    t.integer  "enterprise_id"
  end

  create_table "timelines", force: true do |t|
    t.string   "activity_type"
    t.string   "action"
    t.text     "text"
    t.integer  "associated_id"
    t.integer  "customer_id"
    t.string   "title"
    t.text     "description"
    t.string   "badge"
    t.text     "url"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assessment_activity_id"
    t.string   "integer"
  end

  create_table "vision_components", force: true do |t|
    t.string   "ucva"
    t.string   "cylindrical"
    t.string   "spherical"
    t.string   "axis"
    t.string   "prism"
    t.string   "add"
    t.string   "cva"
    t.integer  "correction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "units"
    t.string   "prism2"
    t.string   "units2"
  end

  add_index "vision_components", ["correction_id"], name: "index_vision_components_on_correction_id", using: :btree

  create_table "vital_lists", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vitals", force: true do |t|
    t.integer  "customer_id"
    t.integer  "vital_list_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
