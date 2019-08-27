require_relative 'utils/oz_loader'

ENV['OZ_CORE_DIR'] ||= __dir__
Oz::OzLoader.world = self
Oz::OzLoader.load