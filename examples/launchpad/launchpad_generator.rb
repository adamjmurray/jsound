# A device for controlling a Novation Launchpad
# To try this example, do this from the top-level project folder
=begin

  jirb -I lib
  require 'jsound'
  require 'examples/launchpad/launchpad_generator.rb'
  include JSound::Midi
  lp = OUTPUTS.Launchpad
  g = LaunchpadGenerator.new
  g >> lp

  g.all_off
    
  # Make the top left grid button green:
  g.grid(0,0,:green)
  
  # Make the mixer button red:
  g.mixer(:red)
  
  # Make the second 'scene launch' (rightmost column of buttons) orange:
  g.scene_launch(2,:orange)
  
  # and we can also do yellow:
  g.grid(1,1,:yellow)
  
  # and arbitrary mixtures of green and red LEDs (brightness levels for each range from 0-3)
  g.grid(2,2,[1,1])
    
  at_exit { g.all_off } # this will turn everything off when you exit irb
  
=end

class LaunchpadGenerator < JSound::Midi::Devices::Generator
  
  def grid(x,y,color=3)
    x = clip(x,0,15)
    y = clip(y,0,7)
    c = color_value(color)
    note_on(16*y + x, c)
  end

  def scene_launch(position,color=3)
    grid(8,position,color)
  end


  def control_row(position,color=3)
    c = color_value(color)
    p = 104 + clip(position,0,7)
    control_change(p,c)
  end

  def up(     color=3); control_row(0,color) end
  def down(   color=3); control_row(1,color) end
  def left(   color=3); control_row(2,color) end
  def right(  color=3); control_row(3,color) end
  def session(color=3); control_row(4,color) end
  def user1(  color=3); control_row(5,color) end
  def user2(  color=3); control_row(6,color) end
  def mixer(  color=3); control_row(7,color) end

  def all_on(brightness=3)
    # convert brightness values 0,1,2,3 to 0,125,126,127
    # (0=off, 125=low, 126=med, 127=high)
    b = clip(brightness,0,3)
    b += 124 if b > 0
    control_change(0,b)
  end

  def all_off
    control_change(0,0)
  end

  def duty_cycle(numerator,denominator)
    n = clip(numerator,1,16)
    d = clip(denominator,3,18)
    if n < 9
      control_change(30, 16*(n-1) + (d-3))
    else
      control_change(31, 16*(n-9) + (d-3))
    end
  end

  def clip(value,min,max)
    value = min if value.nil? or value < min
    value = max if value > max
    return value
  end

  def color_value(color)
    case color
    when Array
      g,r = color[0],color[1]
    when Numeric
      g,r = color,0
    else case color.to_s
      when 'green',  'g' then g,r = 3,0
      when 'yellow', 'y' then g,r = 3,2
      when 'amber',  'a' then g,r = 3,3    
      when 'orange', 'o' then g,r = 2,3
      when 'red',    'r' then g,r = 0,3 
      else g,r = 0,0     
      end
    end
    g = clip(g.to_i,0,3)
    r = clip(r.to_i,0,3)
    return 16*g + r
  end
  
end