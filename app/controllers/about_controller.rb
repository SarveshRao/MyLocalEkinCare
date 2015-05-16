class AboutController < ApplicationController
  layout :layout_by_resource

  def faq
    @active_tab="faq"
  end

  def about_us
    @active_tab="about_us"
  end

  def contact_us
    @active_tab="contact_us"
  end

  def terms_and_conditions
    @active_tab="terms_and_conditions"
  end

  def team
    @active_tab="team"
  end

  def doctors
    @active_tab="doctors"
  end

  def advisers
    @active_tab="advisers"
  end
end
