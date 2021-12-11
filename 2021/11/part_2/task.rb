require 'common/base_task'
require 'set'

class Task < BaseTask

  def run
    energy = @input_array.map {|r| r.chars.map(&:to_i)}
    step = 0
    in_sync = false

    while !in_sync do
      step += 1
      new_energy_levels = tick(energy)
      in_sync = new_energy_levels.map { |r| r.map {|c| c == 0 }.all? }.all?
      energy = new_energy_levels
    end

    energy.each { |r| puts r.to_s }

    @answer = step
  end

  def tick(energy)
    
    new_energy_levels = increase_energy_levels(energy)

    rows = energy.length
    cols = energy[0].length
    flashed = Set.new
    has_not_flashed = false

    while !has_not_flashed do
      has_not_flashed = true
      [*0..rows-1].each do |row|
        [*0..rows-1].each do |col|
          if new_energy_levels[row][col] > 9
            added = flashed.add?([row, col])
            if !added.nil?
              has_not_flashed = false
              new_energy_levels = flash_position(new_energy_levels, row, col)
            end
          end
        end
      end
    end

    [*0..rows-1].each do |row|
      [*0..rows-1].each do |col|
        new_energy_levels[row][col] = 0 if new_energy_levels[row][col] > 9
      end
    end

    new_energy_levels
  end

  def flash_position(energy, row, col)
    positions = [[row, col], [row-1, col], [row+1, col], [row, col-1], [row, col+1], [row-1, col-1], [row-1, col+1], [row+1, col-1], [row+1, col+1]]
    rows = energy.length
    cols = energy[0].length
    
    positions.each do |r, c|
      next if r < 0 || r >= rows
      next if c < 0 || c >= cols
      energy[r][c] += 1
    end

    energy

  end

  def increase_energy_levels(current)
    current.map { |r| r.map {|c| c+=1}}
  end

end