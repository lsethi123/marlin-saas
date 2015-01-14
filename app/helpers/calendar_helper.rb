module CalendarHelper
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  def booking_calendar(options={}, &block)
    default_options = {
      start_date: Date.today,
      number_months: 3
    }
    options = default_options.merge(options)
    BookingCalendar.new(self, options, block).render
  end

  # Booking Calendar
  class BookingCalendar < Struct.new(:view, :options, :callback)
    HEADER = %w[S M T W T F S]
    START_DAY = :sunday

    delegate :content_tag, to: :view

    def render
      r = ''
      months = []
      options[:number_months].times{|i| months << options[:start_date] + i.months}
      months.each do |mday|
        r << month_table(mday)
      end
      r.html_safe
    end

    def month_table(mday)
      content_tag :div, class: 'parent_calendar' do        
        content_tag :table, class: 'calendar' do
          month_title(mday) + header + week_rows(mday)
        end
      end
    end

    def month_title(mday)
      content_tag :caption, mday.strftime("%B %Y")
    end

    def header
      content_tag :thead do
        content_tag :tr do
          HEADER.map { |day| content_tag :th, day }.join.html_safe
        end
      end
    end

    def week_rows(mday)
      content_tag :tbody do
        weeks(mday).map do |week|
          content_tag :tr do
            week.map { |day| day_cell(day, mday) }.join.html_safe
          end
        end.join.html_safe
      end
    end

    def day_cell(day, mday)
      _match = options[:occupied_src].select do |item|
        range = item[:in]..item[:out]
        range === day
      end
      if found_match = _match.try(:first)
        if day == found_match[:in]
          extra_classes = 'occupied_check_in avail' 
        elsif day == found_match[:out]        
          extra_classes = 'occupied_check_out avail'
        else
          extra_classes = 'occupied'
        end
      else
        extra_classes = 'avail'
      end 
      default_opts =  {class: day_classes(day, mday, extra_classes), dt: day.strftime('%Y%m%d') }
      opts = found_match.nil? ? {} : {'data-booking-id' => found_match[:id]}
      opts = default_opts.merge(opts)

      content_tag :td, day.day, opts
    end

    def day_classes(day, mday, extra=nil)
      classes = []
      classes << "today" if day == Date.today
      classes << "notmonth" if day.month != mday.month
      classes << extra if extra.present?
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks(date)
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      # last = date.end_of_week(START_DAY)  # only for debugging
      (first..last).to_a.in_groups_of(7)
    end
  end

  # Simple calendar
  class Calendar < Struct.new(:view, :date, :callback)
    HEADER = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    START_DAY = :sunday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header + week_rows
      end
    end

    def header
      content_tag :thead do
        content_tag :tr do
          HEADER.map { |day| content_tag :th, day[0] }.join.html_safe
        end
      end
    end

    def week_rows
      content_tag :tbody do
        weeks.map do |week|
          content_tag :tr do
            week.map { |day| day_cell(day) }.join.html_safe
          end
        end.join.html_safe
      end
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Date.today
      classes << "notmonth" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end