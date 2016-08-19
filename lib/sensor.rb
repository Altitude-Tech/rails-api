##
# mq135 specific functions may or may not work more generally
# but they've been named as such for now just in case
##
module Sensors
  ##
  # Number of bits the ADC can hold
  ##
  ADC_BITS = 12

  ##
  # Max value of the ADC
  ##
  ADC_MAX = (2**ADC_BITS) - 1

  ##
  # Load resistance on the board in Ohms
  ##
  LOAD_RESISTANCE = 10_000

  ##
  # Parameters to model temperature and humidity dependence
  #
  # <https://github.com/GeorgK/MQ135/blob/master/MQ135.h>
  # @todo check these
  #
  # seem to have been aquired from a power function?
  # f(x) = a* x**b
  ##
  MQ135_CORA = 0.00035
  MQ135_CORB = 0.02718
  MQ135_CORC = 1.39538
  MQ135_CORD = 0.0018

  ##
  #
  # See <notes/SENSOR_RESISTANCE.md> for how this is derived.
  #
  # Params:
  #   adc_value (Number):
  #
  # Returns:
  #   (Number):
  ##
  def get_mq135_resistance(adc_value)
    return (LOAD_RESISTANCE / ((ADC_MAX / adc_value) - 1))
  end

  ##
  #
  #
  # Params:
  #   temperature (Number):
  #   humidity (Number):
  #
  # Returns:
  #   (Number):
  ##
  def get_mq135_correction_factor(temperature, humidity)
    # quadratic curve
    return (CORA * temperature**2) - (CORB * t) + (CORC - (CORD * (humidity - 33)))
  end

  ##
  #
  #
  # Params:
  #   adc_value (Number):
  #   temperature (Number):
  #   humdity (Number):
  #
  # Returns:
  #   (Number):
  ##
  def get_mq135_corrected_resistance(adc_value, temperature, humidity)
    resistance = get_mq135_resistance(adc_value)
    correction_factor = get_mq135_correction_factor(temperature, humidity)

    return resistance / correction_factor
  end

  ##
  #
  ##
  def convert_adc_to_gases(sensor, adc_value)
    # see config/initializers/constants.rb for sensor type constants
    # check which sensor type it is
    # redirect to correct function
    # or raise an error if it's not found
  end

  private

  ##
  #
  ##
  def convert_mq2_adc(adc_value)
  end

  ##
  #
  ##
  def convert_mq7_adc(adc_value)
  end

  ##
  #
  ##
  def convert_mq135_adc(adc_value)
  end
end
