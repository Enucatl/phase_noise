require 'rake/clean'

task :default => [
  :theoretical_delta,
  :dataframes,
  :aggregate,
  :by_pixel,
  :json,
  "by-pixel.csv",
  :plot
]

task :dataframes => FileList["*.hdf5"].ext(".csv")

task :aggregate => FileList["*.hdf5"].ext(".db")

task :by_pixel => FileList["*.hdf5"].pathmap("%X-by-pixel.db")

task :json => FileList["*.hdf5"].exclude("*-inv.hdf5").ext(".json")

task :json => :by_pixel
task :by_pixel => :aggregate
task :aggregate => :dataframes
task :plot => ["plot.R", :by_pixel] do |t|
  sh "./#{t.prerequisites[0]} -f by-pixel.csv"
end

file "by-pixel.csv" => FileList["*.hdf5"].ext(".db").include("visibility.R") do |t|
  sh "./#{t.prerequisites[-1]} -f #{t.prerequisites[0..-2].join(" ")} -o by-pixel.csv"
end

CLEAN.include FileList["*.hdf5"].pathmap("%X-by-pixel.db")
CLEAN.include FileList["*.hdf5"].ext(".db")
CLEAN.include FileList["*.hdf5"].ext(".csv")
CLOBBER.include FileList["*.hdf5"].ext(".json")
CLOBBER << "by-pixel.csv"

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

rule '-by-pixel.db' => [
  proc {|task_name| "#{task_name.sub('-by-pixel', '')}"},
  'phase_value_by_pixel.R'] do |t|
  sh "./#{t.prerequisites[1]} -f #{t.source}"
end

rule '.db' => ['.csv', 'aggregate.R'] do |t|
  sh "./#{t.prerequisites[1]} -b -f #{t.source}"
end
