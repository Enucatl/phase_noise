hdf52dataframe = 'hdf52dataframe.py'

task :default => [:dataframes, :theoretical_delta]

task :dataframes => FileList["*.hdf5"].ext(".csv")

task :aggregate => FileList["*.hdf5"].ext(".db")

task :by_pixel => FileList["*.hdf5"].ext("-by-pixel.db")

rule '.csv' => ['.hdf5', hdf52dataframe] do |t|
  sh "python #{hdf52dataframe} #{t.source} > #{t.name}"
end

task :theoretical_delta => "deltas_table.npy"

file "deltas_table.npy" => "theoretical_delta.py" do |t|
  sh "python #{t.source} -bo #{t.name}"
end

rule '.db' => ['.csv', 'aggregate.R'] do |t|
  sh "./aggregate.R -f #{t.source}"
end

rule '-by-pixel.db' => ['.db', 'phase_value_by_pixel.R'] do |t|
  sh "./phase_value_by_pixel.R -f #{t.source}"
end
