task :default => [:dataframes, :theoretical_delta]

task :dataframes => FileList["*.hdf5"].ext(".csv")

task :aggregate => FileList["*.hdf5"].ext(".db")

task :by_pixel => FileList["*.hdf5"].ext("-by-pixel.db")

rule '.csv' => ['.hdf5', 'hdf52dataframe.py'] do |t|
  sh "python #{t.prerequisites[1]} #{t.source} > #{t.name}"
end

task :theoretical_delta => "deltas_table.npy"

file "deltas_table.npy" => "theoretical_delta.py" do |t|
  sh "python #{t.source} -bo #{t.name}"
end

rule '.json' => [
  proc {|task_name| "#{task_name.sub('.json', '-by-pixel.db')}"},
  proc {|task_name| "#{task_name.sub('.json', '-inv-by-pixel.db')}"},
  'subtract_phase.R'] do |t|
  sh "./#{t.prerequisites[2]} -b -f #{t.prerequisites[0]} -s #{t.prerequisites[1]}"
end

rule '-by-pixel.db' => [proc {|task_name| "#{task_name.sub('-by-pixel', '')}"}, 'phase_value_by_pixel.R'] do |t|
  sh "./#{t.prerequisites[1]} -f #{t.source}"
end

rule '.db' => ['.csv', 'aggregate.R'] do |t|
  sh "./#{t.prerequisites[1]} -b -f #{t.source}"
end
