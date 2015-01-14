window.BookingsCalendar =

  clean_selection: ->
    $('.calendar').find('.new_bk').removeClass('new_bk')
    $('.calendar').find('.new_co').removeClass('new_co')
    $('.calendar').find('.new_co_ci').removeClass('new_co_ci')
    $('.calendar').find('.new_ci').removeClass('new_ci')
    $('.calendar').find('.new_ci_co').removeClass('new_ci_co')

  clean_after_co: ->
    BookingsCalendar.clean_selection()    

ready_booking_calendar = ->
  
  # $('.calendar .occupied').tooltip
  #   placement: 'top'
  #   trigger: 'hover'
  #   container: 'body'
  new_check_in = null
  new_check_out = null

  $('.calendar .avail').hover ->
    if new_check_in != null
      selected_dt = parseInt($(@).attr('dt'))
      BookingsCalendar.clean_selection()
      i = parseInt(new_check_in)
      if selected_dt > new_check_in 
        if $('.calendar [dt="' + i + '"]').hasClass('occupied_check_out')
          $('.calendar [dt="' + i + '"]').addClass('new_ci_co')
        else
          $('.calendar [dt="' + i + '"]').addClass('new_ci')
        while (i <= selected_dt)
          $cell = $('.calendar [dt="' + i + '"]')
          if $cell.length
            break if $cell.hasClass('occupied')
            if i == selected_dt
              $cell.addClass('new_co')
              new_check_out = i
            if $cell.hasClass('occupied_check_in')
              $cell.addClass('new_co_ci')
              new_check_out = i
            else
              $cell.addClass('new_bk')
          i++
      else
        $('.calendar [dt="' + i + '"]').addClass('new_co')
        while (i >= selected_dt)
          $cell = $('.calendar [dt="' + i + '"]')
          if $cell.length
            break if $cell.hasClass('occupied')
            if i == selected_dt
              $cell.addClass('new_ci')
              new_check_out = i
            if $cell.hasClass('occupied_check_out')
              $cell.addClass('new_ci_co')
              new_check_out = i
            else
              $cell.addClass('new_bk')
          i--


  $('.calendar .avail').click ->
    if new_check_in == null
      if !$(@).hasClass('occupied_check_in')
        if $(@).hasClass('occupied_check_out')
          $(@).addClass('new_ci_co')
        else
          $(@).addClass('new_ci')
        new_check_in = $(@).attr('dt')
    else 
      alert "check in: " + new_check_in + " - check out: " + new_check_out
      new_check_in = null      
      BookingsCalendar.clean_after_co()

$(document).ready ->  
  ready_booking_calendar()

$(document).on('page:load', ready_booking_calendar)