namespace :database do
  desc "fix seq ids"
  task correction_seq_id: :environment do
    ActiveRecord::Base.connection.tables.each do |t|
         ActiveRecord::Base.connection.reset_pk_sequence!(t)
     end
  end
end
