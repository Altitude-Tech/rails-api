json.gases @data.each do |d|

  json.gas d.gas_name

  unless d.conc_ppm.nil?
    json.conc_ppm d.conc_ppm.round(4)
  end

  unless d.conc_ugm3.nil?
    json.conc_ugm3 d.conc_ugm3.round(4)
  end
end
