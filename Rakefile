hdf52dataframe = 'hdf52dataframe.py'

task :default => [:dataframes, :theoretical_delta]

task :dataframes => FileList["*.hdf5"].ext(".csv")

rule '.csv' => ['.hdf5', hdf52dataframe] do |t|
  sh "python #{hdf52dataframe} #{t.source} > #{t.name}"
end

task :theoretical_delta do
  file "deltas_table.npy" => "theoretical_delta.py" do |t|
    sh "python #{t.source} -b -o #{t.name}"
  end
end
