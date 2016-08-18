##
# Constants
##

require 'digest'

##
# Gases
##
GAS_CARBON_MONOXIDE = 0
GAS_NITROGEN_DIOXIDE = 1
GAS_ALCOHOLS = 2
GAS_SMOKE = 3
GAS_TOXIC_GASES = 4
GAS_PM10 = 5
GAS_PM25 = 6

##
# Sensors
##
SENSOR_MQ2_HASH = Digest::SHA1.hexdigest('mq2')
SENSOR_MQ7_HASH = Digest::SHA1.hexdigest('mq7')
SENSOR_MQ135_HASH = Digest::SHA1.hexdigest('mq135')

SENSOR_HASHES = [SENSOR_MQ2_HASH, SENSOR_MQ7_HASH, SENSOR_MQ135_HASH].freeze
