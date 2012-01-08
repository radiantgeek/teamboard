module Utils

  def getTime(time)
    time.time.strftime("%d.%m.%y %H:%I")
  end

  def markRed(value, condition)
    value = ("<font color='red'>"+value+"</font>") if condition
    value
  end

  #
  def flat(list)
    ids = Array.new
    list.each { |i| ids.push((i.is_a? Range) ? i.to_a : i) }
    ids.flatten
  end

  #
  def strip_tags(str)
    str.gsub(/<\/?[^>]*>/, "")
  end

end