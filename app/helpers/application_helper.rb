module ApplicationHelper
  def formatted_date date
    date.strftime("%b %d, %Y") rescue '-'
  end

  def formatted_dates dates
    formatted_dates = dates.inject([]) do |formatted_dates, date|
      formatted_dates << date.strftime("%b %d, %Y") unless date.nil?
    end
    formatted_dates
  end

  def numeric_date_format date
    #12-07-2012
    date.strftime("%d-%m-%Y") rescue ''
  end

  def padding_zeros val, padder
    val.to_s.rjust(padder, '0')
  end

  def month_name date
    date.strftime("%b") rescue '-'
  end

  def year_name date
    date.strftime("%Y") rescue '-'
  end

  def time_stamp date
    date.strftime("%I:%M") rescue '-'
  end

  def day date
    date.strftime("%d")
  end

  def am_pm date
    date.strftime("%p") rescue '-'
  end

  def full_time date
    date.strftime("%I:%M %p") rescue '-'
  end

  def random_index(index, num)
    index%num
  end

  def is_empty? object
    object.nil? || object.strip.empty? rescue true
  end

  def get_percentage current,total
    percentage_in_float=(current.to_f/total.to_f)*100 rescue 0
    percentage_in_int=percentage_in_float.to_i rescue '-'
  end

  def to_string(checkbox)
    begin
      str=''
      checkbox.each do |value|
        str=str+','+value
      end
      return str
    rescue
      '-'
    end
  end
end
