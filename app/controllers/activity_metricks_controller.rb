class ActivityMetricksController < SendToFluentController
  def collect_steps
    return if send_fitbit_timing?

    fitbit = Fitbit.new unit_system: 'METRIC'
    return if fitbit.errors?

    fluent_logger('a-know-metricks').post('activity',
      {
        todays_steps: fitbit.todays_steps,
      }
    )
  end
end