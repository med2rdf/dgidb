require 'ruby-progressbar'

module ProgressBarWrapper
  def progress_bar(**options)
    opt = { format: '|%B| %J%% %a (%E)',
            length: 80 }.merge(options)

    opt[:output] = STDOUT.tty? ? STDOUT : File.open('/dev/null', 'w')

    opt[:unknown_progress_animation_steps] = %w[>=== =>== ==>= ===>]

    progress_bar = ProgressBar.create(opt)

    yield progress_bar
  ensure
    progress_bar.finish
  end
end
