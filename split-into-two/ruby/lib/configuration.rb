class Configuration
  attr_accessor :ui, :hardware, :starting_value
  def self.create; new; end

  def initialize
    # Who holds the starting value isn't yet decided.
    # Database? Persistent value in hardware? Both?
    # For now, have the configuration inject it.

    @ui = ValueTweaker.new
    @hardware = Hardware.new
    @controller = Controller.new(value_tweaker: @ui,
                                 hardware: @hardware,
                                 setting_changing_page: ValueSettingPage.new,
                                 starting_value: @starting_value = 50,
                                 allowed_range: (0..100))

    @ui.add_listener(@controller)
    @hardware.add_listener(@controller)
  end
end