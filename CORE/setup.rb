require_relative 'utils/oz_loader'

ENV['OZ_CORE_DIR'] ||= __dir__

OzLoader.world = self
OzLoader.load