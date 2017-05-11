json.gases @data.each do |d|
  json.gas d.gas_name

  unless d.conc_ppm.nil?
    json.ppm d.conc_ppm
  end

  unless d.conc_ugm3.nil?
    json.ugm3 d.conc_ugm3
  end
end
