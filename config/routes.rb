Rails.application.routes.draw do

  namespace :customers do
  get 'customer_information/update'
  end

  namespace :customers do
    get 'customer_lab_results/update'
    put 'customer_lab_results/update_blood_sugar'
    put 'customer_lab_results/edit'=>'customer_lab_results#update'

    get 'customer_information/show'
    get 'customer_information/hypertension_prediction_values'
    get 'customer_information/lab_result_values'
    get 'customer_information/get_message_prompts'
    post 'customer_information/update'
    put 'customer_information/update_customer_vitals'
  end

  namespace :staff do
    get 'enterprise_statistics_data/index'
  end

  namespace :staff do
    get 'enterprise_statistics/index'
  end

  namespace :staff do
    get 'statistics_data/index'
    get 'statistics_data/customers_vital_data'
    get 'statistics_data/document_upload_status_data'
    get 'statistics_data/appointments_data'
  end

  namespace :staff do
    get 'staff_charts/index'
    get 'staff_charts/assessments_not_done'
    get 'staff_charts/unverified_emails'
    get 'staff_charts/abnormal_bp'
  end



  namespace :staff do
    get 'staff_analysis/get_stats'
  end

  get 'customer_vitals/update'

  namespace :staff do
    get 'promo_codes/new'
  end

  namespace :staff do
    get 'promo_codes/index'
  end

  namespace :staff do
    get 'promo_codes/show'
  end

  namespace :staff do
    get 'promotions/new'
  end

  namespace :staff do
    get 'promotions/index'
  end

  namespace :staff do
    get 'promotions/show'
  end

  namespace :staff do
    get 'partners/new'
  end

  namespace :staff do
    get 'partners/index'
  end

  namespace :staff do
    get 'partners/show'
  end


  match '*any' => 'application#options', :via => [:options]
  get '/ad1' => 'landing#ad1'
  get '/ad1/thankyou' => 'landing#ad1_thankyou'

  namespace :customers do
    get 'dashboard' => 'dashboard#show'
    get 'documents' => 'documents#index'
    get 'health_assessments' => 'health_assessments#index'
    get 'health_assessment' => 'health_assessments#show'
    get 'timeline' => 'time_line#show'
    get 'profile' => 'profile#show'
    get 'immunizations' => 'immunizations#index'
    resources :immunizations, only: [:new, :create, :update, :destroy]
    resources :allergies, only: [:new, :create, :show, :update, :destroy]
    resources :medications, only: [:new, :create, :update, :destroy]
    resources :family_medical_histories, only: [:new, :create, :update, :destroy]
    patch 'upload/avatar' => 'profile#upload_avatar', as: :upload_avatar
    get 'medications' => 'medications#index'
    get 'allergies' => 'allergies#index'
    get 'family_medical_histories' => 'family_medical_histories#index'
    patch 'profile/edit' => 'profile#update'
    # get 'new_family_medical_history' => 'family_medical_histories#new'
    post 'upload_documents' => 'after_signup#upload_documents'
    delete 'delete_documents/:id' => 'documents#delete', as: :customer_documents_delete
    put 'customer_vitals/edit' => 'customer_vitals#update'
  end

  resources :after_signup, controller: 'customers/after_signup'

  resources :customers, only: [] do
    resources :documents, only: [:create], controller: 'customers/documents'
  end

  devise_for :online_customers, class_name: 'Customer', :controllers => {omniauth_callbacks: 'omniauth_callbacks',
                                                                         registrations: 'customers/registrations',
                                                                         confirmations: 'customers/confirmations',
                                                                         sessions: 'customers/sessions'}
  devise_scope :online_customer do
    get 'doctors_signin' => 'customers/sessions#sign_in_doctor'
  end

  resources :home do
    collection do
      get :index, :dashboard, :provider_address
      post :send_sms
    end
  end

  resources :about do
    collection do
      get :faq, :about_us, :contact_us, :terms_and_conditions, :team, :doctors,:advisors
    end
  end

  namespace :customers do
    get 'dashboard/show'
    get 'packages' => 'packages#index'
    get 'packages/learnmore' => 'packages#learnmore'
    get 'venus' => 'venus#index'
    patch 'apply_coupon' => 'venus#apply_coupon_code'
    patch 'venus/edit' => 'venus#update'
    post 'payment_success' => 'payment_success#index'
    post 'payment_failed' => 'payment_failed#index'
    post 'package_details' => 'package_details#create'
    get 'inbox' => 'dashboard#inbox'
    get 'appointments' => 'dashboard#appointments'
    post 'send_otp' => 'otp#generate_otp'
    get 'dashboard/share_with_doctor'
    post 'dashboard/send_to_doctor'
  end

  resources :blog, controller: 'blog_posts', only: [:show, :index]

  get 'blog/tags/:id' => 'blog_posts#tags'

  namespace :staff do
    resources :test_component, controller: 'test_components', only: [:new]
    resources :blog_posts
    resources :providers
    resources :provider_tests
    resources :partners
    resources :enterprises
    resources :promotions
    resources :promo_codes
    resources :sessions, only: [:new, :create], path_names: {new: 'signin'}, path: '/'
    delete 'signout', to: 'sessions#destroy'
    get 'dashboard' => 'dashboard#show'
    get 'enterprise_login' => 'enterprise_login#show'
    get 'provider_login' => 'provider_login#show'
    get 'lab_test_dump' => 'enterprises#lab_test_dump'
    resources :customer_enterprise, controller: 'customer_enterprise', only: [:show, :index]
    resources :customer_provider, controller: 'customer_provider', only: [:show, :index]
    resources :password_reset, controller: 'password_reset', only: [:new, :update]
  end

  namespace :providers do
    resources :sessions, only: [:new, :create], path_names: {new: 'signin'}, path: '/'
    delete 'signout', to: 'sessions#destroy'
    get 'dashboard' => 'dashboard#show'
  end

  resources :customers, only: [:new, :create, :show, :index, :update], controller: 'staff/customers' do
    resources :customers_allergies, only: [:new, :index, :create, :update, :destroy], controller: 'staff/customers_allergies'
    resources :customers_immunizations, only: [:new, :index, :create, :update, :destroy], controller: 'staff/customers_immunizations'
    resources :customers_medications, only: [:new, :index, :create, :update, :destroy], controller: 'staff/customers_medications'
    resources :medical_records, only: [:create, :destroy], controller: 'staff/medical_records'
    resources :customers_appointments, only: [:create, :update, :destroy], controller: 'staff/customers_appointments'
    resources :customers_family_medical_histories, only: [:new, :index, :create, :update, :destroy], controller: 'staff/customers_family_medical_histories'
    resources :customers_promo_codes_histories, only:[:new, :index, :create, :update, :destroy],controller: 'staff/customers_promo_codes_histories'
    resources :health_assessments, only: [:create, :update, :destroy, :show], controller: 'staff/health_assessments'
    resources :health_assessments, controller: 'staff/health_assessments' do
      resources :notes, controller: 'staff/health_assessments/notes', only: [:index]
    end
  end

  get "/customers_dashboard" => "customers/customers#dashboard"


  resources :customers_allergies, only: [:show], controller: 'staff/customers_allergies'

  resources :health_assessments, only: [:new, :index], controller: 'staff/health_assessments' do
    resources :notes, controller: 'staff/health_assessments/notes', only: [:create, :destroy]
    resources :lab_results, controller: 'staff/health_assessments/lab_results'
    resources :results, controller: 'staff/health_assessments/results'
    resources :recommendations, only: [:index, :create, :update, :destroy], controller: 'staff/health_assessments/recommendations'
    resources :medical_records, only: [:create, :destroy], controller: 'staff/medical_records'
    resource :prescription, only: [:index, :create, :update, :destroy], controller: 'staff/health_assessments/prescriptions' do
    end
  end

  resources :lab_tests, only: [:index], controller: 'staff/health_assessments/lab_tests' do
    resources :test_components, only: [:index], controller: 'staff/health_assessments/test_components'
  end

  namespace :staff, path: '/' do
    get 'health_assessments/all'
  end

  get "/provider/:id" => "staff/providers#provider_address", as: :provider_address
  # root 'staff/dashboard#show'
  root :to => 'home#index'

  scope '/api' do
    scope '/v1' do
      scope '/document' do
        get '/' => 'customers/api#document'
      end
      scope '/me' do
        get '/' => 'customers/api#profile'
      end
      scope '/customerzz' do
        get '/' => 'customers/api#getCustomers'
      end
      scope '/login' do
        post '/' => 'customers/api#login'
      end
      scope '/login_otp' do
        post '/' => 'customers/api#login_otp'
      end
      scope '/upload' do
        post '/' => 'customers/api#upload_documents'
        end
      scope '/update_customer' do
        post '/' => 'customers/api#update_customer'
      end
      scope '/upload_image' do
        post '/' => 'customers/api#upload_avatar'
      end
      scope '/update_customer_vitals' do
        post '/' => 'customers/api#update_customer_vitals'
      end
      scope '/blood_groups' do
        get '/' => 'customers/api#blood_groups'
      end
      scope '/enterprise/lab_test/test_components' do
        get '/' => 'staff/health_assessments/test_components#getTestComponents'
      end
      scope '/enterprise/lab_test/test_component/standard_range/update' do
        post '/' => 'staff/health_assessments/test_components#updateStandardRange'
      end
      scope '/enterprise/lab_test/test_component/add' do
        post '/' => 'staff/health_assessments/test_components#addTestComponent'
      end
      scope '/enterprise/lab_test/test_component/standard_range/delete' do
        delete '/' => 'staff/health_assessments/test_components#deleteStandardRange'
      end
      scope '/enterprise/lab_tests' do
        get '/' => 'staff/health_assessments/lab_tests#getLabTests'
      end
      scope '/enterprise/lab_test/update' do
        post '/' => 'staff/health_assessments/lab_tests#updateLabTest'
      end
      scope '/enterprise/lab_test/add' do
        post '/' => 'staff/health_assessments/lab_tests#addLabTest'
      end
      scope '/enterprise/lab_test/delete' do
        delete '/' => 'staff/health_assessments/lab_tests#deleteLabTest'
      end
      scope '/score_graph' do
        get '/' => 'customers/api#score_graph'
      end
      scope '/timeline' do
        get '/' => 'customers/api#timeline'
      end
      scope '/family_medical_history' do
        post '/' => 'customers/api#family_medical_history'
      end
      scope '/body_assessment_list' do
        get '/' => 'customers/api#body_assessment_list'
      end
      scope '/body_assessment' do
        get '/' => 'customers/api#body_assessment'
      end
    end
  end
end
